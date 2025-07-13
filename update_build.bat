@echo off
echo ==========================================
echo Building App Update - Safety Check
echo ==========================================

echo Checking version numbers...
findstr /C:"version:" pubspec.yaml
echo.
echo WARNING: Ensure version is higher than current Play Store version!
echo Current Play Store: 1.0.0+1
echo.
set /p continue="Continue with build? (y/n): "
if /i "%continue%" NEQ "y" exit /b

flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs

echo Building update...
flutter build appbundle --release
flutter build apk --release

echo ==========================================
echo Update files ready:
echo AAB: build\app\outputs\bundle\release\app-release.aab
echo APK: build\app\outputs\flutter-apk\app-release.apk
echo ==========================================