-- Drop the conflicting public policy that restricts vendor access
DROP POLICY IF EXISTS "Public can view verified active vendors" ON public.vendors;

-- Drop the existing policy to recreate it with a more specific condition
DROP POLICY IF EXISTS "Vendors can view their own profile" ON public.vendors;

-- Recreate the policy to ensure a vendor can ALWAYS see their own record.
CREATE POLICY "Vendors can view their own profile" 
ON public.vendors
FOR SELECT 
USING (auth.uid() = auth_user_id);

-- Optional: If you still want a public policy, it should be separate and not conflict.
-- This policy allows anyone to see vendors who are verified and active.
-- This won't conflict with the policy above because policies are combined with OR.
CREATE POLICY "Public can view verified active vendors" 
ON public.vendors
FOR SELECT 
USING (verification_status = 'verified' AND is_active = true); 