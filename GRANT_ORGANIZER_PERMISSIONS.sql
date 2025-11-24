-- ============================================================================
-- Grant Permissions for game_organizers table
-- ============================================================================
-- The anon/authenticated role needs explicit INSERT permissions

-- Grant all permissions to anon role (used by Supabase client)
GRANT ALL ON playnow.game_organizers TO anon;
GRANT ALL ON playnow.game_organizers TO authenticated;
GRANT ALL ON playnow.organizer_activity_log TO anon;
GRANT ALL ON playnow.organizer_activity_log TO authenticated;

-- Grant usage on schema
GRANT USAGE ON SCHEMA playnow TO anon;
GRANT USAGE ON SCHEMA playnow TO authenticated;

-- Verify RLS is disabled
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'playnow'
AND tablename IN ('game_organizers', 'organizer_activity_log');

-- Verify permissions
SELECT
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'playnow'
AND table_name = 'game_organizers'
AND grantee IN ('anon', 'authenticated');
