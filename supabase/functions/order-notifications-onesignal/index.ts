import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as OneSignal from "https://esm.sh/@onesignal/node-onesignal@5.0.0-alpha-01";

interface OrderRecord {
  id: string;
  service_title: string;
  booking_date: string;
  total_amount: number;
  status: string;
  vendor_id?: string;
  customer_name?: string;
  customer_phone?: string;
  service_type?: string;
  location?: string;
  created_at?: string;
  updated_at?: string;
}

interface WebhookPayload {
  type: 'INSERT' | 'UPDATE' | 'DELETE';
  table: string;
  record?: OrderRecord;
  old_record?: OrderRecord;
  schema: string;
}

// Initialize OneSignal configuration
const ONESIGNAL_APP_ID = "49c2960f-3ac3-4542-9348-dd1248a273f3";
const ONESIGNAL_REST_API_KEY = "os_v2_app_jhbjmdz2yncufe2i3ujeritt6m5lejyy5ktud25fp7zknzvgfae2ikijmfpglh2ip4cynizph6tvehpao73rfvj3zdskjczvyc4at2q";

// Create OneSignal configuration
const oneSignalConfig = OneSignal.createConfiguration({
  authMethods: {
    rest_api_key: {
      tokenProvider: {
        getToken(): string {
          return ONESIGNAL_REST_API_KEY;
        }
      }
    }
  }
});

const oneSignalClient = new OneSignal.DefaultApi(oneSignalConfig);

// Function to create notification for new order
function createNewOrderNotification(order: OrderRecord): OneSignal.Notification {
  const notification = new OneSignal.Notification();
  notification.app_id = ONESIGNAL_APP_ID;
  
  // Target specific vendor if vendor_id is available, otherwise all vendors
  if (order.vendor_id) {
    notification.include_external_user_ids = [order.vendor_id];
  } else {
    notification.included_segments = ['All'];
  }

  // Notification content
  notification.headings = { en: "🛎️ New Order Received!" };
  notification.contents = { 
    en: `New order for "${order.service_title}" - $${order.total_amount?.toFixed(2) || '0.00'}` 
  };

  // Rich notification data
  notification.data = {
    type: 'new_order',
    order_id: order.id,
    service_title: order.service_title,
    total_amount: order.total_amount?.toString() || '0',
    booking_date: order.booking_date,
    vendor_id: order.vendor_id || '',
    status: order.status,
    customer_name: order.customer_name || '',
    location: order.location || ''
  };

  // Platform-specific configurations
  notification.android_channel_id = "new_orders_channel";
  notification.priority = 10;
  notification.small_icon = "ic_notification";
  notification.large_icon = "https://your-app-domain.com/icons/order-icon.png";

  // Action buttons
  notification.buttons = [
    {
      id: "view_order",
      text: "View Order",
      icon: "ic_view"
    },
    {
      id: "accept_order", 
      text: "Accept",
      icon: "ic_check"
    }
  ];

  // iOS specific
  notification.ios_badge_type = "Increase";
  notification.ios_badge_count = 1;
  notification.ios_sound = "default";

  return notification;
}

// Function to create notification for order status update
function createOrderUpdateNotification(order: OrderRecord, oldRecord?: OrderRecord): OneSignal.Notification {
  const notification = new OneSignal.Notification();
  notification.app_id = ONESIGNAL_APP_ID;
  
  if (order.vendor_id) {
    notification.include_external_user_ids = [order.vendor_id];
  } else {
    notification.included_segments = ['All'];
  }

  // Determine notification content based on status change
  let title = "📋 Order Update";
  let message = `Order "${order.service_title}" status updated`;
  
  switch (order.status?.toLowerCase()) {
    case 'confirmed':
      title = "✅ Order Confirmed";
      message = `Order "${order.service_title}" has been confirmed`;
      break;
    case 'in_progress':
      title = "🔄 Order In Progress";
      message = `Work started on "${order.service_title}"`;
      break;
    case 'completed':
      title = "🎉 Order Completed";
      message = `Order "${order.service_title}" completed successfully`;
      break;
    case 'cancelled':
      title = "❌ Order Cancelled";
      message = `Order "${order.service_title}" has been cancelled`;
      break;
  }

  notification.headings = { en: title };
  notification.contents = { en: message };

  notification.data = {
    type: 'order_update',
    order_id: order.id,
    service_title: order.service_title,
    old_status: oldRecord?.status || '',
    new_status: order.status,
    vendor_id: order.vendor_id || '',
    total_amount: order.total_amount?.toString() || '0'
  };

  notification.android_channel_id = "order_updates_channel";
  notification.priority = 8;

  return notification;
}

