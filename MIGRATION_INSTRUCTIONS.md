# Sylonow Vendor Database Migration Instructions

## Overview
This migration script contains the complete schema and data from your sylonow-vendor Supabase project. It includes all tables, constraints, indexes, RLS policies, storage buckets, and sample data.

## What's Included

### Tables Migrated:
- `vendors` - Vendor profile information
- `service_types` - Available service categories (10 pre-populated)
- `service_areas` - Geographical service coverage
- `service_listings` - Individual services offered
- `vendor_documents` - Document verification
- `otp_verifications` - Phone number verification
- `app_settings` - Application configuration (5 pre-populated)

### Storage Buckets:
- `vendor-documents` - For storing vendor verification documents
- `vendor-images` - For storing vendor profile and portfolio images

### Security Features:
- Row Level Security (RLS) policies on all tables
- Proper storage bucket policies
- User authentication integration

## Migration Steps

### Step 1: Create or Access Target Supabase Project
1. Create a new Supabase project or use an existing one
2. Note down the project ID for the target database

### Step 2: Run the Migration Script
1. Open the Supabase Dashboard for your target project
2. Go to the SQL Editor
3. Copy and paste the contents of `sylonow_vendor_migration.sql`
4. Click "Run" to execute the migration

### Step 3: Verify Migration
After running the script, verify that:
- All 7 tables are created in the `public` schema
- Storage buckets `vendor-documents` and `vendor-images` exist
- Sample data is present in `service_types` and `app_settings` tables
- RLS policies are enabled and configured

### Step 4: Update Application Configuration
Update your Flutter app's Supabase configuration:
1. Replace the project URL with your new project's URL
2. Replace the anon key with your new project's anon key
3. Test the connection from your app

## Important Notes

### Security Considerations:
- The migration includes comprehensive RLS policies
- Vendors can only access their own data
- Public data (service types, verified vendors) is accessible to all
- Storage policies restrict document access to vendor owners

### Data Considerations:
- The script includes `ON CONFLICT DO NOTHING` for safety
- UUIDs are used for all primary keys
- All timestamps use UTC timezone
- JSONB is used for flexible data storage (location, portfolio images, etc.)

### Post-Migration Tasks:
1. Test user registration and authentication
2. Verify file upload to storage buckets
3. Test RLS policies with different user roles
4. Update any hardcoded references in your Flutter app

## Troubleshooting

### Common Issues:
1. **RLS Policy Errors**: Ensure you're testing with properly authenticated users
2. **Storage Access**: Check that storage policies match your app's access patterns
3. **Foreign Key Constraints**: Ensure related data is inserted in the correct order

### Getting Help:
- Check Supabase logs for detailed error messages
- Verify all extensions are enabled (uuid-ossp, pgcrypto)
- Ensure your app is using the correct project credentials

## Next Steps
After successful migration:
1. Test all app functionality
2. Set up any additional indexes for performance
3. Configure any custom Edge Functions if needed
4. Set up monitoring and logging for the new project

---
**Migration Source**: Project bsxkxgtwxtggicjocqvp (sylonow)  
**Generated**: 2025-01-27  
**Tables**: 7 tables with complete schema and relationships  
**Storage**: 2 buckets with proper access policies 