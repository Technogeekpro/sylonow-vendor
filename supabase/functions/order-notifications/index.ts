import "jsr:@supabase/functions-js/edge-runtime.d.ts";

interface OrderRecord {
  id: string;
  service_title: string;
  booking_date: string;
  total_amount: number;
  status: string;
  vendor_id?: string;
  customer_name?: string;
  customer_phone?: string;
}

interface OneSignalPayload {
  app_id: string;
  filters: Array<{
    field: string;
    key: string;
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
}

// Send OneSignal notification
async function sendOneSignalNotification(payload: OneSignalPayload): Promise<{ success: boolean; response?: any; error?: string }> {
  try {
    const ONESIGNAL_REST_API_KEY = 'os_v2_app_jhbjmdz2yncufe2i3ujeritt6m5lejyy5ktud25fp7zknzvgfae2ikijmfpglh2ip4cynizph6tvehpao73rfvj3zdskjczvyc4at2q';
    
    console.log('📤 Sending OneSignal notification:', JSON.stringify(payload, null, 2));
    
    const response = await fetch('https://onesignal.com/api/v1/notifications', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Basic ${ONESIGNAL_REST_API_KEY}`,
      },
      body: JSON.stringify(payload),
    });

    const responseData = await response.json();

    if (response.ok) {
      console.log('✅ OneSignal notification sent successfully:', responseData);
      return { success: true, response: responseData };
    } else {
      console.error('❌ OneSignal API error:', response.status, responseData);
      return { success: false, error: `OneSignal API error: ${response.status} - ${JSON.stringify(responseData)}` };
    }
  } catch (error) {
    console.error('❌ Error sending OneSignal notification:', error);
    return { success: false, error: error.message };
  }
}

// Create notification payload for new order
function createNewOrderNotification(order: OrderRecord): OneSignalPayload {
  const ONESIGNAL_APP_ID = '49c2960f-3ac3-4542-9348-dd1248a273f3';
  
  return {
    app_id: ONESIGNAL_APP_ID,
    filters: [
      {
        field: 'tag',
        key: 'vendor_id',
        relation: '=',
        value: order.vendor_id || 'all_vendors'
      }
    ],
    headings: {
      en: '🛎️ New Order Received!'
    },
    contents: {
      en: `New order for "${order.service_title}" - $${order.total_amount.toFixed(2)}`
    },
    data: {
      type: 'new_order',
      order_id: order.id,
      service_title: order.service_title,
      total_amount: order.total_amount.toString(),
      booking_date: order.booking_date,
      vendor_id: order.vendor_id || '',
      status: order.status
    },
    android_channel_id: 'new_orders_channel',
    priority: 10,
    small_icon: 'ic_notification',
    large_icon: 'ic_notification_large'
  };
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
    console.log('🚀 Processing new order notification...');

    // Parse the request body to get order data
    const requestBody = await req.text();
    console.log('📨 Received webhook payload:', requestBody);

    let orderData: OrderRecord;
    
    try {
      // Handle Supabase webhook payload structure
      const payload = JSON.parse(requestBody);
      
      // Extract order data from webhook payload
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

    // Create OneSignal notification payload
    const notificationPayload = createNewOrderNotification(orderData);
    
    // Send the notification
    const sendResult = await sendOneSignalNotification(notificationPayload);

    if (sendResult.success) {
      const result = {
        message: 'Order notification sent successfully',
        order_id: orderData.id,
        notification_id: sendResult.response?.id,
        recipients: sendResult.response?.recipients,
        timestamp: new Date().toISOString(),
      };

      console.log('✅ Order notification completed:', result);

      return new Response(JSON.stringify(result), {
        status: 200,
        headers: { 
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      });
    } else {
      console.error('❌ Failed to send order notification:', sendResult.error);
      
      return new Response(
        JSON.stringify({ 
          error: 'Failed to send notification', 
          details: sendResult.error,
          order_id: orderData.id,
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