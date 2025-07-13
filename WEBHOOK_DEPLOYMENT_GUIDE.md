# Supabase Webhook Deployment Guide

This guide provides step-by-step instructions for setting up database webhooks to trigger OneSignal notifications when bookings are created or updated.

## Prerequisites

Before starting, ensure you have:

- ✅ Supabase project with admin access
- ✅ OneSignal edge function `order-notifications-onesignal` deployed
- ✅ Supabase service role key (for webhook authentication)
- ✅ Access to Supabase SQL Editor

## 🔧 Step 1: Enable Required Extensions

1. Go to your Supabase Dashboard
2. Navigate to **Database > Extensions**
3. Enable the following extensions:
   - `pg_net` (for HTTP requests)
   - `uuid-ossp` (for UUID generation)

## 📋 Step 2: Deploy the Webhook Setup

### 2.1 Run the Main Setup Script

1. Open **Supabase Dashboard > SQL Editor**
2. Copy and run the contents of `setup_bookings_webhook.sql`
3. This will create:
   - Bookings table (if not exists)
   - Webhook function `notify_booking_change()`
   - Database triggers for INSERT and UPDATE
   - RLS policies for security

### 2.2 Configure Project-Specific Details

1. Update the webhook function with your project details:
   ```sql
   -- Replace in configure_webhook.sql
   project_url := 'https://YOUR_PROJECT_REF.supabase.co';
   api_key := 'YOUR_SERVICE_ROLE_KEY_HERE';
   ```

2. Run the updated `configure_webhook.sql` script

### 2.3 Get Your Project Details

To find your project details:

1. **Project URL**: 
   - Go to Settings > General
   - Copy "Reference ID"
   - Format: `https://[reference-id].supabase.co`

2. **Service Role Key**:
   - Go to Settings > API
   - Copy "service_role" key (not anon key)
   - This key has elevated permissions for internal operations

## 🧪 Step 3: Test the Integration

### 3.1 Run Verification Tests

1. Execute `test_webhook_integration.sql` in SQL Editor
2. Check that all verification checks show ✅ status
3. Monitor the test booking creation and update

### 3.2 Verify OneSignal Integration

1. Go to OneSignal Dashboard
2. Check for test notifications sent to vendor devices
3. Verify notification content and targeting

### 3.3 Check Edge Function Logs

1. Go to Supabase Dashboard > Edge Functions
2. Select `order-notifications-onesignal`
3. Check logs for webhook calls and any errors

## 🔒 Step 4: Security Configuration

### 4.1 Row Level Security (RLS)

The setup automatically creates these policies:

- ✅ Vendors can view their own bookings
- ✅ Vendors can update their own bookings  
- ✅ Service role has full access (for webhooks)
- ✅ Authenticated users can create bookings

### 4.2 Function Security

- ✅ Webhook function runs with `SECURITY DEFINER`
- ✅ Uses service role authentication for internal calls
- ✅ Error handling prevents operation blocking

## 📊 Step 5: Monitoring and Maintenance

### 5.1 Monitor Webhook Activity

```sql
-- Check recent webhook triggers
SELECT 
    id, service_title, status, 
    created_at, updated_at
FROM public.bookings 
ORDER BY updated_at DESC 
LIMIT 10;
```

### 5.2 View Trigger Status

```sql
-- Check if triggers are active
SELECT 
    trigger_name, event_manipulation, 
    event_object_table
FROM information_schema.triggers 
WHERE trigger_name LIKE '%bookings_notification%';
```

### 5.3 Debug Webhook Issues

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| No notifications sent | Check edge function logs, verify API keys |
| Trigger not firing | Verify triggers exist, check RLS policies |
| HTTP errors | Check network settings, verify endpoint URL |
| Permission denied | Update service role key, check function security |

## 🔄 Step 6: Production Deployment

### 6.1 Environment-Specific Configuration

For different environments (dev, staging, prod):

1. Update webhook URLs per environment
2. Use environment-specific OneSignal app IDs
3. Configure separate API keys

### 6.2 Performance Optimization

```sql
-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_bookings_vendor_status 
ON public.bookings(vendor_id, status);

CREATE INDEX IF NOT EXISTS idx_bookings_updated_at 
ON public.bookings(updated_at DESC);
```

## 🚨 Troubleshooting

### Common Error Messages

1. **"pg_net extension not found"**
   - Enable pg_net extension in Supabase Dashboard

2. **"Permission denied for net.http_post"**
   - Check service role permissions
   - Verify function security settings

3. **"Webhook timeout"**
   - Increase timeout_ms in webhook function
   - Check edge function performance

4. **"OneSignal API error"**
   - Verify OneSignal app configuration
   - Check API keys and app IDs

### Debug Mode

Enable debug logging:

```sql
-- Increase log level for debugging
SET log_min_messages = 'LOG';

-- Check recent logs
SELECT * FROM pg_stat_statements 
WHERE query LIKE '%notify_booking_change%';
```

## 📝 Maintenance Commands

### Update Webhook Configuration

```sql
-- Update webhook URL
UPDATE public.app_settings 
SET setting_value = '"https://new-url.supabase.co"'
WHERE setting_key = 'supabase_project_url';
```

### Disable Webhooks Temporarily

```sql
-- Disable all webhook triggers
ALTER TABLE public.bookings DISABLE TRIGGER ALL;

-- Re-enable when ready
ALTER TABLE public.bookings ENABLE TRIGGER ALL;
```

### Clean Up Test Data

```sql
-- Remove test bookings
DELETE FROM public.bookings 
WHERE service_title LIKE '%Test%' 
OR customer_name = 'Test Customer';
```

## ✅ Success Criteria

Your webhook integration is working correctly when:

- ✅ New bookings trigger OneSignal notifications
- ✅ Booking status updates send notifications
- ✅ Edge function logs show successful webhook calls
- ✅ Vendors receive real-time notifications
- ✅ No errors in Supabase logs
- ✅ Performance remains optimal

## 📚 Additional Resources

- [Supabase Webhooks Documentation](https://supabase.com/docs/guides/database/webhooks)
- [pg_net Extension Documentation](https://github.com/supabase/pg_net)
- [OneSignal API Documentation](https://documentation.onesignal.com/reference)
- [Edge Functions Documentation](https://supabase.com/docs/guides/functions)

---

**Need Help?** Check the troubleshooting section or review edge function logs for specific error messages.