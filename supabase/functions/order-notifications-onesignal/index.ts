import "jsr:@supabase/functions-js/edge-runtime.d.ts";

// OneSignal Types
interface OneSignalResponse {
  id: string;
  recipients: number;
  external_id?: string;
  errors?: Array<{
    code: number;
    message: string;
  }>;
}

interface OrderRecord {
  id: string;
  service_title: string;
  booking_date: string;
  total_amount: number;
  status: string;
  vendor_id?: string;
  customer_name?: string;
  customer_phone?: string;
  booking_time?: string;
  service_duration?: number;
  location_address?: string;
  created_at?: string;
}

interface OneSignalNotificationPayload {
  app_id: string;
  include_external_user_ids?: string[];
  filters?: Array<{
    field: string;
    key?: string;
    relation: string;
    value: string;
  }>;
  headings: {
    en: string;
  };
  contents: {
    en: string;
  };
  data: Record<string, any>;
  android_channel_id?: string;
  priority?: number;
  small_icon?: string;
  large_icon?: string;
  ios_badgeType?: string;
  ios_badgeCount?: number;
  ios_sound?: string;
  android_sound?: string;
  web_buttons?: Array<{
    id: string;
    text: string;
    url?: string;
  }>;
  big_picture?: string;
  chrome_web_icon?: string;
  firefox_icon?: string;
  chrome_icon?: string;
  adm_big_picture?: string;
  chrome_big_picture?: string;
}

// Environment variables
const ONESIGNAL_APP_ID = Deno.env.get('ONESIGNAL_APP_ID') || '49c2960f-3ac3-4542-9348-dd1248a273f3';
const ONESIGNAL_REST_API_KEY = Deno.env.get('ONESIGNAL_REST_API_KEY') || 'os_v2_app_jhbjmdz2yncufe2i3ujeritt6m5lejyy5ktud25fp7zknzvgfae2ikijmfpglh2ip4cynizph6tvehpao73rfvj3zdskjczvyc4at2q';

/**
 * Send OneSignal notification using the official REST API
 * Following OneSignal + Supabase integration best practices
 */
async function sendOneSignalNotification(
  payload: OneSignalNotificationPayload
): Promise<{ success: boolean; response?: OneSignalResponse; error?: string }> {
  try {
    console.log('📤 Sending OneSignal notification:', JSON.stringify(payload, null, 2));
    
    const response = await fetch('https://onesignal.com/api/v1/notifications', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Basic ${ONESIGNAL_REST_API_KEY}`,
      },
      body: JSON.stringify(payload),
    });

    const responseData = await response.json() as OneSignalResponse;

    if (response.ok) {
      console.log('✅ OneSignal notification sent successfully:', responseData);
      return { success: true, response: responseData };
    } else {
      console.error('❌ OneSignal API error:', response.status, responseData);
      return { 
        success: false, 
        error: `OneSignal API error: ${response.status} - ${JSON.stringify(responseData)}` 
      };
    }
  } catch (error) {
    console.error('❌ Error sending OneSignal notification:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Create notification payload for new order
 * Optimized for vendor engagement and order management
 */
function createNewOrderNotification(order: OrderRecord): OneSignalNotificationPayload {
  const formattedAmount = order.total_amount.toFixed(2);
  const orderDate = new Date(order.booking_date).toLocaleDateString('en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });

  return {
    app_id: ONESIGNAL_APP_ID,
    // Target specific vendor using external user ID (vendor_id)
    include_external_user_ids: order.vendor_id ? [order.vendor_id] : undefined,
    // Fallback filter for tag-based targeting
    filters: order.vendor_id ? undefined : [
      {
        field: 'tag',
        key: 'vendor_id',
        relation: '=',
        value: 'all_vendors'
      }
    ],
    headings: {
      en: '🛎️ New Order Received!'
    },
    contents: {
      en: `${order.service_title} - $${formattedAmount}\nScheduled: ${orderDate}${order.customer_name ? `\nCustomer: ${order.customer_name}` : ''}`
    },
    data: {
      type: 'new_order',
      order_id: order.id,
      service_title: order.service_title,
      total_amount: formattedAmount,
      booking_date: order.booking_date,
      booking_time: order.booking_time || '',
      vendor_id: order.vendor_id || '',
      customer_name: order.customer_name || '',
      customer_phone: order.customer_phone || '',
      status: order.status,
      location_address: order.location_address || '',
      service_duration: order.service_duration?.toString() || '',
      timestamp: new Date().toISOString(),
      // Action data for deep linking
      action: 'view_order',
      screen: 'order_details'
    },
    // Android specific settings
    android_channel_id: 'new_orders_channel',
    priority: 10, // High priority for new orders
    small_icon: 'ic_notification',
    large_icon: 'https://sylonow.com/assets/icon-192x192.png',
    android_sound: 'new_order_sound',
    
    // iOS specific settings
    ios_badgeType: 'Increase',
    ios_badgeCount: 1,
    ios_sound: 'new_order.wav',
    
    // Web push settings
    chrome_web_icon: 'https://sylonow.com/assets/icon-192x192.png',
    firefox_icon: 'https://sylonow.com/assets/icon-192x192.png',
    chrome_icon: 'https://sylonow.com/assets/icon-192x192.png',
    
    // Action buttons for quick responses
    web_buttons: [
      {
        id: 'view_order',
        text: 'View Order',
        url: `https://vendor.sylonow.com/orders/${order.id}`
      },
      {
        id: 'accept_order',
        text: 'Accept'
      }
    ],
    
    // Rich media support
    big_picture: order.service_title.toLowerCase().includes('cleaning') 
      ? 'https://sylonow.com/assets/cleaning-service.jpg'
      : 'https://sylonow.com/assets/default-service.jpg',
    adm_big_picture: 'https://sylonow.com/assets/icon-512x512.png',
    chrome_big_picture: 'https://sylonow.com/assets/service-banner.jpg'
  };
}

