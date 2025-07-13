-- SQL script to set up order notification trigger
-- This will call the OneSignal edge function when a new order is inserted

-- Create a function that will be called by the trigger
CREATE OR REPLACE FUNCTION notify_new_order()
RETURNS TRIGGER AS $$
BEGIN
  -- Call the edge function using pg_net extension
  -- Make sure pg_net extension is enabled in your Supabase project
  PERFORM
    net.http_post(
      url := 'https://your-project-ref.supabase.co/functions/v1/order-notifications',
      headers := '{"Content-Type": "application/json", "Authorization": "Bearer YOUR_ANON_KEY"}'::jsonb,
      body := jsonb_build_object(
        'record', to_jsonb(NEW),
        'event_type', 'INSERT',
        'table', 'orders',
        'timestamp', now()
      )
    );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on the orders table
DROP TRIGGER IF EXISTS orders_notification_trigger ON orders;

CREATE TRIGGER orders_notification_trigger
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_order();

-- Enable Row Level Security if not already enabled
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Create policy to allow the trigger function to access orders
CREATE POLICY "Allow trigger access to orders" ON orders
  FOR ALL TO postgres
  USING (true);

-- Grant necessary permissions
GRANT USAGE ON SCHEMA net TO postgres;
GRANT EXECUTE ON FUNCTION net.http_post TO postgres;