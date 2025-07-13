@echo off
echo ===========================================
echo Building Sylonow Vendor App Release Builds
echo ===========================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter and ensure it's in your system PATH
    pause
    exit /b 1
)

echo Flutter version:
flutter --version
echo.

REM Clean the project
echo Step 1: Cleaning Flutter project...
flutter clean
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to clean Flutter project
    pause
    exit /b 1
)

REM Get dependencies
echo Step 2: Getting Flutter dependencies...
flutter pub get
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to get Flutter dependencies
    pause
    exit /b 1
)

REM Generate code (for Riverpod, Freezed, etc.)
echo Step 3: Generating code...
flutter packages pub run build_runner build --delete-conflicting-outputs
if %ERRORLEVEL% neq 0 (
    echo WARNING: Code generation failed, continuing anyway...
)

REM Generate app icons
echo Step 4: Generating app icons...
flutter pub run flutter_launcher_icons
if %ERRORLEVEL% neq 0 (
    echo WARNING: Icon generation failed, continuing anyway...
)

REM Generate splash screen
echo Step 5: Generating splash screen...
flutter pub run flutter_native_splash:create
if %ERRORLEVEL% neq 0 (
    echo WARNING: Splash screen generation failed, continuing anyway...
)

echo.
echo ===========================================
echo Building Release AAB (Android App Bundle)
echo ===========================================

REM Build AAB for Play Store
echo Building AAB (Android App Bundle) for Play Store distribution...
flutter build appbundle --release
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to build AAB
    pause
    exit /b 1
)

echo.
echo ===========================================
echo Building Release APK
echo ===========================================

REM Build APK for direct distribution
echo Building APK for direct distribution...
flutter build apk --release
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to build APK
    pause
    exit /b 1
)

echo.
echo ===========================================
echo Build Summary
echo ===========================================

REM Check if files were created
set AAB_PATH=build\app\outputs\bundle\release\app-release.aab
set APK_PATH=build\app\outputs\flutter-apk\app-release.apk

if exist "%AAB_PATH%" (
    echo ✓ AAB created successfully: %AAB_PATH%
    for %%i in ("%AAB_PATH%") do echo   Size: %%~zi bytes
) else (
    echo ✗ AAB not found at expected location
)

if exist "%APK_PATH%" (
    echo ✓ APK created successfully: %APK_PATH%
    for %%i in ("%APK_PATH%") do echo   Size: %%~zi bytes
) else (
    echo ✗ APK not found at expected location
)

echo.
echo App Version: 1.0.0+1
echo Build Configuration: Release
echo Signing: Configured with sylonow-vendor-key.jks
echo.
echo ===========================================
echo Next Steps:
echo ===========================================
echo 1. For Play Store: Upload the AAB file to Google Play Console
echo 2. For Direct Distribution: Use the APK file
echo 3. Test the builds on physical devices before distribution
echo.
echo Build completed!
pause 