# Release Build Instructions for Sylonow Vendor

## Prerequisites

### 1. Generate Release Keystore

Create a keystore file for signing your release APK/AAB:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Save the keystore file in a secure location outside your project directory.

### 2. Update key.properties

Edit `android/key.properties` with your actual keystore information:

```
storePassword=your_actual_keystore_password
keyPassword=your_actual_key_password
keyAlias=upload
storeFile=../path/to/your/upload-keystore.jks
```

### 3. Download google-services.json

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `sylonow-85de9`
3. Go to Project Settings
4. Select your Android app
5. Download `google-services.json`
6. Place it in `android/app/google-services.json`

## Building Release AAB

### Step 1: Clean and Get Dependencies

```bash
flutter clean
flutter pub get
```

### Step 2: Build Release AAB

```bash
flutter build appbundle --release
```

### Step 3: Build Release APK (optional)

```bash
flutter build apk --release
```

## Output Locations

- **AAB file**: `build/app/outputs/bundle/release/app-release.aab`
- **APK file**: `build/app/outputs/flutter-apk/app-release.apk`

## Google Auth Configuration for Release

### 1. SHA-1 Fingerprint for Release

Get your release keystore SHA-1 fingerprint:

```bash
keytool -list -v -keystore upload-keystore.jks -alias upload
```

### 2. Add SHA-1 to Firebase

1. Go to Firebase Console → Project Settings
2. Select your Android app
3. Add the SHA-1 fingerprint from your release keystore
4. Download the updated `google-services.json`

### 3. Update OAuth Client in Google Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to APIs & Credentials
3. Find your OAuth 2.0 client ID for Android
4. Add your release SHA-1 fingerprint
5. Make sure the package name matches: `com.example.sylonow_vendor`

## Testing Release Build

### Test Google Sign-In in Release Mode

```bash
flutter build apk --release
flutter install --release
```

Or install the AAB using bundletool:

```bash
# Download bundletool from Google
java -jar bundletool.jar build-apks --bundle=app-release.aab --output=app.apks --ks=upload-keystore.jks --ks-pass=pass:your_keystore_password --ks-key-alias=upload --key-pass=pass:your_key_password

java -jar bundletool.jar install-apks --apks=app.apks
```

## Upload to Play Store

1. Upload the `app-release.aab` file to Google Play Console
2. The AAB format is required for new apps and provides better optimization
3. Google Play will generate optimized APKs for each device configuration

## Troubleshooting

### Google Sign-In Issues

1. Verify SHA-1 fingerprint is correctly added to Firebase
2. Ensure OAuth client has the correct package name
3. Check that google-services.json is in the correct location
4. Verify the app is signed with the correct keystore

### Build Issues

1. Run `flutter clean` and `flutter pub get`
2. Check that all dependencies are compatible
3. Verify keystore path in key.properties
4. Ensure Android SDK and build tools are up to date

## Security Notes

- Never commit `key.properties` or your keystore file to version control
- Store keystore and passwords securely
- Use different keystores for debug and release builds
- Keep backup of your keystore - losing it means you can't update your app 