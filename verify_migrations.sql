-- Verify both migrations completed successfully
-- Run this in Supabase SQL Editor to check

-- 1. Check if is_official column exists on games table
SELECT
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'playnow'
  AND table_name = 'games'
  AND column_name = 'is_official';
-- Should return 1 row: is_official | boolean | NO | false

-- 2. Check if payment_id column exists on game_participants table
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'playnow'
  AND table_name = 'game_participants'
  AND column_name = 'payment_id';
-- Should return 1 row: payment_id | text | YES

-- 3. Check if indexes were created
SELECT
  schemaname,
  tablename,
  indexname
FROM pg_indexes
WHERE schemaname = 'playnow'
  AND indexname IN ('idx_games_is_official', 'idx_game_participants_payment_id');
-- Should return 2 rows

-- 4. Check RLS policies on games table
SELECT
  policyname,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'playnow'
  AND tablename = 'games'
  AND policyname LIKE '%admin%official%';
-- Should return 2 policies

-- 5. Quick check: Show current games with is_official status
SELECT
  id,
  sport_type,
  game_date,
  start_time,
  is_official,
  cost_per_player,
  is_free
FROM playnow.games
ORDER BY created_at DESC
LIMIT 5;
-- Should show recent games with is_official = false (unless you've marked some as official)
