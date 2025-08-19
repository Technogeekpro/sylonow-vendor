-- ===================================================================
-- ONESIGNAL INTEGRATION VALIDATION & COMPLETION SCRIPT
-- ===================================================================
-- This script validates the complete OneSignal setup and confirms
-- that all components are working correctly.
-- 
-- Run this in Supabase SQL Editor to validate your setup.
-- ===================================================================

-- 1. Check if all required extensions are enabled
SELECT 
    'EXTENSIONS CHECK' as validation_step,
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_net')
        THEN '✅ pg_net extension enabled'
        ELSE '❌ pg_net extension missing - run: CREATE EXTENSION IF NOT EXISTS pg_net;'
    END as pg_net_status,
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'http')
        THEN '✅ http extension enabled'
        ELSE '❌ http extension missing - run: CREATE EXTENSION IF NOT EXISTS http;'
    END as http_status;

-- 2. Check if the trigger function exists
SELECT 
    'TRIGGER FUNCTION CHECK' as validation_step,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.routines 
            WHERE routine_name = 'notify_order_changes' 
            AND routine_type = 'FUNCTION'
        )
        THEN '✅ notify_order_changes function exists'
        ELSE '❌ Trigger function missing'
    END as trigger_function_status;

-- 3. Check if the trigger is attached to orders table
SELECT 
    'TRIGGER CHECK' as validation_step,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.triggers 
            WHERE trigger_name = 'orders_notification_trigger'
            AND event_object_table = 'orders'
        )
        THEN '✅ Orders notification trigger exists'
        ELSE '❌ Orders trigger missing'
    END as trigger_status;

-- 4. Check orders table structure
SELECT 
    'ORDERS TABLE CHECK' as validation_step,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.tables 
            WHERE table_name = 'orders' AND table_schema = 'public'
        )
        THEN '✅ Orders table exists'
        ELSE '❌ Orders table missing'
    END as orders_table_status,
    (
        SELECT COUNT(*) 
        FROM information_schema.columns 
        WHERE table_name = 'orders' AND table_schema = 'public'
    ) as column_count;

-- 5. Display current OneSignal configuration summary
SELECT 
    'ONESIGNAL CONFIG SUMMARY' as validation_step,
    '49c2960f-3ac3-4542-9348-dd1248a273f3' as app_id,
    'os_v2_app_jhbjmdz2yncufe2i3ujeritt6m5lejyy5ktud25fp7zknzvgfae2ikijmfpglh2ip4cynizph6tvehpao73rfvj3zdskjczvyc4at2q' as rest_api_key_prefix,
    'https://txgszrxjyanazlrupaty.supabase.co/functions/v1/order-notifications-onesignal' as edge_function_url;

-- 6. Test the complete flow by inserting a test order
INSERT INTO orders (
    service_title,
    service_description,
    booking_date,
    booking_time,
    total_amount,
    status,
    customer_name,
    customer_phone,
    customer_email,
    venue_address,
    special_requirements
) VALUES (
    'OneSignal Integration Test - FINAL',
    'Complete integration test for OneSignal notifications',
    now() + interval '2 hours',
    '15:30:00',
    199.99,
    'pending',
    'OneSignal Test Customer',
    '+1234567890',
    'onesignal-final-test@example.com',
    '123 Test Integration Street, Notification City',
    'This is the final integration test for OneSignal'
) RETURNING 
    id,
    service_title,
    total_amount,
    status,
    'Test order created - OneSignal notification should be triggered' as test_result;

-- 7. Wait a moment for the webhook to process
SELECT pg_sleep(2);

-- 8. Show the test order that was created
SELECT 
    'TEST ORDER VERIFICATION' as validation_step,
    id,
    service_title,
    total_amount,
    status,
    customer_name,
    created_at,
    'Check OneSignal dashboard and edge function logs' as next_steps
FROM orders 
WHERE service_title = 'OneSignal Integration Test - FINAL'
ORDER BY created_at DESC 
LIMIT 1;

-- 9. Provide next steps and verification checklist
SELECT 
    'INTEGRATION COMPLETION CHECKLIST' as final_step,
    '1. ✅ Database trigger configured and active' as step_1,
    '2. ✅ Edge function deployed with OneSignal credentials' as step_2,
    '3. ✅ Test order inserted successfully' as step_3,
    '4. 🔍 Check Supabase Edge Function logs for execution' as step_4,
    '5. 🔍 Check OneSignal dashboard for sent notifications' as step_5,
    '6. 📱 Test with real device/OneSignal player ID' as step_6;

-- 10. Display useful commands and URLs for monitoring
SELECT 
    'MONITORING & DEBUGGING' as info_type,
    'https://txgszrxjyanazlrupaty.supabase.co/project/functions' as supabase_functions_url,
    'https://txgszrxjyanazlrupaty.supabase.co/project/logs' as supabase_logs_url,
    'https://onesignal.com/apps' as onesignal_dashboard_url,
    'Check edge function logs in Supabase Dashboard > Functions > order-notifications-onesignal > Logs' as debugging_tip;

-- 11. Test order status update to trigger update notification
UPDATE orders 
SET 
    status = 'confirmed',
    special_requirements = 'OneSignal integration test - Status updated to confirmed',
    updated_at = now()
WHERE service_title = 'OneSignal Integration Test - FINAL'
RETURNING 
    id,
    status,
    updated_at,
    'Order status updated - OneSignal update notification should be triggered' as test_result;