-- Fix RLS policy issue on game_participants table
-- The error occurs because an RLS policy is trying to access game_date from NEW record
-- Run this in Supabase SQL Editor

-- Step 1: Check current RLS policies
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'playnow'
  AND tablename = 'game_participants';

-- Step 2: Disable problematic RLS temporarily to test
-- (This allows the insert to work)
ALTER TABLE playnow.game_participants DISABLE ROW LEVEL SECURITY;

-- Step 3: After testing, re-enable RLS
-- ALTER TABLE playnow.game_participants ENABLE ROW LEVEL SECURITY;

-- Step 4: If RLS was the issue, we need to fix the policy
-- The policy should JOIN with games table properly, not reference NEW.game_date directly
-- Example of a correct policy:
/*
CREATE POLICY "Users can join games" ON playnow.game_participants
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM playnow.games g
    WHERE g.id = game_id  -- Use game_id from the INSERT, not NEW.game_date
    AND g.status = 'open'
    AND g.current_players_count < g.players_needed
  )
);
*/
