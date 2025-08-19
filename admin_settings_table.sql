-- Create admin_settings table for storing app configuration
CREATE TABLE IF NOT EXISTS admin_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    support_email VARCHAR(255) DEFAULT 'support@sylonow.com',
    support_phone VARCHAR(50) DEFAULT '+91 98765 43210',
    app_version VARCHAR(20) DEFAULT '1.0.0',
    maintenance_mode BOOLEAN DEFAULT false,
    maintenance_message TEXT,
    force_update BOOLEAN DEFAULT false,
    min_app_version VARCHAR(20) DEFAULT '1.0.0',
    privacy_policy_url TEXT,
    terms_of_service_url TEXT,
    help_center_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default admin settings
INSERT INTO admin_settings (
    support_email,
    support_phone,
    app_version,
    maintenance_mode,
    force_update
) VALUES (
    'support@sylonow.com',
    '+91 98765 43210',
    '1.0.0',
    false,
    false
) ON CONFLICT DO NOTHING;

-- Enable Row Level Security
ALTER TABLE admin_settings ENABLE ROW LEVEL SECURITY;

-- Create policies for admin settings (allow all authenticated users to read)
CREATE POLICY "Allow authenticated users to read admin settings"
ON admin_settings FOR SELECT
TO authenticated
USING (true);

-- Create policy for admin users to manage settings (you can restrict this later)
CREATE POLICY "Allow authenticated users to manage admin settings"
ON admin_settings FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- Add updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_admin_settings_updated_at 
    BEFORE UPDATE ON admin_settings 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();