-- Drop the conflicting public policy that restricts vendor access
DROP POLICY IF EXISTS "Public can view verified active vendors" ON public.vendors;

-- Drop the existing policy to recreate it with a more specific condition
DROP POLICY IF EXISTS "Vendors can view their own profile" ON public.vendors;

-- Add missing columns to vendors table if they don't exist
ALTER TABLE public.vendors 
ADD COLUMN IF NOT EXISTS is_onboarding_completed boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS phone text;

-- Create vendor_private_details table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.vendor_private_details (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    vendor_id uuid REFERENCES public.vendors(id) ON DELETE CASCADE,
    aadhaar_number text,
    bank_account_number text,
    bank_ifsc_code text,
    gst_number text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT vendor_private_details_vendor_id_key UNIQUE (vendor_id)
);

-- Create proper storage buckets if they don't exist
INSERT INTO storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) VALUES
('profile-pictures', 'profile-pictures', NULL, '2025-01-27 12:00:00.000000+00', '2025-01-27 12:00:00.000000+00', true, false, 10485760, '{image/jpeg,image/png,image/jpg,image/webp}', NULL),
('vendor-documents', 'vendor-documents', NULL, '2025-01-27 12:00:00.000000+00', '2025-01-27 12:00:00.000000+00', false, false, 10485760, '{image/jpeg,image/png,image/jpg,image/webp,application/pdf}', NULL)
ON CONFLICT (id) DO NOTHING;

-- Update vendor_documents table constraints
ALTER TABLE public.vendor_documents 
DROP CONSTRAINT IF EXISTS vendor_documents_document_type_check;

ALTER TABLE public.vendor_documents 
ADD CONSTRAINT vendor_documents_document_type_check 
CHECK (document_type IN ('identity_aadhaar_front', 'identity_aadhaar_back', 'identity_pan', 'business_license', 'tax_certificate', 'profile'));

-- Create proper RLS policies for vendors table
CREATE POLICY "Users can view their own vendor profile"
ON public.vendors FOR SELECT
USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own vendor profile"
ON public.vendors FOR INSERT
WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own vendor profile"
ON public.vendors FOR UPDATE
USING (auth.uid() = auth_user_id)
WITH CHECK (auth.uid() = auth_user_id);

-- Create RLS policies for vendor_private_details table
ALTER TABLE public.vendor_private_details ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own private details"
ON public.vendor_private_details FOR SELECT
USING (auth.uid() = (SELECT auth_user_id FROM public.vendors WHERE id = vendor_id));

CREATE POLICY "Users can insert their own private details"
ON public.vendor_private_details FOR INSERT
WITH CHECK (auth.uid() = (SELECT auth_user_id FROM public.vendors WHERE id = vendor_id));

CREATE POLICY "Users can update their own private details"
ON public.vendor_private_details FOR UPDATE
USING (auth.uid() = (SELECT auth_user_id FROM public.vendors WHERE id = vendor_id))
WITH CHECK (auth.uid() = (SELECT auth_user_id FROM public.vendors WHERE id = vendor_id));

-- Create RLS policies for vendor_documents table
CREATE POLICY "Users can view their own documents"
ON public.vendor_documents FOR SELECT
USING (auth.uid() = (SELECT auth_user_id FROM public.vendors WHERE id = vendor_id));

CREATE POLICY "Users can insert their own documents"
ON public.vendor_documents FOR INSERT
WITH CHECK (auth.uid() = (SELECT auth_user_id FROM public.vendors WHERE id = vendor_id));

CREATE POLICY "Users can update their own documents"
ON public.vendor_documents FOR UPDATE
USING (auth.uid() = (SELECT auth_user_id FROM public.vendors WHERE id = vendor_id))
WITH CHECK (auth.uid() = (SELECT auth_user_id FROM public.vendors WHERE id = vendor_id));

-- Create storage policies for profile-pictures bucket
CREATE POLICY "Users can upload their own profile pictures"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'profile-pictures' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view their own profile pictures"
ON storage.objects FOR SELECT
USING (bucket_id = 'profile-pictures' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can update their own profile pictures"
ON storage.objects FOR UPDATE
USING (bucket_id = 'profile-pictures' AND auth.uid()::text = (storage.foldername(name))[1])
WITH CHECK (bucket_id = 'profile-pictures' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete their own profile pictures"
ON storage.objects FOR DELETE
USING (bucket_id = 'profile-pictures' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Create storage policies for vendor-documents bucket  
CREATE POLICY "Users can upload their own vendor documents"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'vendor-documents' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view their own vendor documents"
ON storage.objects FOR SELECT
USING (bucket_id = 'vendor-documents' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can update their own vendor documents"
ON storage.objects FOR UPDATE
USING (bucket_id = 'vendor-documents' AND auth.uid()::text = (storage.foldername(name))[1])
WITH CHECK (bucket_id = 'vendor-documents' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete their own vendor documents"
ON storage.objects FOR DELETE
USING (bucket_id = 'vendor-documents' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_vendors_auth_user_id ON public.vendors(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_vendors_phone ON public.vendors(phone) WHERE phone IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_vendor_private_details_vendor_id ON public.vendor_private_details(vendor_id);
CREATE INDEX IF NOT EXISTS idx_vendor_documents_vendor_id ON public.vendor_documents(vendor_id);

-- Update RLS policies to be enabled on all tables
ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vendor_documents ENABLE ROW LEVEL SECURITY;

COMMIT; 