-- ========================================
-- DATABASE UPDATES FOR FUN CIRCLE APP
-- ========================================
-- Add these updates one by one to your Supabase database
-- Each update is marked with #1, #2, #3, etc.
-- Run them in order!
-- ========================================

-- #1: Add profile card fields to users table
-- These fields are needed for the profile menu card display
-- NOTE: age already exists as TEXT, location already exists
-- ========================================

-- Add city column (location exists but we want city specifically)
ALTER TABLE users
ADD COLUMN IF NOT EXISTS city TEXT;

-- Add general skill_level column
-- (skill_level_badminton and skill_level_pickleball already exist)
ALTER TABLE users
ADD COLUMN IF NOT EXISTS skill_level TEXT;

-- Add check constraint for skill_level
ALTER TABLE users
ADD CONSTRAINT users_skill_level_check CHECK (skill_level IN ('Beginner', 'Intermediate', 'Advanced', 'Professional'));

COMMENT ON COLUMN users.city IS 'User city/location for display on profile card';
COMMENT ON COLUMN users.skill_level IS 'General skill level: Beginner, Intermediate, Advanced, Professional';

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_users_city ON users(city) WHERE city IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_users_skill_level ON users(skill_level) WHERE skill_level IS NOT NULL;


-- #2: Create user_settings table
-- Stores user app preferences and settings
-- ========================================
CREATE TABLE IF NOT EXISTS user_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,

    -- Notification settings
    push_notifications BOOLEAN DEFAULT true,
    email_notifications BOOLEAN DEFAULT true,
    sms_notifications BOOLEAN DEFAULT false,

    -- Privacy settings
    profile_visibility TEXT DEFAULT 'public' CHECK (profile_visibility IN ('public', 'friends', 'private')),
    show_location BOOLEAN DEFAULT true,
    show_age BOOLEAN DEFAULT true,

    -- App preferences
    language TEXT DEFAULT 'en',
    theme TEXT DEFAULT 'light' CHECK (theme IN ('light', 'dark', 'system')),

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Ensure one settings record per user
    UNIQUE(user_id)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_settings_user_id ON user_settings(user_id);

-- Add RLS policies
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own settings"
ON user_settings FOR SELECT
USING (auth.uid()::TEXT = user_id::TEXT);

CREATE POLICY "Users can update own settings"
ON user_settings FOR UPDATE
USING (auth.uid()::TEXT = user_id::TEXT);

CREATE POLICY "Users can insert own settings"
ON user_settings FOR INSERT
WITH CHECK (auth.uid()::TEXT = user_id::TEXT);

COMMENT ON TABLE user_settings IS 'User app preferences and settings';


-- #3: Create support_tickets table
-- For help & support contact form submissions
-- ========================================
CREATE TABLE IF NOT EXISTS support_tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,

    -- Ticket details
    category TEXT NOT NULL CHECK (category IN ('Account', 'Booking', 'Payment', 'Technical', 'Other')),
    subject TEXT NOT NULL,
    description TEXT NOT NULL,
    status TEXT DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
    priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT description_not_empty CHECK (LENGTH(TRIM(description)) > 0),
    CONSTRAINT subject_not_empty CHECK (LENGTH(TRIM(subject)) > 0)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_support_tickets_user_id ON support_tickets(user_id);
CREATE INDEX IF NOT EXISTS idx_support_tickets_status ON support_tickets(status);
CREATE INDEX IF NOT EXISTS idx_support_tickets_created_at ON support_tickets(created_at DESC);

-- Add RLS policies
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own tickets"
ON support_tickets FOR SELECT
USING (auth.uid()::TEXT = user_id::TEXT);

CREATE POLICY "Users can create own tickets"
ON support_tickets FOR INSERT
WITH CHECK (auth.uid()::TEXT = user_id::TEXT);

COMMENT ON TABLE support_tickets IS 'User support and help tickets';


-- #4: Create app_policies table
-- Stores privacy policy, terms of service, community guidelines
-- ========================================
CREATE TABLE IF NOT EXISTS app_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Policy details
    policy_type TEXT NOT NULL CHECK (policy_type IN ('privacy', 'terms', 'community')),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    version TEXT NOT NULL,
    effective_date DATE NOT NULL,

    -- Status
    is_active BOOLEAN DEFAULT true,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Ensure only one active policy per type
    UNIQUE(policy_type, version)
);

-- Create index
CREATE INDEX IF NOT EXISTS idx_app_policies_type_active ON app_policies(policy_type, is_active);

-- Add RLS policy (public read access)
ALTER TABLE app_policies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active policies"
ON app_policies FOR SELECT
USING (is_active = true);

COMMENT ON TABLE app_policies IS 'App policies: privacy, terms, community guidelines';