// Function to log notification to Supabase for analytics
async function logNotification(
  supabase: any,
  orderId: string,
  notificationType: string,
  oneSignalResponse: any,
  error?: string
) {
  try {
    await supabase
      .from('notification_logs')
      .insert({
        order_id: orderId,
        notification_type: notificationType,
        onesignal_response: oneSignalResponse,
        error_message: error,
        created_at: new Date().toISOString()
      });
  } catch (logError) {
    console.error('Failed to log notification:', logError);
  }
}

// Main Edge Function handler
Deno.serve(async (req: Request) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      },
    });
  }

  try {
    console.log('🚀 OneSignal order notification function started');

    // Initialize Supabase client for logging
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Skip auth check for database triggers - they come from internal Supabase
    const authHeader = req.headers.get('authorization');
    const isInternalRequest = !authHeader || authHeader === 'Bearer undefined';
    
    if (!isInternalRequest) {
      // For external requests, validate the auth header
      const token = authHeader?.replace('Bearer ', '');
      if (!token) {
        console.error('❌ Missing authorization header for external request');
        return new Response(
          JSON.stringify({ error: 'Missing authorization header' }),
          { status: 401, headers: { 'Content-Type': 'application/json' } }
        );
      }
    }
    
    console.log(`📡 Request type: ${isInternalRequest ? 'Internal (Database Trigger)' : 'External (API Call)'}`);

    // Parse webhook payload
    const payload: WebhookPayload = await req.json();
    console.log('📨 Received webhook payload:', JSON.stringify(payload, null, 2));

    if (!payload.record) {
      console.error('❌ No record found in webhook payload');
      return new Response(
        JSON.stringify({ error: 'No record found in payload' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const order = payload.record;
    let notification: OneSignal.Notification;
    let notificationType: string;

    // Determine notification type based on webhook event
    if (payload.type === 'INSERT') {
      notification = createNewOrderNotification(order);
      notificationType = 'new_order';
      console.log('📬 Creating new order notification');
    } else if (payload.type === 'UPDATE') {
      notification = createOrderUpdateNotification(order, payload.old_record);
      notificationType = 'order_update';
      console.log('📝 Creating order update notification');
    } else {
      console.log('ℹ️ Ignoring DELETE event');
      return new Response(
        JSON.stringify({ message: 'DELETE events ignored' }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Send notification via OneSignal
    try {
      console.log('📤 Sending OneSignal notification...');
      const oneSignalResponse = await oneSignalClient.createNotification(notification);
      
      console.log('✅ OneSignal notification sent successfully:', oneSignalResponse);

      // Log successful notification
      await logNotification(supabase, order.id, notificationType, oneSignalResponse);

      return new Response(
        JSON.stringify({
          success: true,
          message: 'Notification sent successfully',
          order_id: order.id,
          notification_type: notificationType,
          onesignal_id: oneSignalResponse.id,
          recipients: oneSignalResponse.recipients,
          timestamp: new Date().toISOString()
        }),
        {
          status: 200,
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
          }
        }
      );

    } catch (oneSignalError) {
      console.error('❌ OneSignal error:', oneSignalError);
      
      // Log failed notification
      await logNotification(supabase, order.id, notificationType, null, oneSignalError.message);

      return new Response(
        JSON.stringify({
          success: false,
          error: 'Failed to send notification',
          details: oneSignalError.message,
          order_id: order.id,
          timestamp: new Date().toISOString()
        }),
        {
          status: 500,
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
          }
        }
      );
    }

  } catch (error) {
    console.error('❌ Edge Function error:', error);
    
    return new Response(
      JSON.stringify({
        success: false,
        error: 'Internal server error',
        details: error.message,
        timestamp: new Date().toISOString()
      }),
      {
        status: 500,
        headers: { 
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        }
      }
    );
  }
});