/**
 * Create notification payload for order status updates
 */
function createOrderUpdateNotification(order: OrderRecord, updateType: string): OneSignalNotificationPayload {
  const statusMessages = {
    'confirmed': 'Order Confirmed ✅',
    'in_progress': 'Service In Progress 🔄',
    'completed': 'Service Completed ✅',
    'cancelled': 'Order Cancelled ❌',
    'payment_received': 'Payment Received 💰'
  };

  const statusMessage = statusMessages[updateType] || 'Order Updated';

  return {
    app_id: ONESIGNAL_APP_ID,
    include_external_user_ids: order.vendor_id ? [order.vendor_id] : undefined,
    headings: {
      en: statusMessage
    },
    contents: {
      en: `${order.service_title} - $${order.total_amount.toFixed(2)}\nStatus: ${order.status}`
    },
    data: {
      type: 'order_update',
      update_type: updateType,
      order_id: order.id,
      service_title: order.service_title,
      total_amount: order.total_amount.toString(),
      vendor_id: order.vendor_id || '',
      status: order.status,
      timestamp: new Date().toISOString(),
      action: 'view_order',
      screen: 'order_details'
    },
    android_channel_id: 'order_updates_channel',
    priority: 8, // Medium-high priority for updates
    small_icon: 'ic_notification',
    ios_badgeType: 'Increase',
    ios_sound: 'default'
  };
}

/**
 * Log notification to Supabase for tracking and analytics
 */
async function logNotification(
  orderId: string,
  vendorId: string,
  notificationType: string,
  oneSignalResponse: OneSignalResponse
) {
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    
    const { createClient } = await import('https://esm.sh/@supabase/supabase-js@2');
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const { error } = await supabase
      .from('notification_logs')
      .insert({
        order_id: orderId,
        vendor_id: vendorId,
        notification_type: notificationType,
        onesignal_id: oneSignalResponse.id,
        recipients: oneSignalResponse.recipients,
        sent_at: new Date().toISOString(),
        payload_data: {
          external_id: oneSignalResponse.external_id,
          errors: oneSignalResponse.errors
        }
      });

    if (error) {
      console.error('❌ Error logging notification:', error);
    } else {
      console.log('📊 Notification logged successfully');
    }
  } catch (error) {
    console.error('❌ Error in notification logging:', error);
  }
}

