# Supabase Database Schema

This document contains the complete database schema for the Sylonow application. Refer to this file when working with Supabase database operations.

## Tables Overview

### Core Tables
- **vendors** - Vendor profiles and business information
- **service_listings** - Services offered by vendors
- **bookings** - Service bookings from customers
- **orders** - Order management and tracking
- **payment_transactions** - Payment processing records

### User Management
- **user_profiles** - User profile information
- **addresses** - User delivery/service addresses
- **otp_verifications** - OTP verification for authentication

### Theater Management
- **private_theaters** - Theater venue information
- **theater_screens** - Individual screens within theaters
- **theater_time_slots** - Available time slots for booking
- **theater_bookings** - Theater reservation records
- **theater_slot_bookings** - Slot availability tracking
- **theater_reviews** - Theater ratings and reviews

### Service Management
- **categories** - Service categories
- **service_types** - Types of services available
- **service_areas** - Geographic service coverage
- **occasions** - Special occasions for services
- **reviews** - Service reviews and ratings
- **wishlist** - User favorite services

### Theater Add-ons
- **add_ons** - Additional services for theaters
- **decorations** - Decoration options
- **cakes** - Cake ordering system
- **special_services** - Premium service offerings

### Financial Management
- **vendor_wallets** - Vendor earnings and balance
- **wallet_transactions** - Wallet transaction history
- **wallets** - Customer wallet system
- **withdrawal_requests** - Vendor withdrawal requests
- **coupons** - Discount coupons
- **service_coupons** - Service-specific coupons

### Vendor Management
- **vendor_documents** - Document verification
- **vendor_private_details** - Sensitive vendor information
- **vendor_inquiry_times** - Vendor availability tracking

### System Management
- **app_settings** - Application configuration
- **notification_queue** - Push notification queue
- **quotes** - Inspirational quotes for app

## Detailed Schema

