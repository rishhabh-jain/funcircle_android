-- Check RLS status for all playnow tables
SELECT
  schemaname,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'playnow'
ORDER BY tablename;

-- This will show which tables have RLS enabled
-- If other tables like game_participants, games, etc. have rls_enabled = false,
-- then we should also disable it for game_organizers
