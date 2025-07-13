-- =================================================
-- WEBHOOK INTEGRATION TEST SCRIPT
-- =================================================
-- This script tests the webhook integration with OneSignal notifications
-- Run this in Supabase SQL Editor to verify everything is working

-- =================================================
-- VERIFICATION CHECKS
-- =================================================

-- 1. Check if pg_net extension is enabled
SELECT 
    'pg_net extension' as check_name,
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_net') 
        THEN '✅ ENABLED' 
        ELSE '❌ NOT ENABLED - Please enable pg_net extension'
    END as status;

-- 2. Check if bookings table exists
SELECT 
    'bookings table' as check_name,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'bookings' AND table_schema = 'public') 
        THEN '✅ EXISTS' 
        ELSE '❌ NOT FOUND - Please run setup script first'
    END as status;

-- 3. Check if webhook function exists
SELECT 
    'webhook function' as check_name,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.routines WHERE routine_name = 'notify_booking_change') 
        THEN '✅ EXISTS' 
        ELSE '❌ NOT FOUND - Please run setup script first'
    END as status;

-- 4. Check if triggers are properly created
SELECT 
    'webhook triggers' as check_name,
    CASE 
        WHEN (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_name LIKE '%bookings_notification%') >= 2
        THEN '✅ CONFIGURED (' || (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_name LIKE '%bookings_notification%') || ' triggers)'
        ELSE '❌ MISSING - Expected 2 triggers (INSERT/UPDATE)'
    END as status;

-- 5. Check RLS policies
SELECT 
    'RLS policies' as check_name,
    CASE 
        WHEN (SELECT COUNT(*) FROM pg_policies WHERE tablename = 'bookings') > 0
        THEN '✅ CONFIGURED (' || (SELECT COUNT(*) FROM pg_policies WHERE tablename = 'bookings') || ' policies)'
        ELSE '❌ MISSING - No RLS policies found'
    END as status;

-- =================================================
-- DETAILED TRIGGER INFORMATION
-- =================================================
SELECT 
    'TRIGGER DETAILS' as section,
    trigger_name,
    event_manipulation,
    event_object_table,
    action_timing,
    action_orientation
FROM information_schema.triggers 
WHERE trigger_name LIKE '%bookings_notification%'
ORDER BY trigger_name;

-- =================================================
-- DETAILED POLICY INFORMATION
-- =================================================
SELECT 
    'POLICY DETAILS' as section,
    policyname,
    cmd,
    permissive,
    roles
FROM pg_policies 
WHERE tablename = 'bookings'
ORDER BY policyname;

-- =================================================
-- TEST DATA INSERTION
-- =================================================
-- Create a test vendor first (if not exists)
DO $$
DECLARE
    test_vendor_id uuid;
    test_service_id uuid;
BEGIN
    -- Check if test vendor exists
    SELECT id INTO test_vendor_id 
    FROM public.vendors 
    WHERE email = 'webhook-test@sylonow.com'
    LIMIT 1;
    
    -- Create test vendor if not exists
    IF test_vendor_id IS NULL THEN
        INSERT INTO public.vendors (
            id,
            email,
            phone,
            full_name,
            business_name,
            verification_status,
            created_at,
            updated_at
        ) VALUES (
            gen_random_uuid(),
            'webhook-test@sylonow.com',
            '+1234567890',
            'Test Vendor for Webhook',
            'Webhook Test Business',
            'verified',
            now(),
            now()
        ) RETURNING id INTO test_vendor_id;
        
        RAISE NOTICE 'Created test vendor with ID: %', test_vendor_id;
    ELSE
        RAISE NOTICE 'Using existing test vendor with ID: %', test_vendor_id;
    END IF;
    
    -- Get a service type for the test
    SELECT id INTO test_service_id 
    FROM public.service_types 
    WHERE is_active = true
    LIMIT 1;
    
    IF test_service_id IS NULL THEN
        RAISE EXCEPTION 'No active service types found. Please add service types first.';
    END IF;
    
    RAISE NOTICE 'Using service type ID: %', test_service_id;
