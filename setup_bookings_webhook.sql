-- =================================================
-- SUPABASE WEBHOOK SETUP FOR BOOKINGS NOTIFICATIONS
-- =================================================
-- This script sets up database webhooks and triggers for the bookings table
-- to send notifications via the order-notifications-onesignal edge function

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pg_net";

-- =================================================
-- CREATE BOOKINGS TABLE (if not exists)
-- =================================================
CREATE TABLE IF NOT EXISTS public.bookings (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    vendor_id uuid NOT NULL,
    user_id uuid,
    service_listing_id uuid,
    service_title text NOT NULL,
    booking_date timestamp with time zone NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status text NOT NULL DEFAULT 'pending',
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    customer_name text,
    customer_email text,
    customer_phone text,
    original_price numeric(10,2),
    offer_price numeric(10,2),
    notes text,
    -- Add vendor relation
    CONSTRAINT bookings_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id) ON DELETE CASCADE,
    -- Status validation
    CONSTRAINT bookings_status_check CHECK (status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'in_progress'::text, 'completed'::text, 'cancelled'::text, 'rejected'::text]))
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_bookings_vendor_id ON public.bookings(vendor_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON public.bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_date ON public.bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON public.bookings(created_at);

-- =================================================
-- WEBHOOK FUNCTION
-- =================================================
-- Drop existing function if it exists
DROP FUNCTION IF EXISTS notify_booking_change() CASCADE;

-- Create the webhook function that calls the OneSignal edge function
CREATE OR REPLACE FUNCTION notify_booking_change()
RETURNS TRIGGER AS $$
DECLARE
    webhook_url text;
    auth_header text;
    payload jsonb;
    event_type text;
BEGIN
    -- Determine event type
    IF TG_OP = 'INSERT' THEN
        event_type := 'INSERT';
    ELSIF TG_OP = 'UPDATE' THEN
        event_type := 'UPDATE';
    ELSE
        event_type := TG_OP;
    END IF;

    -- Construct the webhook URL (replace with your actual Supabase project URL)
    webhook_url := 'https://your-project-ref.supabase.co/functions/v1/order-notifications-onesignal';
    
    -- Set up authorization header (replace with your actual anon key or service role key)
    auth_header := 'Bearer YOUR_SUPABASE_ANON_KEY';

    -- Build the payload with booking data
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
        END
    );

    -- Log the webhook call (for debugging)
    RAISE LOG 'Webhook notification: % for booking %', event_type, COALESCE(NEW.id, OLD.id);

    -- Make the HTTP request to the edge function
    PERFORM net.http_post(
        url := webhook_url,
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', auth_header,
            'User-Agent', 'Supabase-Webhook/1.0'
        ),
        body := payload,
        timeout_ms := 10000
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
        RAISE LOG 'Webhook notification failed: %', SQLERRM;
        IF TG_OP = 'DELETE' THEN
            RETURN OLD;
        ELSE
            RETURN NEW;
        END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =================================================
-- DATABASE TRIGGERS
-- =================================================
-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS bookings_notification_trigger_insert ON public.bookings;
DROP TRIGGER IF EXISTS bookings_notification_trigger_update ON public.bookings;

-- Create triggers for INSERT and UPDATE events
CREATE TRIGGER bookings_notification_trigger_insert
    AFTER INSERT ON public.bookings
    FOR EACH ROW
    EXECUTE FUNCTION notify_booking_change();

CREATE TRIGGER bookings_notification_trigger_update
    AFTER UPDATE ON public.bookings
    FOR EACH ROW
    EXECUTE FUNCTION notify_booking_change();

-- =================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =================================================
-- Enable RLS on bookings table
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- Policy for vendors to see their own bookings
CREATE POLICY "Vendors can view their own bookings" ON public.bookings
    FOR SELECT TO authenticated
    USING (
        vendor_id IN (
            SELECT id FROM public.vendors 
            WHERE auth_user_id = auth.uid()
        )
    );

-- Policy for vendors to update their own bookings
CREATE POLICY "Vendors can update their own bookings" ON public.bookings
    FOR UPDATE TO authenticated
    USING (
        vendor_id IN (
            SELECT id FROM public.vendors 
            WHERE auth_user_id = auth.uid()
        )
    );

-- Policy for service role and trigger function access
CREATE POLICY "Service role full access to bookings" ON public.bookings
    FOR ALL TO service_role
    USING (true);

-- Policy for authenticated users to insert bookings (customers creating bookings)
CREATE POLICY "Authenticated users can create bookings" ON public.bookings
    FOR INSERT TO authenticated
    WITH CHECK (true);

-- =================================================
-- GRANTS AND PERMISSIONS
-- =================================================
-- Grant necessary permissions for the webhook function
GRANT USAGE ON SCHEMA net TO postgres;
GRANT EXECUTE ON FUNCTION net.http_post TO postgres;
GRANT USAGE ON SCHEMA public TO postgres;
GRANT SELECT, INSERT, UPDATE ON public.bookings TO postgres;

-- Grant permissions for the webhook function to access the bookings table
GRANT SELECT ON public.bookings TO authenticated;
GRANT SELECT ON public.vendors TO authenticated;

-- =================================================
-- CONFIGURATION INSTRUCTIONS
-- =================================================
/*
IMPORTANT: Before running this script, you need to:

1. Replace 'your-project-ref' with your actual Supabase project reference
2. Replace 'YOUR_SUPABASE_ANON_KEY' with your actual Supabase anon key or service role key
3. Ensure the pg_net extension is enabled in your Supabase project
4. Ensure your edge function 'order-notifications-onesignal' is deployed

To get your project details:
- Project URL: https://supabase.com/dashboard/project/[your-project-ref]
- API Keys: Project Settings > API > Project API keys

Example webhook URL format:
https://abcdefghijklmnop.supabase.co/functions/v1/order-notifications-onesignal

To test the webhook:
1. Insert a test booking record
2. Check the edge function logs in Supabase dashboard
3. Verify OneSignal notifications are sent

To update the webhook URL and auth key after deployment:
ALTER FUNCTION notify_booking_change() ...
(or re-run this script with updated values)
*/