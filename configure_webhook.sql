-- =================================================
-- WEBHOOK CONFIGURATION SCRIPT
-- =================================================
-- This script updates the webhook function with your actual Supabase project details
-- Run this AFTER you have your project URL and API keys

-- Check if pg_net extension is enabled
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_net') THEN
        RAISE EXCEPTION 'pg_net extension is not enabled. Please enable it in your Supabase project first.';
    END IF;
END
$$;

-- =================================================
-- UPDATE WEBHOOK FUNCTION WITH ACTUAL PROJECT DETAILS
-- =================================================
-- Replace the placeholder function with actual project details
CREATE OR REPLACE FUNCTION notify_booking_change()
RETURNS TRIGGER AS $$
DECLARE
    webhook_url text;
    auth_header text;
    payload jsonb;
    event_type text;
    project_url text;
    api_key text;
BEGIN
    -- Get project configuration from app_settings table
    SELECT setting_value->>0 INTO project_url 
    FROM public.app_settings 
    WHERE setting_key = 'supabase_project_url';
    
    SELECT setting_value->>0 INTO api_key 
    FROM public.app_settings 
    WHERE setting_key = 'supabase_service_key';

    -- Fallback to environment or default values if not set in app_settings
    IF project_url IS NULL THEN
        -- Replace with your actual project URL
        project_url := 'https://bsxkxgtwxtggicjocqvp.supabase.co';
    END IF;

    IF api_key IS NULL THEN
        -- Use service role key for internal webhook calls
        -- Replace with your actual service role key
        api_key := 'YOUR_SERVICE_ROLE_KEY_HERE';
    END IF;

    -- Determine event type
    IF TG_OP = 'INSERT' THEN
        event_type := 'INSERT';
    ELSIF TG_OP = 'UPDATE' THEN
        event_type := 'UPDATE';
    ELSE
        event_type := TG_OP;
    END IF;

    -- Construct the webhook URL
    webhook_url := project_url || '/functions/v1/order-notifications-onesignal';
    
    -- Set up authorization header
    auth_header := 'Bearer ' || api_key;

    -- Build the payload with booking data and vendor information
    payload := jsonb_build_object(
        'event_type', event_type,
        'table', 'bookings',
        'timestamp', now(),
        'record', CASE 
            WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD)
            ELSE to_jsonb(NEW)
        END,
        'old_record', CASE 
            WHEN TG_OP = 'UPDATE' THEN to_jsonb(OLD)
            ELSE NULL
        END,
        'vendor_info', CASE 
            WHEN TG_OP = 'DELETE' THEN 
                (SELECT to_jsonb(v) FROM public.vendors v WHERE v.id = OLD.vendor_id)
            ELSE 
                (SELECT to_jsonb(v) FROM public.vendors v WHERE v.id = NEW.vendor_id)
        END
    );

    -- Log the webhook call (for debugging)
    RAISE LOG 'Webhook notification: % for booking % to URL: %', 
        event_type, 
        COALESCE(NEW.id, OLD.id),
        webhook_url;

    -- Make the HTTP request to the edge function
    PERFORM net.http_post(
        url := webhook_url,
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', auth_header,
            'User-Agent', 'Supabase-Webhook/1.0',
            'X-Webhook-Source', 'bookings-trigger'
        ),
        body := payload,
        timeout_ms := 15000  -- 15 second timeout
    );

    -- Return the appropriate record
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Log error but don't prevent the original operation
        RAISE LOG 'Webhook notification failed for booking %: %', 
            COALESCE(NEW.id, OLD.id),
            SQLERRM;
        IF TG_OP = 'DELETE' THEN
            RETURN OLD;
        ELSE
            RETURN NEW;
        END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =================================================
-- INSERT CONFIGURATION SETTINGS
-- =================================================
-- Add webhook configuration to app_settings if not exists
INSERT INTO public.app_settings (setting_key, setting_value, description, is_public)
VALUES 
    ('supabase_project_url', '"https://bsxkxgtwxtggicjocqvp.supabase.co"', 'Supabase project URL for webhooks', false),
    ('webhook_enabled', 'true', 'Enable/disable webhook notifications', false),
    ('webhook_timeout_ms', '15000', 'Webhook timeout in milliseconds', false)
ON CONFLICT (setting_key) DO UPDATE SET
    setting_value = EXCLUDED.setting_value,
    updated_at = timezone('utc'::text, now());

-- =================================================
-- VERIFICATION QUERIES
-- =================================================
-- Check if triggers are properly created
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM information_schema.triggers 
WHERE trigger_name LIKE '%bookings_notification%'
ORDER BY trigger_name;

-- Check if the webhook function exists
SELECT 
    routine_name,
    routine_type,
    routine_definition
FROM information_schema.routines 
WHERE routine_name = 'notify_booking_change';

-- Check if pg_net extension is available
SELECT * FROM pg_extension WHERE extname = 'pg_net';

-- Verify RLS policies on bookings table
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'bookings'
ORDER BY policyname;