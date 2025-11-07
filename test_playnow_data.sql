-- Test data for PlayNow module
-- This script creates test games and participants for testing join/after-game features

-- IMPORTANT: Replace 'YOUR_USER_ID_HERE' with your actual user_id from the users table
-- You can find your user_id by running: SELECT user_id FROM public.users WHERE email = 'your_email@example.com';

-- Variables (replace these with actual values from your database)
-- YOUR_USER_ID: Your user ID from public.users table
-- VENUE_ID: A venue ID from public.venues table (optional, can be NULL)

-- =====================================================
-- 1. OPEN GAMES (for testing join/request functionality)
-- =====================================================

-- Open game with auto join (Badminton)
INSERT INTO playnow.games (
  created_by,
  sport_type,
  game_date,
  start_time,
  venue_id,
  players_needed,
  game_type,
  skill_level,
  cost_per_player,
  is_free,
  join_type,
  is_venue_booked,
  is_women_only,
  is_mixed_only,
  description,
  status,
  current_players_count
) VALUES (
  'YOUR_USER_ID_HERE',  -- Replace with actual user_id
  'badminton',
  CURRENT_DATE + INTERVAL '2 days',  -- 2 days from now
  '18:00',
  NULL,  -- No venue (or replace with actual venue_id)
  4,
  'doubles',
  3,
  50.00,
  false,
  'auto',
  false,
  false,
  false,
  'Looking for 3 more players for a fun doubles game!',
  'open',
  1
) RETURNING id;

-- Open game with request to join (Pickleball)
INSERT INTO playnow.games (
  created_by,
  sport_type,
  game_date,
  start_time,
  venue_id,
  players_needed,
  game_type,
  skill_level,
  cost_per_player,
  is_free,
  join_type,
  is_venue_booked,
  is_women_only,
  is_mixed_only,
  description,
  status,
  current_players_count
) VALUES (
  'YOUR_USER_ID_HERE',  -- Replace with actual user_id
  'pickleball',
  CURRENT_DATE + INTERVAL '1 day',  -- Tomorrow
  '10:00',
  NULL,
  4,
  'doubles',
  4,
  0.00,
  true,
  'request',  -- Requires approval to join
  true,
  false,
  false,
  'Advanced level pickleball. Request to join if interested!',
  'open',
  1
) RETURNING id;

-- Open game - Free, Level 2 (Badminton)
INSERT INTO playnow.games (
  created_by,
  sport_type,
  game_date,
  start_time,
  venue_id,
  players_needed,
  game_type,
  skill_level,
  cost_per_player,
  is_free,
  join_type,
  is_venue_booked,
  is_women_only,
  is_mixed_only,
  description,
  status,
  current_players_count
) VALUES (
  'YOUR_USER_ID_HERE',  -- Replace with actual user_id
  'badminton',
  CURRENT_DATE + INTERVAL '3 days',
  '16:00',
  NULL,
  2,
  'singles',
  2,
  0.00,
  true,
  'auto',
  false,
  false,
  false,
  'Casual singles match for beginners',
  'open',
  1
) RETURNING id;

-- =====================================================
-- 2. COMPLETED GAMES (for testing after-game features)
-- =====================================================

-- Note: For the completed games, we'll create games where YOU are a participant
-- so you can test the after-game features (Record Scores, Rate Players, etc.)

-- Completed game #1 - Badminton Doubles
WITH new_game AS (
  INSERT INTO playnow.games (
    created_by,
    sport_type,
    game_date,
    start_time,
    venue_id,
    players_needed,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    is_venue_booked,
    is_women_only,
    is_mixed_only,
    description,
    status,
    current_players_count
  ) VALUES (
    'YOUR_USER_ID_HERE',  -- You are the creator
    'badminton',
    CURRENT_DATE - INTERVAL '1 day',  -- Yesterday
    '18:00',
    NULL,
    4,
    'doubles',
    3,
    50.00,
    false,
    'auto',
    true,
    false,
    false,
    'Great doubles match completed!',
    'completed',
    4
  ) RETURNING id
)
INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
SELECT
  id,
  'YOUR_USER_ID_HERE',  -- You as the creator
  'creator',
  NOW() - INTERVAL '2 days'
FROM new_game;