```sql
-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.add_ons (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  theater_id uuid NOT NULL,
  name text NOT NULL,
  description text,
  price numeric NOT NULL,
  category text,
  image_url text,
  is_available boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT add_ons_pkey PRIMARY KEY (id),
  CONSTRAINT fk_add_ons_theater_id FOREIGN KEY (theater_id) REFERENCES public.private_theaters(id)
);

CREATE TABLE public.addresses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  address_for USER-DEFINED NOT NULL,
  address text NOT NULL,
  area text,
  nearby text,
  name text,
  floor text,
  phone_number text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT addresses_pkey PRIMARY KEY (id),
  CONSTRAINT addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.app_settings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  setting_key text NOT NULL UNIQUE,
  setting_value jsonb,
  description text,
  is_public boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT app_settings_pkey PRIMARY KEY (id)
);

CREATE TABLE public.bookings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid,
  user_id uuid,
  service_listing_id uuid,
  booking_date timestamp with time zone NOT NULL,
  status text NOT NULL DEFAULT 'pending'::text,
  total_amount numeric NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  booking_time text,
  inquiry_time timestamp with time zone,
  duration_hours integer DEFAULT 2,
  razorpay_amount numeric,
  sylonow_qr_amount numeric,
  razorpay_payment_id text,
  razorpay_order_id text,
  sylonow_qr_payment_id text,
  payment_status text DEFAULT 'pending'::text CHECK (payment_status = ANY (ARRAY['pending'::text, 'partial'::text, 'completed'::text, 'failed'::text, 'refunded'::text])),
  vendor_confirmation boolean DEFAULT false,
  notification_sent boolean DEFAULT false,
  add_ons jsonb DEFAULT '[]'::jsonb,
  metadata jsonb DEFAULT '{}'::jsonb,
  confirmed_at timestamp with time zone,
  completed_at timestamp with time zone,
  customer_name text,
  customer_phone text,
  customer_email text,
  venue_address text,
  venue_coordinates jsonb,
  special_requirements text,
  CONSTRAINT bookings_pkey PRIMARY KEY (id),
  CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT bookings_service_listing_id_fkey FOREIGN KEY (service_listing_id) REFERENCES public.service_listings(id)
);

CREATE TABLE public.cakes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  theater_id uuid NOT NULL,
  name character varying NOT NULL,
  description text,
  image_url text,
  price numeric NOT NULL DEFAULT 0.00,
  size character varying,
  flavor character varying,
  is_available boolean DEFAULT true,
  preparation_time_minutes integer DEFAULT 60,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT cakes_pkey PRIMARY KEY (id),
  CONSTRAINT cakes_theater_id_fkey FOREIGN KEY (theater_id) REFERENCES public.private_theaters(id)
);

CREATE TABLE public.categories (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text,
  image_url text,
  color_code text,
  is_active boolean DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT categories_pkey PRIMARY KEY (id)
);

CREATE TABLE public.coupons (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  code text NOT NULL UNIQUE,
  description text,
  discount_type text NOT NULL CHECK (discount_type = ANY (ARRAY['percentage'::text, 'fixed'::text])),
  discount_value numeric NOT NULL,
  max_discount_amount numeric,
  min_order_amount numeric DEFAULT 0,
  is_active boolean DEFAULT true,
  is_public boolean DEFAULT true,
  usage_limit integer,
  used_count integer DEFAULT 0,
  valid_from timestamp with time zone DEFAULT now(),
  valid_until timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT coupons_pkey PRIMARY KEY (id)
);

CREATE TABLE public.decorations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  theater_id uuid NOT NULL,
  name text NOT NULL,
  description text,
  price numeric NOT NULL,
  image_url text,
  is_available boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT decorations_pkey PRIMARY KEY (id),
  CONSTRAINT fk_decorations_theater_id FOREIGN KEY (theater_id) REFERENCES public.private_theaters(id)
);

CREATE TABLE public.notification_queue (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid,
  order_id uuid,
  fcm_token text NOT NULL,
  notification_type text NOT NULL,
  title text NOT NULL,
  body text NOT NULL,
  data jsonb,
  sent boolean DEFAULT false,
  sent_at timestamp with time zone,
  retry_count integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  booking_id uuid,
  error_message text,
  last_attempt timestamp with time zone,
  fcm_response jsonb,
  CONSTRAINT notification_queue_pkey PRIMARY KEY (id),
  CONSTRAINT notification_queue_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id),
  CONSTRAINT notification_queue_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id)
);

CREATE TABLE public.occasions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  icon_url text,
  color_code text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT occasions_pkey PRIMARY KEY (id)
);

CREATE TABLE public.orders (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid,
  customer_name text NOT NULL,
  customer_phone text,
  customer_email text,
  service_listing_id uuid,
  service_title text NOT NULL,
  service_description text,
  booking_date timestamp with time zone NOT NULL,
  booking_time time without time zone,
  total_amount numeric NOT NULL DEFAULT 0,
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'in_progress'::text, 'completed'::text, 'cancelled'::text])),
  payment_status text NOT NULL DEFAULT 'pending'::text CHECK (payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'refunded'::text])),
  special_requirements text,
  venue_address text,
  venue_coordinates jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  advance_amount numeric DEFAULT 0,
  remaining_amount numeric DEFAULT 0,
  advance_payment_id text,
  remaining_payment_id text,
  user_id uuid,
  place_image_url text,
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id),
  CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.otp_verifications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  phone text NOT NULL,
  otp_code text NOT NULL,
  is_verified boolean DEFAULT false,
  expires_at timestamp with time zone NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  verified_at timestamp with time zone,
  CONSTRAINT otp_verifications_pkey PRIMARY KEY (id)
);

CREATE TABLE public.payment_transactions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  booking_id uuid NOT NULL,
  user_id uuid NOT NULL,
  vendor_id uuid NOT NULL,
  payment_method text NOT NULL CHECK (payment_method = ANY (ARRAY['razorpay'::text, 'sylonow_qr'::text])),
  amount numeric NOT NULL CHECK (amount > 0::numeric),
  currency text DEFAULT 'INR'::text,
  razorpay_payment_id text,
  razorpay_order_id text,
  razorpay_signature text,
  qr_code_data text,
  qr_payment_reference text,
  qr_verified_by text,
  status text DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'processing'::text, 'completed'::text, 'failed'::text, 'refunded'::text, 'cancelled'::text])),
  failure_reason text,
  refund_amount numeric,
  refund_id text,
  metadata jsonb DEFAULT '{}'::jsonb,
  processed_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT payment_transactions_pkey PRIMARY KEY (id),
  CONSTRAINT payment_transactions_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id),
  CONSTRAINT payment_transactions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id),
  CONSTRAINT payment_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.private_theaters (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  description text,
  address text NOT NULL,
  city character varying NOT NULL,
  state character varying NOT NULL,
  pin_code character varying NOT NULL,
  latitude numeric,
  longitude numeric,
  capacity integer NOT NULL DEFAULT 1,
  amenities ARRAY,
  images ARRAY,
  hourly_rate numeric NOT NULL,
  rating numeric DEFAULT 4.5,
  total_reviews integer DEFAULT 0,
  is_active boolean DEFAULT true,
  owner_id uuid,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  available_time_slots jsonb DEFAULT '[]'::jsonb,
  booking_duration_hours integer DEFAULT 2,
  advance_booking_days integer DEFAULT 30,
  cancellation_policy text DEFAULT 'Free cancellation up to 24 hours before the booking'::text,
  CONSTRAINT private_theaters_pkey PRIMARY KEY (id),
  CONSTRAINT private_theaters_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES auth.users(id)
);

CREATE TABLE public.quotes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  quote text NOT NULL,
  image_url text,
  sex character varying CHECK (sex::text = ANY (ARRAY['male'::character varying, 'female'::character varying, 'neutral'::character varying]::text[])),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT quotes_pkey PRIMARY KEY (id)
);

CREATE TABLE public.reviews (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  service_id uuid NOT NULL,
  user_name text NOT NULL,
  user_avatar text,
  rating numeric NOT NULL CHECK (rating >= 1.0 AND rating <= 5.0),
  comment text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  CONSTRAINT reviews_pkey PRIMARY KEY (id),
  CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.service_areas (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid,
  area_name text NOT NULL,
  city text,
  state text,
  postal_code text,
  coordinates jsonb,
  radius_km numeric,
  is_primary boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT service_areas_pkey PRIMARY KEY (id),
  CONSTRAINT service_areas_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id)
);

CREATE TABLE public.service_coupons (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  service_id uuid NOT NULL,
  coupon_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT service_coupons_pkey PRIMARY KEY (id),
  CONSTRAINT service_coupons_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id),
  CONSTRAINT service_coupons_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.service_listings(id)
);

CREATE TABLE public.service_listings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  add_ons jsonb DEFAULT '[]'::jsonb,
  booking_notice text,
  setup_time text,
  pincodes ARRAY,
  venue_types ARRAY,
  listing_id text,
  category text,
  theme_tags ARRAY,
  cover_photo text,
  photos ARRAY,
  video_url text,
  original_price numeric,
  offer_price numeric,
  promotional_tag text,
  inclusions ARRAY,
  customization_available boolean,
  customization_note text,
  is_featured boolean,
  service_environment ARRAY,
  vendor_id uuid,
  rating numeric DEFAULT 0.0,
  reviews_count integer DEFAULT 0,
  offers_count integer DEFAULT 0,
  decoration_type character varying DEFAULT 'inside'::character varying CHECK (decoration_type::text = ANY (ARRAY['inside'::character varying, 'outside'::character varying, 'both'::character varying]::text[])),
  latitude numeric,
  longitude numeric,
  CONSTRAINT service_listings_pkey PRIMARY KEY (id),
  CONSTRAINT service_listings_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id),
  CONSTRAINT fk_service_listings_category FOREIGN KEY (category) REFERENCES public.categories(name)
);

CREATE TABLE public.service_types (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  icon_url text,
  category text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT service_types_pkey PRIMARY KEY (id)
);

CREATE TABLE public.special_services (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  description text,
  icon_url text,
  price numeric NOT NULL DEFAULT 0.00,
  duration_minutes integer,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT special_services_pkey PRIMARY KEY (id)
);

CREATE TABLE public.theater_bookings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  theater_id uuid NOT NULL,
  time_slot_id uuid NOT NULL,
  user_id uuid NOT NULL,
  booking_date date NOT NULL,
  start_time time without time zone NOT NULL,
  end_time time without time zone NOT NULL,
  total_amount numeric NOT NULL,
  payment_status character varying DEFAULT 'pending'::character varying CHECK (payment_status::text = ANY (ARRAY['pending'::character varying, 'paid'::character varying, 'failed'::character varying, 'refunded'::character varying]::text[])),
  payment_id character varying,
  booking_status character varying DEFAULT 'confirmed'::character varying CHECK (booking_status::text = ANY (ARRAY['confirmed'::character varying, 'cancelled'::character varying, 'completed'::character varying]::text[])),
  guest_count integer DEFAULT 1,
  special_requests text,
  contact_name character varying NOT NULL,
  contact_phone character varying NOT NULL,
  contact_email character varying,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  celebration_name text,
  number_of_people integer DEFAULT 2,
  CONSTRAINT theater_bookings_pkey PRIMARY KEY (id),
  CONSTRAINT theater_bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT theater_bookings_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.theater_time_slots(id),
  CONSTRAINT theater_bookings_theater_id_fkey FOREIGN KEY (theater_id) REFERENCES public.private_theaters(id)
);

CREATE TABLE public.theater_reviews (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  theater_id uuid NOT NULL,
  user_id uuid NOT NULL,
  booking_id uuid,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text text,
  is_verified boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT theater_reviews_pkey PRIMARY KEY (id),
  CONSTRAINT theater_reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.theater_bookings(id),
  CONSTRAINT theater_reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT theater_reviews_theater_id_fkey FOREIGN KEY (theater_id) REFERENCES public.private_theaters(id)
);

CREATE TABLE public.theater_screens (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  theater_id uuid NOT NULL,
  screen_name character varying NOT NULL,
  screen_number integer NOT NULL,
  capacity integer NOT NULL DEFAULT 0,
  amenities ARRAY DEFAULT '{}'::text[],
  hourly_rate numeric NOT NULL DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT theater_screens_pkey PRIMARY KEY (id),
  CONSTRAINT theater_screens_theater_id_fkey FOREIGN KEY (theater_id) REFERENCES public.private_theaters(id)
);

CREATE TABLE public.theater_slot_bookings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  theater_id uuid,
  time_slot_id uuid,
  booking_date date NOT NULL,
  start_time time without time zone NOT NULL,
  end_time time without time zone NOT NULL,
  status text DEFAULT 'available'::text CHECK (status = ANY (ARRAY['available'::text, 'booked'::text, 'blocked'::text, 'maintenance'::text])),
  booking_id uuid,
  slot_price numeric NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  screen_id uuid,
  CONSTRAINT theater_slot_bookings_pkey PRIMARY KEY (id),
  CONSTRAINT theater_slot_bookings_screen_id_fkey FOREIGN KEY (screen_id) REFERENCES public.theater_screens(id),
  CONSTRAINT theater_slot_bookings_theater_id_fkey FOREIGN KEY (theater_id) REFERENCES public.private_theaters(id),
  CONSTRAINT theater_slot_bookings_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.theater_time_slots(id),
  CONSTRAINT theater_slot_bookings_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.theater_bookings(id)
);

CREATE TABLE public.theater_time_slots (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  theater_id uuid NOT NULL,
  slot_date date NOT NULL,
  start_time time without time zone NOT NULL,
  end_time time without time zone NOT NULL,
  is_available boolean DEFAULT true,
  price_multiplier numeric DEFAULT 1.00,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  base_price numeric DEFAULT 0,
  price_per_hour numeric DEFAULT 0,
  weekday_multiplier numeric DEFAULT 1.0,
  weekend_multiplier numeric DEFAULT 1.5,
  holiday_multiplier numeric DEFAULT 2.0,
  max_duration_hours integer DEFAULT 2,
  min_duration_hours integer DEFAULT 2,
  is_active boolean DEFAULT true,
  screen_id uuid,
  CONSTRAINT theater_time_slots_pkey PRIMARY KEY (id),
  CONSTRAINT theater_time_slots_theater_id_fkey FOREIGN KEY (theater_id) REFERENCES public.private_theaters(id),
  CONSTRAINT theater_time_slots_screen_id_fkey FOREIGN KEY (screen_id) REFERENCES public.theater_screens(id)
);

CREATE TABLE public.user_profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  auth_user_id uuid UNIQUE,
  app_type text NOT NULL CHECK (app_type = ANY (ARRAY['vendor'::text, 'customer'::text, 'user'::text])),
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  full_name text,
  phone_number text,
  email text,
  date_of_birth date,
  gender text,
  profile_image_url text,
  bio text,
  city text,
  state text,
  country text DEFAULT 'India'::text,
  postal_code text,
  emergency_contact_name text,
  emergency_contact_phone text,
  celebration_date date,
  celebration_time time without time zone,
  CONSTRAINT user_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT user_profiles_auth_user_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.vendor_documents (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid,
  document_type text NOT NULL CHECK (document_type = ANY (ARRAY['business_license'::text, 'identity'::text, 'insurance'::text, 'certification'::text, 'tax_document'::text, 'identity_aadhaar_front'::text, 'identity_aadhaar_back'::text, 'identity_pan'::text])),
  document_url text NOT NULL,
  verification_status text DEFAULT 'pending'::text CHECK (verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text])),
  verified_at timestamp with time zone,
  notes text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT vendor_documents_pkey PRIMARY KEY (id),
  CONSTRAINT vendor_documents_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id)
);

CREATE TABLE public.vendor_inquiry_times (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid NOT NULL,
  inquiry_start_time timestamp with time zone NOT NULL,
  inquiry_end_time timestamp with time zone,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT vendor_inquiry_times_pkey PRIMARY KEY (id),
  CONSTRAINT vendor_inquiry_times_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id)
);

CREATE TABLE public.vendor_private_details (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid NOT NULL UNIQUE,
  aadhaar_number text,
  bank_account_number text,
  bank_ifsc_code text,
  gst_number text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT vendor_private_details_pkey PRIMARY KEY (id),
  CONSTRAINT vendor_private_details_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id)
);

CREATE TABLE public.vendor_wallets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid NOT NULL UNIQUE,
  available_balance numeric NOT NULL DEFAULT 0.00 CHECK (available_balance >= 0::numeric),
  pending_balance numeric NOT NULL DEFAULT 0.00 CHECK (pending_balance >= 0::numeric),
  total_earned numeric NOT NULL DEFAULT 0.00,
  total_withdrawn numeric NOT NULL DEFAULT 0.00,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT vendor_wallets_pkey PRIMARY KEY (id),
  CONSTRAINT vendor_wallets_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id)
);

CREATE TABLE public.vendors (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
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
  rating numeric DEFAULT 0.00 CHECK (rating >= 0::numeric AND rating <= 5::numeric),
  total_reviews integer DEFAULT 0,
  total_jobs_completed integer DEFAULT 0,
  verification_status text DEFAULT 'pending'::text CHECK (verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text])),
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  auth_user_id uuid,
  is_onboarding_completed boolean DEFAULT false,
  fcm_token text,
  is_verified boolean DEFAULT false,
  CONSTRAINT vendors_pkey PRIMARY KEY (id)
);

CREATE TABLE public.wallet_transactions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid NOT NULL,
  transaction_type character varying NOT NULL CHECK (transaction_type::text = ANY (ARRAY['order_payment'::character varying, 'order_refund'::character varying, 'withdrawal'::character varying, 'withdrawal_fee'::character varying, 'bonus'::character varying, 'penalty'::character varying]::text[])),
  amount numeric NOT NULL,
  status character varying DEFAULT 'completed'::character varying CHECK (status::text = ANY (ARRAY['pending'::character varying, 'completed'::character varying, 'failed'::character varying, 'cancelled'::character varying]::text[])),
  description text,
  reference_id uuid,
  reference_type character varying,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT wallet_transactions_pkey PRIMARY KEY (id),
  CONSTRAINT wallet_transactions_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id)
);

CREATE TABLE public.wallets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE,
  balance numeric DEFAULT 0.00 CHECK (balance >= 0::numeric),
  total_refunds numeric DEFAULT 0.00 CHECK (total_refunds >= 0::numeric),
  total_cashbacks numeric DEFAULT 0.00 CHECK (total_cashbacks >= 0::numeric),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT wallets_pkey PRIMARY KEY (id),
  CONSTRAINT wallets_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.wishlist (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  service_id uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT wishlist_pkey PRIMARY KEY (id),
  CONSTRAINT wishlist_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.service_listings(id),
  CONSTRAINT wishlist_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.withdrawal_requests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  vendor_id uuid NOT NULL,
  amount numeric NOT NULL CHECK (amount > 0::numeric),
  status character varying DEFAULT 'pending'::character varying CHECK (status::text = ANY (ARRAY['pending'::character varying, 'approved'::character varying, 'rejected'::character varying, 'completed'::character varying]::text[])),
  bank_account_number text,
  bank_ifsc_code text,
  bank_account_holder_name text,
  admin_notes text,
  processed_by uuid,
  processed_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT withdrawal_requests_pkey PRIMARY KEY (id),
  CONSTRAINT withdrawal_requests_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id)
);
```

## Key Relationships

### Vendor Ecosystem
- **vendors** → **service_listings** (1:many)
- **vendors** → **bookings** (1:many)
- **vendors** → **vendor_wallets** (1:1)
- **vendors** → **vendor_documents** (1:many)

### Booking System
- **bookings** → **service_listings** (many:1)
- **bookings** → **payment_transactions** (1:many)
- **bookings** → **notification_queue** (1:many)

### Theater Management
- **private_theaters** → **theater_screens** (1:many)
- **theater_screens** → **theater_time_slots** (1:many)
- **theater_time_slots** → **theater_bookings** (1:many)

### User Management
- **auth.users** → **user_profiles** (1:1)
- **auth.users** → **vendors** (1:1)
- **auth.users** → **wallets** (1:1)

## Usage Notes

- Use this schema reference when implementing Supabase database operations
- All tables use UUID primary keys with `gen_random_uuid()`
- Timestamps use `timezone('utc'::text, now())` for consistency
- Row Level Security (RLS) policies control data access
- JSONB fields store complex data structures (location, metadata, etc.)
- Check constraints ensure data integrity on status fields