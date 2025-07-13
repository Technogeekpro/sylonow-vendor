@echo off
echo 🚀 Deploying SyloNow Vendor Edge Functions...
echo.

REM Check if Supabase CLI is installed
supabase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Supabase CLI not found!
    echo Please install it from: https://supabase.com/docs/guides/cli
    pause
    exit /b 1
)

echo ✅ Supabase CLI found

REM Check if we're logged in
supabase projects list >nul 2>&1
if %errorlevel% neq 0 (
    echo 🔐 Please login to Supabase first:
    echo supabase login
    pause
    exit /b 1
)

echo ✅ Supabase authenticated

REM Deploy the function
echo.
echo 📤 Deploying process-notifications function...
supabase functions deploy process-notifications

if %errorlevel% equ 0 (
    echo.
    echo ✅ Edge Function deployed successfully!
    echo.
    echo 📋 Next Steps:
    echo 1. Test the function using the Flutter app
    echo 2. Check logs: supabase functions logs process-notifications
    echo 3. For production: Set FIREBASE_SERVICE_ACCOUNT secret
    echo.
) else (
    echo.
    echo ❌ Deployment failed!
    echo Check the error messages above.
    echo.
)

pause 