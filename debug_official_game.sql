-- Debug query to check your official game setup
-- Run this in Supabase SQL Editor

-- Check if the game exists and is properly configured
SELECT
  id,
  created_by,
  sport_type,
  game_date,
  start_time,
  players_needed,
  current_players_count,
  status,
  is_free,
  cost_per_player,
  is_official,
  join_type,
  CASE
    WHEN current_players_count >= players_needed THEN 'FULL'
    ELSE 'HAS SLOTS'
  END as availability
FROM playnow.games
WHERE is_official = true
ORDER BY created_at DESC
LIMIT 5;

-- Expected values for the button to show:
-- is_official: true ✓
-- status: 'open' ✓
-- current_players_count < players_needed ✓
-- cost_per_player: should have a value (e.g., 100)
-- is_free: false for paid games

-- If you don't see any games, create one:
-- (See the comment below for INSERT query)
