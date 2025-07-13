-- =========================================
-- SYLONOW VENDOR DATABASE MIGRATION SCRIPT
-- Source Project: bsxkxgtwxtggicjocqvp (sylonow)
-- Generated: 2025-01-27
-- =========================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =========================================
-- TABLE SCHEMAS
-- =========================================

-- Create vendors table
CREATE TABLE IF NOT EXISTS public.vendors (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    email text UNIQUE NOT NULL,
    phone text,
    full_name text,
    business_name text,
    business_type text,
    experience_years integer,
    location jsonb,
    profile_image_url text,
    business_license_url text,
    identity_verification_url text,
    portfolio_images jsonb,
    bio text,
    availability_schedule jsonb,
    rating numeric(3,2) DEFAULT 0.00,
    total_reviews integer DEFAULT 0,
    total_jobs_completed integer DEFAULT 0,
    verification_status text DEFAULT 'pending'::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    auth_user_id uuid,
    CONSTRAINT vendors_rating_check CHECK ((rating >= (0)::numeric AND rating <= (5)::numeric)),
    CONSTRAINT vendors_verification_status_check CHECK (verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text]))
);

-- Create service_types table
CREATE TABLE IF NOT EXISTS public.service_types (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    description text,
    icon_url text,
    category text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Create service_areas table
CREATE TABLE IF NOT EXISTS public.service_areas (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    vendor_id uuid REFERENCES public.vendors(id) ON DELETE CASCADE,
    area_name text NOT NULL,
    city text,
    state text,
    postal_code text,
    coordinates jsonb,
    radius_km numeric(10,2),
    is_primary boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Create service_listings table
CREATE TABLE IF NOT EXISTS public.service_listings (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    vendor_id uuid REFERENCES public.vendors(id) ON DELETE CASCADE,
    service_type_id uuid REFERENCES public.service_types(id) ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    base_price numeric(10,2),
    price_unit text,
    service_duration text,
    images jsonb,
    tags jsonb,
    requirements text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Create vendor_documents table
CREATE TABLE IF NOT EXISTS public.vendor_documents (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    vendor_id uuid REFERENCES public.vendors(id) ON DELETE CASCADE,
    document_type text NOT NULL,
    document_url text NOT NULL,
    verification_status text DEFAULT 'pending'::text,
    verified_at timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    CONSTRAINT vendor_documents_document_type_check CHECK (document_type = ANY (ARRAY['business_license'::text, 'identity'::text, 'insurance'::text, 'certification'::text, 'tax_document'::text])),
    CONSTRAINT vendor_documents_verification_status_check CHECK (verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text]))
);

-- Create otp_verifications table
CREATE TABLE IF NOT EXISTS public.otp_verifications (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    phone text NOT NULL,
    otp_code text NOT NULL,
    is_verified boolean DEFAULT false,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    verified_at timestamp with time zone
);

-- Create app_settings table
CREATE TABLE IF NOT EXISTS public.app_settings (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    setting_key text UNIQUE NOT NULL,
    setting_value jsonb,
    description text,
    is_public boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- =========================================
-- STORAGE BUCKETS
-- =========================================

-- Create storage buckets
INSERT INTO storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) VALUES
('vendor-documents', 'vendor-documents', NULL, '2025-01-26 19:47:32.749568+00', '2025-01-26 19:47:32.749568+00', false, false, NULL, '{application/pdf,image/jpeg,image/png,image/jpg}', NULL),
('vendor-images', 'vendor-images', NULL, '2025-01-26 19:47:46.901762+00', '2025-01-26 19:47:46.901762+00', true, false, NULL, '{image/jpeg,image/png,image/jpg,image/webp}', NULL)
ON CONFLICT (id) DO NOTHING;

-- =========================================
-- DATA INSERTION
-- =========================================

-- Insert service_types data
INSERT INTO public.service_types (id, name, description, icon_url, category, is_active, created_at, updated_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Plumbing', 'Professional plumbing services including repairs, installations, and maintenance', NULL, 'Home Services', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440002', 'Electrical', 'Licensed electrical services for residential and commercial properties', NULL, 'Home Services', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440003', 'HVAC', 'Heating, ventilation, and air conditioning services', NULL, 'Home Services', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440004', 'Carpentry', 'Custom carpentry and woodworking services', NULL, 'Home Services', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440005', 'Painting', 'Interior and exterior painting services', NULL, 'Home Services', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440006', 'Cleaning', 'Professional cleaning services for homes and offices', NULL, 'Cleaning', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440007', 'Landscaping', 'Garden design, maintenance, and landscaping services', NULL, 'Outdoor', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440008', 'Moving', 'Professional moving and relocation services', NULL, 'Transportation', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440009', 'Appliance Repair', 'Repair services for household appliances', NULL, 'Home Services', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00'),
('550e8400-e29b-41d4-a716-446655440010', 'Handyman', 'General maintenance and repair services', NULL, 'Home Services', true, '2025-01-26 19:48:15.123456+00', '2025-01-26 19:48:15.123456+00')
ON CONFLICT (id) DO NOTHING;

-- Insert app_settings data
INSERT INTO public.app_settings (id, setting_key, setting_value, description, is_public, created_at, updated_at) VALUES
('550e8400-e29b-41d4-a716-446655441001', 'app_version', '"1.0.0"', 'Current application version', true, '2025-01-26 19:48:30.123456+00', '2025-01-26 19:48:30.123456+00'),
('550e8400-e29b-41d4-a716-446655441002', 'maintenance_mode', 'false', 'Application maintenance mode status', false, '2025-01-26 19:48:30.123456+00', '2025-01-26 19:48:30.123456+00'),
('550e8400-e29b-41d4-a716-446655441003', 'max_service_radius', '50', 'Maximum service radius in kilometers', true, '2025-01-26 19:48:30.123456+00', '2025-01-26 19:48:30.123456+00'),
('550e8400-e29b-41d4-a716-446655441004', 'commission_rate', '0.15', 'Platform commission rate', false, '2025-01-26 19:48:30.123456+00', '2025-01-26 19:48:30.123456+00'),
('550e8400-e29b-41d4-a716-446655441005', 'supported_languages', '["en", "es", "fr"]', 'List of supported languages', true, '2025-01-26 19:48:30.123456+00', '2025-01-26 19:48:30.123456+00')
ON CONFLICT (id) DO NOTHING;

-- =========================================
-- INDEXES
-- =========================================

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_vendors_email ON public.vendors(email);
CREATE INDEX IF NOT EXISTS idx_vendors_auth_user_id ON public.vendors(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_vendors_verification_status ON public.vendors(verification_status);
CREATE INDEX IF NOT EXISTS idx_vendors_is_active ON public.vendors(is_active);

CREATE INDEX IF NOT EXISTS idx_service_areas_vendor_id ON public.service_areas(vendor_id);
CREATE INDEX IF NOT EXISTS idx_service_areas_city ON public.service_areas(city);

CREATE INDEX IF NOT EXISTS idx_service_listings_vendor_id ON public.service_listings(vendor_id);
CREATE INDEX IF NOT EXISTS idx_service_listings_service_type_id ON public.service_listings(service_type_id);
CREATE INDEX IF NOT EXISTS idx_service_listings_is_active ON public.service_listings(is_active);

CREATE INDEX IF NOT EXISTS idx_vendor_documents_vendor_id ON public.vendor_documents(vendor_id);
CREATE INDEX IF NOT EXISTS idx_vendor_documents_document_type ON public.vendor_documents(document_type);
CREATE INDEX IF NOT EXISTS idx_vendor_documents_verification_status ON public.vendor_documents(verification_status);

CREATE INDEX IF NOT EXISTS idx_otp_verifications_phone ON public.otp_verifications(phone);
CREATE INDEX IF NOT EXISTS idx_otp_verifications_expires_at ON public.otp_verifications(expires_at);

CREATE INDEX IF NOT EXISTS idx_app_settings_setting_key ON public.app_settings(setting_key);

-- =========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =========================================

-- Enable RLS on all tables
ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vendor_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.otp_verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- Vendors policies
CREATE POLICY "Vendors can view their own profile" ON public.vendors
    FOR SELECT USING (auth.uid() = auth_user_id);

CREATE POLICY "Vendors can update their own profile" ON public.vendors
    FOR UPDATE USING (auth.uid() = auth_user_id);

CREATE POLICY "Public can view verified active vendors" ON public.vendors
    FOR SELECT USING (verification_status = 'verified' AND is_active = true);

-- Service types policies (public read)
CREATE POLICY "Anyone can view active service types" ON public.service_types
    FOR SELECT USING (is_active = true);

-- Service areas policies
CREATE POLICY "Vendors can manage their service areas" ON public.service_areas
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.vendors 
            WHERE vendors.id = service_areas.vendor_id 
            AND vendors.auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Public can view service areas" ON public.service_areas
    FOR SELECT USING (true);

-- Service listings policies
CREATE POLICY "Vendors can manage their service listings" ON public.service_listings
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.vendors 
            WHERE vendors.id = service_listings.vendor_id 
            AND vendors.auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Public can view active service listings" ON public.service_listings
    FOR SELECT USING (is_active = true);

-- Vendor documents policies
CREATE POLICY "Vendors can manage their documents" ON public.vendor_documents
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.vendors 
            WHERE vendors.id = vendor_documents.vendor_id 
            AND vendors.auth_user_id = auth.uid()
        )
    );

