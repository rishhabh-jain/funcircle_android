-- Add deleted_at column to users table for soft delete functionality
-- This migration is idempotent (safe to run multiple times)

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
    COMMENT ON COLUMN public.users.deleted_at IS 'Timestamp when user account was marked as deleted (soft delete)';
  END IF;
END $$;

-- Create index for querying active users (where deleted_at is null)
CREATE INDEX IF NOT EXISTS idx_users_deleted_at ON public.users(deleted_at)
WHERE deleted_at IS NULL;

-- Add helper function to check if user is active
CREATE OR REPLACE FUNCTION public.is_user_active(user_id_param TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.users
    WHERE user_id = user_id_param
    AND deleted_at IS NULL
  );
END;
$$;

COMMENT ON FUNCTION public.is_user_active IS 'Check if a user account is active (not soft deleted)';

-- Add RLS policy to hide deleted users from normal queries
-- This ensures deleted users don't show up in search results, game lists, etc.
-- First, drop the policy if it exists, then create it
DROP POLICY IF EXISTS "Hide deleted users from queries" ON public.users;

CREATE POLICY "Hide deleted users from queries"
ON public.users
FOR SELECT
TO authenticated
USING (deleted_at IS NULL);

-- Note: Admins may need a separate policy to view deleted users for recovery purposes
-- This can be added later if needed

-- Verification query
SELECT
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'users'
  AND column_name = 'deleted_at';

COMMENT ON TABLE public.users IS 'User accounts table with soft delete support via deleted_at column';
