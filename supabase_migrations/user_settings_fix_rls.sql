-- Drop existing policies
DROP POLICY IF EXISTS "Users can view their own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can insert their own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can update their own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Users can delete their own settings" ON public.user_settings;

-- Disable RLS since the app uses Firebase Auth (not Supabase Auth)
-- Application-level security is handled by Firebase
ALTER TABLE public.user_settings DISABLE ROW LEVEL SECURITY;