-- OTP verifications policies
CREATE POLICY "Users can manage their OTP verifications" ON public.otp_verifications
    FOR ALL USING (true); -- Note: You may want to restrict this further based on your auth logic

-- App settings policies
CREATE POLICY "Public can view public settings" ON public.app_settings
    FOR SELECT USING (is_public = true);

-- =========================================
-- TRIGGERS
-- =========================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_vendors_updated_at BEFORE UPDATE ON public.vendors FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_types_updated_at BEFORE UPDATE ON public.service_types FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_areas_updated_at BEFORE UPDATE ON public.service_areas FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_listings_updated_at BEFORE UPDATE ON public.service_listings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vendor_documents_updated_at BEFORE UPDATE ON public.vendor_documents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_app_settings_updated_at BEFORE UPDATE ON public.app_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =========================================
-- STORAGE POLICIES
-- =========================================

-- Vendor documents bucket policies
CREATE POLICY "Vendors can upload their documents" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'vendor-documents' AND
        EXISTS (
            SELECT 1 FROM public.vendors 
            WHERE vendors.auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Vendors can view their documents" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'vendor-documents' AND
        EXISTS (
            SELECT 1 FROM public.vendors 
            WHERE vendors.auth_user_id = auth.uid()
        )
    );

-- Vendor images bucket policies
CREATE POLICY "Vendors can upload their images" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'vendor-images' AND
        EXISTS (
            SELECT 1 FROM public.vendors 
            WHERE vendors.auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Anyone can view vendor images" ON storage.objects
    FOR SELECT USING (bucket_id = 'vendor-images');

-- =========================================
-- MIGRATION COMPLETE
-- =========================================

-- Add any additional comments or notes here
COMMENT ON TABLE public.vendors IS 'Stores vendor/service provider information';
COMMENT ON TABLE public.service_types IS 'Defines available service categories';
COMMENT ON TABLE public.service_areas IS 'Defines geographical service coverage for vendors';
COMMENT ON TABLE public.service_listings IS 'Individual services offered by vendors';
COMMENT ON TABLE public.vendor_documents IS 'Document verification for vendors';
COMMENT ON TABLE public.otp_verifications IS 'OTP verification for phone numbers';
COMMENT ON TABLE public.app_settings IS 'Application configuration settings';

-- Migration script completed successfully
SELECT 'Migration script executed successfully!' as status; 