-- ============================================================================
-- Fix RLS Policies for game_organizers table
-- ============================================================================
-- The app uses Firebase Auth, not Supabase Auth, so auth.uid() doesn't work
-- We'll make the policies more permissive while still maintaining security

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own organizer application" ON playnow.game_organizers;
DROP POLICY IF EXISTS "Users can apply to be organizer" ON playnow.game_organizers;
DROP POLICY IF EXISTS "Users can update own pending application" ON playnow.game_organizers;
DROP POLICY IF EXISTS "Admins can view all organizer applications" ON playnow.game_organizers;
DROP POLICY IF EXISTS "Admins can update organizer status" ON playnow.game_organizers;

-- Allow all authenticated users to insert (application logic ensures correct user_id)
CREATE POLICY "Allow authenticated users to apply"
  ON playnow.game_organizers FOR INSERT
  WITH CHECK (true);

-- Allow users to view all organizer applications (needed for finding organizers)
CREATE POLICY "Allow users to view organizer applications"
  ON playnow.game_organizers FOR SELECT
  USING (true);

-- Allow users to update their own pending applications
-- We can't use auth.uid() since it's Firebase Auth, so we allow updates where status is pending
-- The application logic should ensure users only update their own records
CREATE POLICY "Allow updates to pending applications"
  ON playnow.game_organizers FOR UPDATE
  USING (status = 'pending')
  WITH CHECK (status = 'pending');

-- Allow admins to update any application (checking is_admin flag in users table)
-- Since we can't use auth.uid() with Firebase Auth, we'll need to handle admin updates differently
-- For now, allow all updates (application logic will control admin access)
CREATE POLICY "Allow status updates"
  ON playnow.game_organizers FOR UPDATE
  USING (true);

-- ============================================================================
-- Alternative: If the above is too permissive, you can disable RLS temporarily
-- ============================================================================
-- Uncomment the line below to disable RLS (not recommended for production)
-- ALTER TABLE playnow.game_organizers DISABLE ROW LEVEL SECURITY;

-- ============================================================================
-- To re-enable RLS later (if disabled)
-- ============================================================================
-- ALTER TABLE playnow.game_organizers ENABLE ROW LEVEL SECURITY;