-- Insert default policies
INSERT INTO app_policies (policy_type, title, content, version, effective_date, is_active)
VALUES
(
    'privacy',
    'Privacy Policy',
    'Your privacy is important to us. This privacy policy explains how Fun Circle collects, uses, and protects your personal information...',
    '1.0',
    CURRENT_DATE,
    true
),
(
    'terms',
    'Terms of Service',
    'By using Fun Circle, you agree to these terms of service...',
    '1.0',
    CURRENT_DATE,
    true
),
(
    'community',
    'Community Guidelines',
    'Fun Circle is a community for sports enthusiasts. Please follow these guidelines to ensure a positive experience for everyone...',
    '1.0',
    CURRENT_DATE,
    true
)
ON CONFLICT (policy_type, version) DO NOTHING;


-- #5: Add additional user fields (if not exists)
-- These are commonly used in profile displays
-- NOTE: bio already exists in users table
-- ========================================
ALTER TABLE users
ADD COLUMN IF NOT EXISTS display_name TEXT,
ADD COLUMN IF NOT EXISTS location_latitude DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS location_longitude DOUBLE PRECISION;

COMMENT ON COLUMN users.display_name IS 'User display name (can be different from first_name)';
COMMENT ON COLUMN users.location_latitude IS 'User location latitude for matching';
COMMENT ON COLUMN users.location_longitude IS 'User location longitude for matching';


-- #6: Create function to auto-update updated_at timestamp
-- This ensures updated_at is always current
-- ========================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to user_settings
DROP TRIGGER IF EXISTS update_user_settings_updated_at ON user_settings;
CREATE TRIGGER update_user_settings_updated_at
    BEFORE UPDATE ON user_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to support_tickets
DROP TRIGGER IF EXISTS update_support_tickets_updated_at ON support_tickets;
CREATE TRIGGER update_support_tickets_updated_at
    BEFORE UPDATE ON support_tickets
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to app_policies
DROP TRIGGER IF EXISTS update_app_policies_updated_at ON app_policies;
CREATE TRIGGER update_app_policies_updated_at
    BEFORE UPDATE ON app_policies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- #7: Create function to initialize user settings on user creation
-- Automatically creates settings record when user signs up
-- ========================================
CREATE OR REPLACE FUNCTION initialize_user_settings()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_settings (user_id)
    VALUES (NEW.user_id)
    ON CONFLICT (user_id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS create_user_settings_on_signup ON users;
CREATE TRIGGER create_user_settings_on_signup
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION initialize_user_settings();


-- #8: Add indexes for better query performance
-- These improve the speed of common queries
-- ========================================
CREATE INDEX IF NOT EXISTS idx_users_city ON users(city) WHERE city IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_users_skill_level ON users(skill_level) WHERE skill_level IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_users_age ON users(age) WHERE age IS NOT NULL;


-- #9: Create view for user profile summary
-- Combines user data with settings for easy querying
-- ========================================
CREATE OR REPLACE VIEW user_profile_summary AS
SELECT
    u.user_id,
    u.first_name,
    u.display_name,
    u.images,
    u.city,
    u.age,
    u.skill_level,
    u.bio,
    us.profile_visibility,
    us.show_location,
    us.show_age,
    u.created_at,
    u.updated_at
FROM users u
LEFT JOIN user_settings us ON u.user_id = us.user_id;

COMMENT ON VIEW user_profile_summary IS 'Combined user profile and settings for easy querying';


-- #10: Grant necessary permissions
-- Ensures authenticated users can access their data
-- ========================================
GRANT SELECT ON user_profile_summary TO authenticated;
GRANT SELECT, INSERT, UPDATE ON user_settings TO authenticated;
GRANT SELECT, INSERT ON support_tickets TO authenticated;
GRANT SELECT ON app_policies TO authenticated, anon;


-- ========================================
-- VERIFICATION QUERIES
-- ========================================
-- Run these to verify everything is set up correctly:

-- Check users table columns
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'users' AND column_name IN ('city', 'age', 'skill_level');

-- Check if tables exist
-- SELECT table_name FROM information_schema.tables WHERE table_name IN ('user_settings', 'support_tickets', 'app_policies');

-- Check policies
-- SELECT * FROM app_policies WHERE is_active = true;

-- Check user settings
-- SELECT * FROM user_settings LIMIT 5;


-- ========================================
-- ROLLBACK (if needed)
-- ========================================
-- ONLY RUN THESE IF YOU NEED TO UNDO CHANGES!

-- DROP VIEW IF EXISTS user_profile_summary;
-- DROP TRIGGER IF EXISTS create_user_settings_on_signup ON users;
-- DROP TRIGGER IF EXISTS update_user_settings_updated_at ON user_settings;
-- DROP TRIGGER IF EXISTS update_support_tickets_updated_at ON support_tickets;
-- DROP TRIGGER IF EXISTS update_app_policies_updated_at ON app_policies;
-- DROP FUNCTION IF EXISTS initialize_user_settings();
-- DROP FUNCTION IF EXISTS update_updated_at_column();
-- DROP TABLE IF EXISTS app_policies;
-- DROP TABLE IF EXISTS support_tickets;
-- DROP TABLE IF EXISTS user_settings;
-- ALTER TABLE users DROP COLUMN IF EXISTS city, DROP COLUMN IF EXISTS age, DROP COLUMN IF EXISTS skill_level, DROP COLUMN IF EXISTS display_name, DROP COLUMN IF EXISTS bio;
