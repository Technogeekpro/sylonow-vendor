-- Add additional_address column to vendors table
ALTER TABLE vendors 
ADD COLUMN additional_address TEXT;

-- Add fcm_token column to vendors table (if it doesn't exist)
ALTER TABLE vendors 
ADD COLUMN IF NOT EXISTS fcm_token TEXT;

-- Add comments to the columns
COMMENT ON COLUMN vendors.additional_address IS 'Additional address details like landmark, building name, floor number';
COMMENT ON COLUMN vendors.fcm_token IS 'Firebase Cloud Messaging token for push notifications';