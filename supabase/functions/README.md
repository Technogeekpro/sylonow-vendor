# 🚀 Supabase Edge Functions - Deployment Guide

## 📋 Overview

This directory contains Supabase Edge Functions for the SyloNow Vendor app. The main function `process-notifications` handles Firebase Cloud Messaging (FCM) notifications using the modern OAuth 2.0 approach.

## 🔧 Functions

### `process-notifications`
- **Purpose**: Process notification queue and send FCM push notifications
- **API**: Uses Firebase FCM HTTP v1 API with OAuth 2.0
- **Authentication**: Service account-based (no deprecated server key)

## 🚀 Deployment Steps

### 1. Prerequisites
- Supabase CLI installed
- Firebase project configured
- Service account JSON from Firebase

### 2. Environment Variables

Set these environment variables in your Supabase project:

```bash
# Optional: Firebase service account JSON (for production FCM)
supabase secrets set FIREBASE_SERVICE_ACCOUNT='{"type":"service_account","project_id":"your-project","private_key":"-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n","client_email":"firebase-adminsdk-...@your-project.iam.gserviceaccount.com"}'

# Optional: Firebase project ID (defaults to 'sylonow-vendor')
supabase secrets set FIREBASE_PROJECT_ID='your-firebase-project-id'
```

### 3. Deploy Function

```bash
# Deploy the function
supabase functions deploy process-notifications

# Or deploy all functions
supabase functions deploy
```

### 4. Test Function

```bash
# Test locally
supabase functions serve

# Test remotely
curl -X POST https://your-project.supabase.co/functions/v1/process-notifications \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{}'
```

## 🔐 Authentication Modes

### Test Mode (Default)
- **When**: No `FIREBASE_SERVICE_ACCOUNT` configured
- **Behavior**: Simulates FCM sending, marks notifications as sent
- **Use**: Development and testing

### Production Mode
- **When**: `FIREBASE_SERVICE_ACCOUNT` configured with valid service account JSON
- **Behavior**: Sends actual FCM notifications via OAuth 2.0
- **Use**: Production deployment

## 📊 Response Format

```json
{
  "message": "Notification processing completed",
  "processed": 5,
  "successful": 4,
  "failed": 1,
  "timestamp": "2025-01-24T10:30:00.000Z"
}
```

## 🛠️ Getting Firebase Service Account

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Settings → Service Accounts**
4. Click **"Generate New Private Key"**
5. Download the JSON file
6. Set it as `FIREBASE_SERVICE_ACCOUNT` environment variable

## 🔄 Modern FCM API Features

- ✅ **OAuth 2.0 Authentication** (no deprecated server key)
- ✅ **HTTP v1 API** (latest Firebase API)
- ✅ **Cross-platform Support** (Android + iOS)
- ✅ **Rich Notifications** (custom channels, sounds, actions)
- ✅ **Error Handling** (retry logic, error logging)

## 📱 Integration

The Flutter app calls this function via:

```dart
final response = await SupabaseConfig.client.functions.invoke(
  'process-notifications',
  body: {},
);
```

## 🐛 Troubleshooting

### Function Not Found
- Ensure function is deployed: `supabase functions list`
- Check function name matches exactly

### Authentication Errors
- Verify Supabase anon key is correct
- Check RLS policies allow function access

### FCM Errors
- Verify Firebase project ID is correct
- Check service account has FCM permissions
- Ensure FCM API is enabled in Google Cloud Console

## 📝 Logs

View function logs:
```bash
supabase functions logs process-notifications
```

## 🔄 Updates

To update the function:
1. Modify the `index.ts` file
2. Run `supabase functions deploy process-notifications`
3. Test with the Flutter app

---

**Status**: ✅ Ready for deployment
**Last Updated**: January 2025
**API Version**: FCM HTTP v1 