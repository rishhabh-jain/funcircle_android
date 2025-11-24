-- ============================================================================
-- Disable RLS for game_organizers table (RECOMMENDED FIX)
-- ============================================================================
-- Since the app uses Firebase Auth (not Supabase Auth), RLS policies that check
-- auth.uid() will always fail. We'll disable RLS for this table and rely on
-- application-level security instead.

-- Disable RLS on game_organizers table
ALTER TABLE playnow.game_organizers DISABLE ROW LEVEL SECURITY;

-- Also disable RLS on organizer_activity_log if needed
ALTER TABLE playnow.organizer_activity_log DISABLE ROW LEVEL SECURITY;

-- Verify RLS is disabled
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'playnow'
AND tablename IN ('game_organizers', 'organizer_activity_log');

-- Expected output should show rowsecurity = false for both tables
