-- Create user_settings table in public schema
CREATE TABLE IF NOT EXISTS public.user_settings (
  user_id text NOT NULL,

  -- Notification settings
  push_notifications boolean DEFAULT true,
  email_notifications boolean DEFAULT true,
  game_request_notifications boolean DEFAULT true,
  booking_notifications boolean DEFAULT true,
  chat_notifications boolean DEFAULT true,
  friend_request_notifications boolean DEFAULT true,

  -- Appearance settings
  theme text DEFAULT 'system' CHECK (theme IN ('light', 'dark', 'system')),
  language text DEFAULT 'en',

  -- Privacy settings
  profile_visible boolean DEFAULT true,
  show_online_status boolean DEFAULT true,
  show_location boolean DEFAULT true,
  allow_friend_requests boolean DEFAULT true,

  -- Timestamps
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),

  CONSTRAINT user_settings_pkey PRIMARY KEY (user_id),
  CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE
);

-- Create index on user_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_settings_user_id ON public.user_settings(user_id);

-- Create a trigger to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_user_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_user_settings_updated_at
  BEFORE UPDATE ON public.user_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_user_settings_updated_at();

-- Grant permissions (adjust as needed for your RLS policies)
ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can insert their own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can update their own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can delete their own settings" ON public.user_settings;

-- Allow users to read their own settings
CREATE POLICY "Users can view their own settings"
  ON public.user_settings
  FOR SELECT
  USING (auth.uid()::text = user_id);

-- Allow users to insert their own settings
CREATE POLICY "Users can insert their own settings"
  ON public.user_settings
  FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

-- Allow users to update their own settings
CREATE POLICY "Users can update their own settings"
  ON public.user_settings
  FOR UPDATE
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

-- Allow users to delete their own settings
CREATE POLICY "Users can delete their own settings"
  ON public.user_settings
  FOR DELETE
  USING (auth.uid()::text = user_id);
