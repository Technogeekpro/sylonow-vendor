# Sylonow Vendor App - Release Checklist

## Pre-Release Checklist

### 📱 App Configuration
- [x] App version updated in `pubspec.yaml` (Currently: 1.0.0+1)
- [x] Android signing key configured (`sylonow-vendor-key.jks`)
- [x] App ID set correctly (`com.sylonow.vendor`)
- [x] Target SDK set to 34 (Android 14)
- [x] Min SDK set to 23 (Android 6.0)
- [x] App icons configured for all sizes
- [x] Splash screen configured
- [x] App permissions properly declared in AndroidManifest.xml

### 🔧 Firebase & Supabase Configuration
- [x] Firebase project connected (`google-services.json` in place)
- [x] Supabase project URL and anon key configured
- [x] Firebase Cloud Messaging (FCM) set up for notifications
- [x] Google Sign-In configuration completed

### 🧪 Testing Requirements
- [ ] Test on physical Android devices (not just emulator)
- [ ] Test all onboarding flows
- [ ] Test Google Sign-In authentication
- [ ] Test image upload functionality
- [ ] Test notifications (if implemented)
- [ ] Test offline behavior
- [ ] Test app permissions (camera, storage, etc.)
- [ ] Test on different screen sizes and orientations

### 📊 Performance & Security
- [ ] Remove all debug logging statements
- [ ] Obfuscation enabled (if needed)
- [ ] Network security configuration set
- [ ] App size optimized (check final APK/AAB size)
- [ ] Memory leaks checked
- [ ] Battery usage optimized

### 📝 Legal & Compliance
- [ ] Privacy Policy accessible in app
- [ ] Terms & Conditions accessible in app
- [ ] Cookie Policy accessible in app
- [ ] Revenue Policy accessible in app
- [ ] Google Play Store policies compliance
- [ ] Data protection compliance (GDPR if applicable)

### 🏪 Store Preparation
- [ ] App screenshots prepared (phone & tablet)
- [ ] App store description written
- [ ] App store keywords optimized
- [ ] Feature graphic created
- [ ] App icon high-res version ready
- [ ] Age rating determined
- [ ] Content rating questionnaire completed

## Build Commands

### Quick Build (Run the script)
```bash
.\build_release.bat
```

### Manual Build Commands
```bash
# Clean and prepare
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate assets
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create

# Build for Play Store (AAB)
flutter build appbundle --release

# Build for direct distribution (APK)
flutter build apk --release
```

## Output Locations

After successful build, you'll find:

- **AAB (Play Store)**: `build/app/outputs/bundle/release/app-release.aab`
- **APK (Direct)**: `build/app/outputs/flutter-apk/app-release.apk`

## Upload Instructions

### Google Play Store (AAB)
1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to "Production" under "Release" section
4. Click "Create new release"
5. Upload the `app-release.aab` file
6. Fill in release notes
7. Review and rollout

### Direct Distribution (APK)
1. Share the `app-release.apk` file
2. Users need to enable "Install from unknown sources"
3. Consider using a distribution platform like Firebase App Distribution

## Version Management

Current version: `1.0.0+1`
- Version name: `1.0.0` (user-visible)
- Version code: `1` (internal, increment for each release)

To update version:
1. Edit `pubspec.yaml`: `version: 1.0.1+2`
2. Rebuild the app

## Troubleshooting

### Common Build Issues
1. **Signing errors**: Check keystore path and credentials
2. **Code generation errors**: Run `flutter packages pub run build_runner clean` first
3. **Gradle sync issues**: Delete `android/.gradle` folder
4. **Out of memory**: Add `org.gradle.jvmargs=-Xmx4g` to `android/gradle.properties`

### Testing Issues
1. **Google Sign-In not working**: Check SHA-1 fingerprints in Firebase Console
2. **Notifications not working**: Verify FCM configuration
3. **Image upload failing**: Check storage permissions and Supabase policies

## Final Notes

- Always test the release build on real devices before distribution
- Keep the signing key secure and backed up
- Monitor app performance and crash reports after release
- Have a rollback plan ready in case of issues

## Security Reminders

- [ ] Remove all hardcoded secrets/API keys
- [ ] Verify network security configuration
- [ ] Check that debug features are disabled
- [ ] Ensure proper certificate pinning (if implemented)
- [ ] Validate all user inputs properly 