-- Simple migration: Just add deleted_at column
-- Run this if you want minimal changes without RLS policy

-- Add deleted_at column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'users'
    AND column_name = 'deleted_at'
  ) THEN
    ALTER TABLE public.users ADD COLUMN deleted_at TIMESTAMPTZ NULL;
  END IF;
END $$;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_users_deleted_at ON public.users(deleted_at)
WHERE deleted_at IS NULL;

-- Verify the column was created
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'users'
  AND column_name = 'deleted_at';
