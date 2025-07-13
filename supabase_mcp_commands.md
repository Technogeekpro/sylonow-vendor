# Supabase MCP Commands for Webhook Setup

This document provides the exact MCP (Model Context Protocol) commands to set up the database webhook and trigger for the orders/bookings table.

## 🔧 MCP Commands Sequence

### 1. Enable Required Extensions

```bash
# Enable pg_net extension for HTTP requests
supabase sql --db-url "$DATABASE_URL" --file - <<EOF
CREATE EXTENSION IF NOT EXISTS "pg_net";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOF
```

### 2. Create Bookings Table and Webhook Function

```bash
# Deploy the main webhook setup
supabase sql --db-url "$DATABASE_URL" --file setup_bookings_webhook.sql
```

### 3. Configure Project-Specific Details

```bash
# Update webhook configuration with your project details
supabase sql --db-url "$DATABASE_URL" --file configure_webhook.sql
```

### 4. Test the Integration

```bash
# Run integration tests
supabase sql --db-url "$DATABASE_URL" --file test_webhook_integration.sql
```

## 🎯 Alternative: Direct SQL Execution via Supabase CLI

If you prefer to run commands directly:

### Step 1: Initialize Supabase (if not done)

```bash
supabase login
supabase init
```

### Step 2: Link to Your Project

```bash
# Replace with your actual project reference
supabase link --project-ref bsxkxgtwxtggicjocqvp
```

### Step 3: Execute Webhook Setup

```bash
# Method 1: Using local SQL files
supabase db reset --db-url postgres://[your-connection-string]
supabase migration new create_webhook_setup
# Copy setup_bookings_webhook.sql content to the new migration file
supabase db push

# Method 2: Direct SQL execution
cat setup_bookings_webhook.sql | supabase sql --db-url "$DATABASE_URL"
cat configure_webhook.sql | supabase sql --db-url "$DATABASE_URL"
```

## 🔑 Required Environment Variables

Set these environment variables before running MCP commands:

```bash
# Supabase Configuration
export SUPABASE_PROJECT_REF="bsxkxgtwxtggicjocqvp"
export SUPABASE_URL="https://bsxkxgtwxtggicjocqvp.supabase.co"
export SUPABASE_ANON_KEY="your-anon-key"
export SUPABASE_SERVICE_KEY="your-service-role-key"
export DATABASE_URL="postgresql://postgres:[password]@db.[project-ref].supabase.co:5432/postgres"

# OneSignal Configuration
export ONESIGNAL_APP_ID="your-onesignal-app-id"
export ONESIGNAL_REST_API_KEY="your-onesignal-rest-api-key"
```

## 📋 Supabase Dashboard Commands

### Via Web Interface:

1. **Enable Extensions**:
   - Go to Database → Extensions
   - Enable: `pg_net`, `uuid-ossp`

2. **Execute SQL Scripts**:
   - Go to SQL Editor
   - Run `setup_bookings_webhook.sql`
   - Run `configure_webhook.sql`
   - Run `test_webhook_integration.sql`

3. **Verify Edge Function**:
   - Go to Edge Functions
   - Check `order-notifications-onesignal` deployment status
   - Review function logs

## 🔍 Verification MCP Commands

### Check Extension Status
```bash
supabase sql --db-url "$DATABASE_URL" -c "SELECT extname FROM pg_extension WHERE extname IN ('pg_net', 'uuid-ossp');"
```

### Verify Webhook Function
```bash
supabase sql --db-url "$DATABASE_URL" -c "SELECT routine_name FROM information_schema.routines WHERE routine_name = 'notify_booking_change';"
```

### Check Triggers
```bash
supabase sql --db-url "$DATABASE_URL" -c "SELECT trigger_name, event_manipulation FROM information_schema.triggers WHERE trigger_name LIKE '%bookings_notification%';"
```

### Test Webhook Call
```bash
# Insert test booking to trigger webhook
supabase sql --db-url "$DATABASE_URL" -c "
INSERT INTO public.bookings (
  vendor_id, service_title, booking_date, total_amount, status, customer_name
) VALUES (
  (SELECT id FROM public.vendors LIMIT 1),
  'MCP Test Booking',
  NOW() + INTERVAL '1 day',
  99.99,
  'pending',
  'Test Customer MCP'
) RETURNING id, service_title, status;
"
```

## 📊 Monitoring Commands

### Check Recent Bookings
```bash
supabase sql --db-url "$DATABASE_URL" -c "
SELECT id, service_title, status, created_at 
FROM public.bookings 
ORDER BY created_at DESC 
LIMIT 5;
"
```

### View Webhook Logs
```bash
# Check Supabase logs for webhook activity
supabase functions logs order-notifications-onesignal
```

### Monitor Edge Function
```bash
# Get function status
supabase functions list

# Deploy edge function if needed
supabase functions deploy order-notifications-onesignal --project-ref $SUPABASE_PROJECT_REF
```

## 🛠️ Debugging Commands

### Check Database Connection
```bash
supabase db status
```

### Validate Schema
```bash
supabase db diff --schema public
```

### Reset and Redeploy (if needed)
```bash
# Backup current state
supabase db dump --data-only > backup.sql

# Reset and redeploy
supabase db reset
supabase migration new webhook_setup
# Copy SQL content to migration file
supabase db push
```

## 🔄 Update Commands

### Update Webhook URL
```bash
supabase sql --db-url "$DATABASE_URL" -c "
UPDATE public.app_settings 
SET setting_value = '\"$SUPABASE_URL\"'
WHERE setting_key = 'supabase_project_url';
"
```

### Refresh Function
```bash
supabase sql --db-url "$DATABASE_URL" --file configure_webhook.sql
```

## ✅ Success Verification

Run this command to verify everything is working:

```bash
# Comprehensive verification
supabase sql --db-url "$DATABASE_URL" -c "
SELECT 
  'Extensions' as check_type,
  COUNT(*) as count
FROM pg_extension 
WHERE extname IN ('pg_net', 'uuid-ossp')
UNION ALL
SELECT 
  'Webhook Function',
  COUNT(*)
FROM information_schema.routines 
WHERE routine_name = 'notify_booking_change'
UNION ALL
SELECT 
  'Triggers',
  COUNT(*)
FROM information_schema.triggers 
WHERE trigger_name LIKE '%bookings_notification%'
UNION ALL
SELECT 
  'RLS Policies',
  COUNT(*)
FROM pg_policies 
WHERE tablename = 'bookings';
"
```

Expected output:
```
check_type        | count
------------------|------
Extensions        |   2
Webhook Function  |   1  
Triggers          |   2
RLS Policies      |   4+
```

## 🚨 Error Handling

### Common MCP Command Errors:

1. **Connection Error**:
   ```bash
   # Check connection
   supabase status
   supabase login --token $SUPABASE_ACCESS_TOKEN
   ```

2. **Permission Denied**:
   ```bash
   # Use service role key instead of anon key
   export DATABASE_URL="postgresql://postgres.${SUPABASE_PROJECT_REF}:${SUPABASE_DB_PASSWORD}@aws-0-us-west-1.pooler.supabase.com:5432/postgres"
   ```

3. **Function Not Found**:
   ```bash
   # Redeploy edge function
   supabase functions deploy order-notifications-onesignal
   ```

---

**Note**: Replace placeholder values (project refs, keys, passwords) with your actual Supabase project details before running these commands.