# PowerShell script to build release AAB for Sylonow Vendor
# Make sure to run this from the project root directory

Write-Host "🏗️  Sylonow Vendor Release Build Script" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# Check if google-services.json exists
if (-not (Test-Path "android\app\google-services.json")) {
    Write-Host "❌ ERROR: google-services.json not found!" -ForegroundColor Red
    Write-Host "📋 Please follow these steps:" -ForegroundColor Yellow
    Write-Host "1. Go to https://console.firebase.google.com/" -ForegroundColor White
    Write-Host "2. Select project: sylonow-85de9" -ForegroundColor White
    Write-Host "3. Go to Project Settings → Your Android app" -ForegroundColor White
    Write-Host "4. Download google-services.json" -ForegroundColor White
    Write-Host "5. Place it in android\app\google-services.json" -ForegroundColor White
    exit 1
}

# Check if key.properties is configured
if (Test-Path "android\key.properties") {
    $keyProps = Get-Content "android\key.properties"
    if ($keyProps -match "your_keystore_password") {
        Write-Host "⚠️  WARNING: key.properties contains placeholder values!" -ForegroundColor Yellow
        Write-Host "📋 Please update android\key.properties with your actual keystore info" -ForegroundColor Yellow
        Write-Host "💡 Generate keystore with: keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload" -ForegroundColor White
        exit 1
    }
} else {
    Write-Host "❌ ERROR: key.properties not found!" -ForegroundColor Red
    Write-Host "📋 Please create android\key.properties with your keystore information" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ google-services.json found" -ForegroundColor Green
Write-Host "✅ key.properties configured" -ForegroundColor Green

# Clean project
Write-Host "🧹 Cleaning project..." -ForegroundColor Blue
flutter clean

# Get dependencies
Write-Host "📦 Getting dependencies..." -ForegroundColor Blue
flutter pub get

# Build release AAB
Write-Host "🏗️  Building release AAB..." -ForegroundColor Blue
$buildResult = flutter build appbundle --release

if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 SUCCESS! Release AAB built successfully!" -ForegroundColor Green
    Write-Host "📁 AAB location: build\app\outputs\bundle\release\app-release.aab" -ForegroundColor Cyan
    
    if (Test-Path "build\app\outputs\bundle\release\app-release.aab") {
        $size = (Get-Item "build\app\outputs\bundle\release\app-release.aab").Length / 1MB
        Write-Host "📊 AAB size: $([math]::Round($size, 2)) MB" -ForegroundColor Yellow
    }
    
    Write-Host "🚀 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Test the release build on a device" -ForegroundColor White
    Write-Host "2. Upload app-release.aab to Google Play Console" -ForegroundColor White
    Write-Host "3. Verify Google Sign-In works in release mode" -ForegroundColor White
} else {
    Write-Host "❌ Build failed! Check the errors above." -ForegroundColor Red
    exit 1
}

# Optional: Build APK for testing
$buildApk = Read-Host "🤔 Do you want to build a release APK for testing? (y/n)"
if ($buildApk -eq "y" -or $buildApk -eq "Y") {
    Write-Host "🏗️  Building release APK..." -ForegroundColor Blue
    flutter build apk --release
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Release APK built successfully!" -ForegroundColor Green
        Write-Host "📁 APK location: build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Cyan
        
        if (Test-Path "build\app\outputs\flutter-apk\app-release.apk") {
            $apkSize = (Get-Item "build\app\outputs\flutter-apk\app-release.apk").Length / 1MB
            Write-Host "📊 APK size: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Yellow
        }
    }
}

Write-Host "✨ Build process completed!" -ForegroundColor Green 