@echo off
echo ========================================
echo   Sylonow Vendor - Keystore Generator
echo ========================================
echo.

:: Create keystore directory if it doesn't exist
if not exist "android\keystore" mkdir android\keystore

echo This script will generate a release keystore for your app.
echo You will be prompted for the following information:
echo - Keystore password
echo - Key password  
echo - Your name
echo - Organization name
echo - City
echo - State/Province
echo - Country code (2 letters)
echo.

pause

echo Generating keystore...
keytool -genkey -v -keystore android\keystore\sylonow-vendor-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sylonow-vendor

if %errorlevel% equ 0 (
    echo.
    echo ✅ Keystore generated successfully!
    echo.
    echo Next steps:
    echo 1. Update android\key.properties with your keystore passwords
    echo 2. Uncomment the signing configuration in android\app\build.gradle.kts
    echo 3. Get the SHA-1 fingerprint by running:
    echo    keytool -list -v -keystore android\keystore\sylonow-vendor-key.jks -alias sylonow-vendor
    echo.
) else (
    echo.
    echo ❌ Keystore generation failed!
    echo Please check that you have Java keytool installed and try again.
    echo.
)

pause 