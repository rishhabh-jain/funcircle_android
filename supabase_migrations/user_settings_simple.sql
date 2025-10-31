-- Drop table if it exists and recreate
DROP TABLE IF EXISTS public.user_settings CASCADE;

-- Create user_settings table in public schema
CREATE TABLE public.user_settings (
  user_id text NOT NULL,
  push_notifications boolean DEFAULT true,
  email_notifications boolean DEFAULT true,
  game_request_notifications boolean DEFAULT true,
  booking_notifications boolean DEFAULT true,
  chat_notifications boolean DEFAULT true,
  friend_request_notifications boolean DEFAULT true,
  theme text DEFAULT 'system',
  language text DEFAULT 'en',
  profile_visible boolean DEFAULT true,
  show_online_status boolean DEFAULT true,
  show_location boolean DEFAULT true,
  allow_friend_requests boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_settings_pkey PRIMARY KEY (user_id),
  CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE
);

-- Create index
CREATE INDEX idx_user_settings_user_id ON public.user_settings(user_id);

-- Enable RLS
ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own settings"
  ON public.user_settings
  FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert their own settings"
  ON public.user_settings
  FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update their own settings"
  ON public.user_settings
  FOR UPDATE
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can delete their own settings"
  ON public.user_settings
  FOR DELETE
  USING (auth.uid()::text = user_id);
