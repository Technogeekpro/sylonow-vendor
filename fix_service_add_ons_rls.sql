-- Fix RLS policies for service_add_ons table
-- Run this in your Supabase SQL Editor

-- Enable RLS on service_add_ons table
ALTER TABLE service_add_ons ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own service addons" ON service_add_ons;
DROP POLICY IF EXISTS "Users can insert their own service addons" ON service_add_ons;
DROP POLICY IF EXISTS "Users can update their own service addons" ON service_add_ons;
DROP POLICY IF EXISTS "Users can delete their own service addons" ON service_add_ons;

-- Create RLS policies for service_add_ons table
-- Policy for SELECT: vendors can view their own addons
CREATE POLICY "Users can view their own service addons" ON service_add_ons
    FOR SELECT USING (
        vendor_id IN (
            SELECT id FROM vendors WHERE auth_user_id = auth.uid()
        )
    );

-- Policy for INSERT: vendors can insert addons for themselves
CREATE POLICY "Users can insert their own service addons" ON service_add_ons
    FOR INSERT WITH CHECK (
        vendor_id IN (
            SELECT id FROM vendors WHERE auth_user_id = auth.uid()
        )
    );

-- Policy for UPDATE: vendors can update their own addons
CREATE POLICY "Users can update their own service addons" ON service_add_ons
    FOR UPDATE USING (
        vendor_id IN (
            SELECT id FROM vendors WHERE auth_user_id = auth.uid()
        )
    ) WITH CHECK (
        vendor_id IN (
            SELECT id FROM vendors WHERE auth_user_id = auth.uid()
        )
    );

-- Policy for DELETE: vendors can delete their own addons
CREATE POLICY "Users can delete their own service addons" ON service_add_ons
    FOR DELETE USING (
        vendor_id IN (
            SELECT id FROM vendors WHERE auth_user_id = auth.uid()
        )
    );

-- Also ensure storage bucket policies are correct for service-add-on-images
-- This needs to be run in the Storage section, not SQL Editor:

-- Policy for service-add-on-images bucket:
-- 1. Allow authenticated users to upload: 
--    Operation: INSERT
--    Policy: auth.role() = 'authenticated'
--    Target roles: authenticated

-- 2. Allow authenticated users to view their own images:
--    Operation: SELECT  
--    Policy: auth.role() = 'authenticated'
--    Target roles: authenticated, public

-- 3. Allow users to update their own images:
--    Operation: UPDATE
--    Policy: auth.role() = 'authenticated' AND auth.uid()::text = (storage.foldername(name))[1]
--    Target roles: authenticated

-- 4. Allow users to delete their own images:
--    Operation: DELETE  
--    Policy: auth.role() = 'authenticated' AND auth.uid()::text = (storage.foldername(name))[1]
--    Target roles: authenticated