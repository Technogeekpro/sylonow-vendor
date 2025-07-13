@echo off
echo Deploying OneSignal Order Notifications Edge Function...

echo.
echo Deploying to Supabase...
supabase functions deploy order-notifications

echo.
echo Deployment completed!
echo.
echo Next steps:
echo 1. Go to your Supabase Dashboard
echo 2. Navigate to Database ^> SQL Editor
echo 3. Run the SQL script in order_notification_trigger.sql
echo 4. Update the URL in the trigger to match your project
echo 5. Test by inserting a new order
echo.
pause