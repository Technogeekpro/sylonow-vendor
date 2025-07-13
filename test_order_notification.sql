-- Test script for order notification system
-- Run this in Supabase SQL Editor to test the notification trigger

-- First, let's check if the trigger exists
SELECT 
  trigger_name,
  event_manipulation,
  event_object_table,
  action_statement
FROM information_schema.triggers 
WHERE trigger_name = 'orders_notification_trigger';

-- Check if the function exists
SELECT 
  routine_name,
  routine_type
FROM information_schema.routines 
WHERE routine_name = 'notify_new_order';

-- Test by inserting a sample order (adjust fields based on your actual orders table structure)
-- Make sure to replace with actual column names from your orders table
INSERT INTO orders (
  id,
  service_title,
  booking_date,
  total_amount,
  status,
  vendor_id,
  customer_name,
  customer_phone,
  created_at
) VALUES (
  gen_random_uuid(),
  'Test Service - OneSignal Notification',
  now() + interval '1 day',
  99.99,
  'pending',
  'test-vendor-id',
  'Test Customer',
  '+1234567890',
  now()
);

-- Check recent orders to verify insertion
SELECT * FROM orders 
ORDER BY created_at DESC 
LIMIT 5;