END
$$;

-- =================================================
-- INSERT TEST BOOKING (This should trigger the webhook)
-- =================================================
INSERT INTO public.bookings (
    id,
    vendor_id,
    user_id,
    service_listing_id,
    service_title,
    booking_date,
    total_amount,
    status,
    customer_name,
    customer_email,
    customer_phone,
    notes,
    created_at,
    updated_at
) VALUES (
    gen_random_uuid(),
    (SELECT id FROM public.vendors WHERE email = 'webhook-test@sylonow.com' LIMIT 1),
    gen_random_uuid(), -- Mock user ID
    gen_random_uuid(), -- Mock service listing ID
    'Webhook Test Service - OneSignal Notification',
    now() + interval '2 hours',
    150.00,
    'pending',
    'Test Customer',
    'customer@test.com',
    '+0987654321',
    'This is a test booking to verify webhook functionality',
    now(),
    now()
) RETURNING id, vendor_id, service_title, total_amount, status;

-- Wait a moment for the webhook to process
SELECT pg_sleep(2);

-- =================================================
-- UPDATE TEST BOOKING (This should also trigger the webhook)
-- =================================================
UPDATE public.bookings 
SET 
    status = 'confirmed',
    notes = 'Booking confirmed via webhook test',
    updated_at = now()
WHERE service_title = 'Webhook Test Service - OneSignal Notification'
AND status = 'pending'
RETURNING id, status, updated_at;

-- =================================================
-- VERIFY TEST RESULTS
-- =================================================
-- Show the test booking that was created
SELECT 
    'TEST BOOKING CREATED' as result,
    id,
    vendor_id,
    service_title,
    total_amount,
    status,
    customer_name,
    created_at
FROM public.bookings 
WHERE service_title = 'Webhook Test Service - OneSignal Notification'
ORDER BY created_at DESC
LIMIT 1;

-- =================================================
-- CLEANUP (Optional - uncomment to clean up test data)
-- =================================================
/*
-- Remove test booking
DELETE FROM public.bookings 
WHERE service_title = 'Webhook Test Service - OneSignal Notification';

-- Remove test vendor
DELETE FROM public.vendors 
WHERE email = 'webhook-test@sylonow.com';

SELECT 'Test data cleaned up' as cleanup_status;
*/

-- =================================================
-- MONITORING QUERIES
-- =================================================
-- Check recent bookings to monitor webhook activity
SELECT 
    'RECENT BOOKINGS' as monitor_section,
    id,
    service_title,
    status,
    total_amount,
    created_at,
    updated_at
FROM public.bookings 
ORDER BY created_at DESC 
LIMIT 5;

-- =================================================
-- INSTRUCTIONS FOR VERIFICATION
-- =================================================
/*
WEBHOOK VERIFICATION CHECKLIST:

1. ✅ Run this script in Supabase SQL Editor
2. ✅ Check that all verification checks show green checkmarks
3. ✅ Verify that test booking was created successfully
4. ✅ Check your OneSignal dashboard for test notifications
5. ✅ Check Supabase Edge Functions logs for webhook calls
6. ✅ Monitor the 'Recent Bookings' section for activity

If webhook is working correctly, you should see:
- ✅ New notifications in OneSignal dashboard
- ✅ Edge function logs showing successful calls
- ✅ Test booking created and updated successfully

If issues occur:
- ❌ Check Supabase logs for error messages
- ❌ Verify Edge Function deployment
- ❌ Confirm API keys are correct
- ❌ Ensure pg_net extension is enabled
- ❌ Check network connectivity in Supabase project

To view logs:
1. Go to Supabase Dashboard > Edge Functions
2. Select 'order-notifications-onesignal' function
3. Check logs for webhook calls and errors
*/