/**
 * Main Edge Function handler
 * Handles database webhooks from orders table
 */
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
    console.log('🚀 Processing OneSignal order notification...');
    console.log('🔧 OneSignal App ID:', ONESIGNAL_APP_ID);

    // Parse the request body to get order data
    const requestBody = await req.text();
    console.log('📨 Received webhook payload:', requestBody);

    let orderData: OrderRecord;
    let eventType = 'INSERT'; // Default to new order
    
    try {
      // Handle Supabase webhook payload structure
      const payload = JSON.parse(requestBody);
      
      // Extract order data and event type from webhook payload
      if (payload.type) {
        eventType = payload.type; // INSERT, UPDATE, DELETE
      }
      
      if (payload.record) {
        // Supabase database webhook format
        orderData = payload.record;
      } else if (payload.new) {
        // Supabase realtime format
        orderData = payload.new;
      } else {
        // Direct order data
        orderData = payload;
      }
      
      console.log('📋 Extracted order data:', JSON.stringify(orderData, null, 2));
      console.log('🎯 Event type:', eventType);
      
    } catch (parseError) {
      console.error('❌ Error parsing request body:', parseError);
      return new Response(
        JSON.stringify({ 
          error: 'Invalid JSON payload', 
          details: parseError.message 
        }),
        { 
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        }
      );
    }

    // Validate required order fields
    if (!orderData.id || !orderData.service_title) {
      console.error('❌ Missing required order fields:', orderData);
      return new Response(
        JSON.stringify({ 
          error: 'Missing required order fields (id, service_title)' 
        }),
        { 
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        }
      );
    }

    let notificationPayload: OneSignalNotificationPayload;
    let notificationType: string;

    // Determine notification type based on event and order status
    if (eventType === 'INSERT') {
      // New order created
      notificationPayload = createNewOrderNotification(orderData);
      notificationType = 'new_order';
    } else if (eventType === 'UPDATE') {
      // Order status updated
      notificationPayload = createOrderUpdateNotification(orderData, orderData.status);
      notificationType = 'order_update';
    } else {
      console.log('ℹ️ Ignoring event type:', eventType);
      return new Response(
        JSON.stringify({ 
          message: 'Event type not handled',
          event_type: eventType 
        }),
        { 
          status: 200,
          headers: { 'Content-Type': 'application/json' }
        }
      );
    }
    
    // Send the notification
    const sendResult = await sendOneSignalNotification(notificationPayload);

    if (sendResult.success && sendResult.response) {
      // Log the notification for analytics
      await logNotification(
        orderData.id,
        orderData.vendor_id || 'unknown',
        notificationType,
        sendResult.response
      );

      const result = {
        message: 'OneSignal notification sent successfully',
        notification_type: notificationType,
        order_id: orderData.id,
        vendor_id: orderData.vendor_id,
        onesignal_id: sendResult.response.id,
        recipients: sendResult.response.recipients,
        external_id: sendResult.response.external_id,
        timestamp: new Date().toISOString(),
      };

      console.log('✅ OneSignal notification completed:', result);

      return new Response(JSON.stringify(result), {
        status: 200,
        headers: { 
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      });
    } else {
      console.error('❌ Failed to send OneSignal notification:', sendResult.error);
      
      return new Response(
        JSON.stringify({ 
          error: 'Failed to send notification', 
          details: sendResult.error,
          order_id: orderData.id,
          vendor_id: orderData.vendor_id,
          timestamp: new Date().toISOString(),
        }),
        { 
          status: 500,
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          }
        }
      );
    }

  } catch (error) {
    console.error('❌ Edge Function error:', error);
    
    return new Response(
      JSON.stringify({ 
        error: 'Internal server error', 
        details: error.message,
        timestamp: new Date().toISOString(),
      }),
      { 
        status: 500,
        headers: { 
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        }
      }
    );
  }
});