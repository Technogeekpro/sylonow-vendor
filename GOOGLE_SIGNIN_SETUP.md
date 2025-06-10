# Google Sign-In Setup for Supabase Authentication

## ✅ Current Configuration (Supabase Only - No Firebase)

### 1. Google Cloud Console Setup ✅
- **Project**: sylonow-85de9
- **Package Name**: com.example.sylonow_vendor

### 2. Client IDs ✅
```
Android Client ID: 828054656956-lj41eng32h75vafq8srrhrn82cmd2qsr.apps.googleusercontent.com
Web Client ID: 828054656956-bnntihgtvfpm16vhc50gnippgpn2jqev.apps.googleusercontent.com
Web Client Secret: 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
```

### 3. Flutter Configuration ✅
**lib/features/onboarding/screens/welcome_screen.dart**
```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId: '828054656956-bnntihgtvfpm16vhc50gnippgpn2jqev.apps.googleusercontent.com',
);
```

### 4. Android Configuration ✅
**android/app/build.gradle.kts**
```kotlin
dependencies {
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}
```

### 5. Supabase Dashboard Configuration 🚨 IMPORTANT
1. Go to **Supabase Dashboard** → **Authentication** → **Providers**
2. Enable **Google** provider
3. Add your credentials:
   - **Client ID**: `828054656956-bnntihgtvfpm16vhc50gnippgpn2jqev.apps.googleusercontent.com`
   - **Client Secret**: `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`
4. **Redirect URL**: `https://bsxkxgtwxtggicjocqvp.supabase.co/auth/v1/callback`
5. Click **Save**

## 🚫 What We DON'T Need (Since Using Supabase)
- ❌ google-services.json file
- ❌ Firebase plugins in build.gradle
- ❌ Firebase classpath dependencies
- ❌ manifestPlaceholders for Google client ID
- ❌ meta-data in AndroidManifest.xml for Google client ID

## ✅ Key Points
- We use **Supabase's built-in Google auth provider**
- Only need **google_sign_in** Flutter package
- Use **web client ID** as serverClientId for Supabase integration
- Google Sign-In provides ID token directly to Supabase
- No Android manifest configuration needed - all done in Flutter code

## Overview ✅

The app now uses **Native Google Sign-In UI** with **Supabase authentication**. This provides the best user experience:
- ✅ **Native account picker** - No browser popups, just a smooth in-app account selection
- ✅ **Supabase integration** - ID token is passed to Supabase for authentication
- ✅ **Best of both worlds** - Native UX with Supabase backend

## Current Implementation ✅

The app uses a hybrid approach:
1. **Google Sign-In package** shows native account selection UI
2. **Gets ID token** from Google authentication
3. **Passes token to Supabase** using `signInWithIdToken()`
4. **User is authenticated** in Supabase with Google account

## How It Works

```dart
// Native Google Sign-In shows account picker
final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

// Authenticate with Supabase using the Google ID token
final AuthResponse response = await SupabaseConfig.client.auth.signInWithIdToken(
  provider: OAuthProvider.google,
  idToken: googleAuth.idToken!,
  accessToken: googleAuth.accessToken,
);
```

## User Experience Flow

### ✅ What Users See:
1. **Tap "Continue with Google"** → Native account picker appears
2. **Select Google account** → Quick authentication (no browser)
3. **Automatic routing based on vendor status**:
   - **New user** → Redirected to vendor onboarding screen
   - **Incomplete onboarding** → Redirected to vendor onboarding screen
   - **Pending verification** → Redirected to verification pending screen
   - **Verified vendor** → Redirected to home screen
4. **If error occurs** → Clear error message with phone verification option

### ✅ Same Flow as OTP:
- Both Google and OTP authentication follow identical routing logic
- Router automatically checks vendor status after authentication
- No manual navigation - system handles everything automatically
- Consistent user experience regardless of sign-in method

## Troubleshooting

### Common Issues:

1. **Error Code 10** - "sign_in_failed":
   - Add SHA-1 fingerprint to Android OAuth client
   - Make sure package name matches exactly

2. **"serverAuthCode is null"**:
   - Verify web client ID is correct in configuration
   - Make sure web client ID is different from Android client ID

3. **"Failed to get ID token"**:
   - Check if Google+ API is enabled
   - Verify OAuth consent screen is configured

### Debug Tips:

1. **Check SHA-1**: Make sure it matches your keystore
2. **Verify Client IDs**: Web client ID should be in the code, Android client ID should be in Google Console
3. **Test on Device**: Emulator might not have Google Play Services

## Advantages of This Approach

✅ **Native UX** - Smooth in-app account selection  
✅ **No Browser** - No external browser popups  
✅ **Supabase Integration** - Full compatibility with your backend  
✅ **Reliable** - Uses proven Google Sign-In SDK  
✅ **Secure** - Google handles authentication, Supabase handles authorization  

## Files Modified

- `lib/features/onboarding/screens/welcome_screen.dart` - Native Google Sign-In + Supabase auth
- `pubspec.yaml` - Added google_sign_in package back
- `android/app/build.gradle.kts` - Added web client ID configuration
- `android/app/src/main/AndroidManifest.xml` - Added Google Sign-In meta-data

---

**Result**: You get the native Google account picker you wanted, with Supabase handling the backend authentication! 🎉 