-- Completed game #2 - Pickleball Singles
WITH new_game AS (
  INSERT INTO playnow.games (
    created_by,
    sport_type,
    game_date,
    start_time,
    venue_id,
    players_needed,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    is_venue_booked,
    is_women_only,
    is_mixed_only,
    description,
    status,
    current_players_count
  ) VALUES (
    'YOUR_USER_ID_HERE',  -- You are the creator
    'pickleball',
    CURRENT_DATE - INTERVAL '2 days',  -- 2 days ago
    '10:00',
    NULL,
    2,
    'singles',
    4,
    0.00,
    true,
    'auto',
    false,
    false,
    false,
    'Intense singles match - Level 4',
    'completed',
    2
  ) RETURNING id
)
INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
SELECT
  id,
  'YOUR_USER_ID_HERE',  -- You as the creator
  'creator',
  NOW() - INTERVAL '3 days'
FROM new_game;

-- =====================================================
-- 3. FULL GAME (to test "Game Full" status)
-- =====================================================

WITH new_game AS (
  INSERT INTO playnow.games (
    created_by,
    sport_type,
    game_date,
    start_time,
    venue_id,
    players_needed,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    is_venue_booked,
    is_women_only,
    is_mixed_only,
    description,
    status,
    current_players_count
  ) VALUES (
    'YOUR_USER_ID_HERE',  -- Replace with actual user_id
    'badminton',
    CURRENT_DATE + INTERVAL '4 days',
    '19:00',
    NULL,
    4,
    'doubles',
    3,
    75.00,
    false,
    'auto',
    true,
    false,
    false,
    'This game is full - no more slots available',
    'full',
    4
  ) RETURNING id
)
INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
SELECT
  id,
  'YOUR_USER_ID_HERE',  -- You as the creator
  'creator',
  NOW() - INTERVAL '1 day'
FROM new_game;

-- =====================================================
-- INSTRUCTIONS FOR USE
-- =====================================================

/*
HOW TO USE THIS SCRIPT:

1. Find your user_id:
   Run this query in Supabase SQL Editor:
   SELECT user_id, email, first_name FROM public.users WHERE email = 'your_email@example.com';

2. Replace 'YOUR_USER_ID_HERE' in this script with your actual user_id
   - Use Find & Replace to replace all instances

3. (Optional) If you want to use actual venues:
   - Get a venue_id: SELECT id, venue_name FROM public.venues LIMIT 5;
   - Replace NULL in venue_id fields with actual venue IDs

4. Run this script in Supabase SQL Editor

5. After running, you should see:
   - 3 OPEN games you can join/request to join
   - 2 COMPLETED games where you can test after-game features
   - 1 FULL game to see the full status

6. To test after-game features with multiple players:
   - You'll need to add more participants to the completed games
   - See the "Adding More Participants" section below
*/

-- =====================================================
-- OPTIONAL: Adding More Participants to Completed Games
-- =====================================================

/*
To fully test after-game features (rating, tagging, adding play pals),
you need multiple participants in completed games.

If you have other test users in your database, you can add them like this:

-- Get a completed game ID
-- SELECT id FROM playnow.games WHERE status = 'completed' AND created_by = 'YOUR_USER_ID_HERE' LIMIT 1;

-- Add participants (replace GAME_ID and OTHER_USER_IDs)
INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
VALUES
  ('COMPLETED_GAME_ID', 'OTHER_USER_ID_1', 'auto_join', NOW() - INTERVAL '2 days'),
  ('COMPLETED_GAME_ID', 'OTHER_USER_ID_2', 'auto_join', NOW() - INTERVAL '2 days'),
  ('COMPLETED_GAME_ID', 'OTHER_USER_ID_3', 'auto_join', NOW() - INTERVAL '2 days');

-- Update player count
UPDATE playnow.games
SET current_players_count = 4
WHERE id = 'COMPLETED_GAME_ID';
*/

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check all games created
-- SELECT id, sport_type, game_type, status, current_players_count, game_date
-- FROM playnow.games
-- WHERE created_by = 'YOUR_USER_ID_HERE'
-- ORDER BY created_at DESC;

-- Check participants
-- SELECT gp.game_id, g.sport_type, g.status, gp.user_id, gp.join_type
-- FROM playnow.game_participants gp
-- JOIN playnow.games g ON g.id = gp.game_id
-- WHERE g.created_by = 'YOUR_USER_ID_HERE';
