-- Add is_official field to playnow.games table
-- This field marks games organized by Fun Circle officially

-- Add column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'playnow'
    AND table_name = 'games'
    AND column_name = 'is_official'
  ) THEN
    ALTER TABLE playnow.games
    ADD COLUMN is_official BOOLEAN NOT NULL DEFAULT false;
  END IF;
END $$;

-- Create index if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE schemaname = 'playnow'
    AND tablename = 'games'
    AND indexname = 'idx_games_is_official'
  ) THEN
    CREATE INDEX idx_games_is_official ON playnow.games(is_official) WHERE is_official = true;
  END IF;
END $$;

-- Add comment
COMMENT ON COLUMN playnow.games.is_official IS 'Marks games officially organized by Fun Circle';

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Only admins can insert official games" ON playnow.games;
DROP POLICY IF EXISTS "Only admins can update to official" ON playnow.games;

-- RLS Policy: Only admins can set is_official to true when inserting
CREATE POLICY "Only admins can insert official games" ON playnow.games
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  is_official = false OR
  EXISTS (
    SELECT 1 FROM public.users
    WHERE user_id = auth.uid()::text
    AND (adminsetlevel = 'admin' OR adminsetlevel = 'super_admin')
  )
);

-- RLS Policy: Only admins can update is_official to true
CREATE POLICY "Only admins can update to official" ON playnow.games
AS RESTRICTIVE
FOR UPDATE
TO authenticated
WITH CHECK (
  is_official = false OR
  EXISTS (
    SELECT 1 FROM public.users
    WHERE user_id = auth.uid()::text
    AND (adminsetlevel = 'admin' OR adminsetlevel = 'super_admin')
  )
);
