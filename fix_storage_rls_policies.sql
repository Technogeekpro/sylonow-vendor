-- Fix Storage RLS Policies to match actual folder structure
-- The app uses vendorId as folder name, not auth_user_id

-- First, drop existing storage policies
DROP POLICY IF EXISTS "Users can upload their own profile pictures" ON storage.objects;
DROP POLICY IF EXISTS "Users can view their own profile pictures" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own profile pictures" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own profile pictures" ON storage.objects;

DROP POLICY IF EXISTS "Users can upload their own vendor documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can view their own vendor documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own vendor documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own vendor documents" ON storage.objects;

-- Create corrected storage policies for profile-pictures bucket
-- The folder structure is: vendorId/filename.jpg
CREATE POLICY "Users can upload their own profile pictures"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'profile-pictures' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

CREATE POLICY "Users can view their own profile pictures"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'profile-pictures' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

CREATE POLICY "Users can update their own profile pictures"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'profile-pictures' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
)
WITH CHECK (
  bucket_id = 'profile-pictures' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

CREATE POLICY "Users can delete their own profile pictures"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'profile-pictures' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

-- Create corrected storage policies for vendor-documents bucket
CREATE POLICY "Users can upload their own vendor documents"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'vendor-documents' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

CREATE POLICY "Users can view their own vendor documents"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'vendor-documents' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

CREATE POLICY "Users can update their own vendor documents"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'vendor-documents' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
)
WITH CHECK (
  bucket_id = 'vendor-documents' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

CREATE POLICY "Users can delete their own vendor documents"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'vendor-documents' 
  AND auth.uid() = (
    SELECT auth_user_id 
    FROM public.vendors 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

-- Alternative: Enable public access for profile-pictures if needed
-- Uncomment these lines if you want profile pictures to be publicly viewable
-- 
-- CREATE POLICY "Public can view profile pictures"
-- ON storage.objects FOR SELECT
-- USING (bucket_id = 'profile-pictures');

COMMIT; 