-- Simplified Test Data Script for PlayNow Module
-- This version automatically uses the currently authenticated user
-- Just run this entire script in Supabase SQL Editor

-- NOTE: Make sure you're logged in to Supabase with the account you want to use for testing
-- The script will use auth.uid() to get your user_id automatically

-- =====================================================
-- 1. OPEN GAMES (can join/request)
-- =====================================================

-- Game 1: Badminton Doubles - Auto Join
INSERT INTO playnow.games (
  created_by,
  sport_type,
  game_date,
  start_time,
  players_needed,
  game_type,
  skill_level,
  cost_per_player,
  is_free,
  join_type,
  description,
  status,
  current_players_count
) VALUES (
  (SELECT user_id FROM public.users WHERE user_id = auth.uid()::text LIMIT 1),
  'badminton',
  CURRENT_DATE + INTERVAL '2 days',
  '18:00',
  4,
  'doubles',
  3,
  50.00,
  false,
  'auto',
  'Looking for 3 more players for a fun doubles game!',
  'open',
  1
);

-- Game 2: Pickleball Doubles - Request to Join
INSERT INTO playnow.games (
  created_by,
  sport_type,
  game_date,
  start_time,
  players_needed,
  game_type,
  skill_level,
  cost_per_player,
  is_free,
  join_type,
  description,
  status,
  current_players_count
) VALUES (
  (SELECT user_id FROM public.users WHERE user_id = auth.uid()::text LIMIT 1),
  'pickleball',
  CURRENT_DATE + INTERVAL '1 day',
  '10:00',
  4,
  'doubles',
  4,
  0.00,
  true,
  'request',
  'Advanced pickleball - Request to join!',
  'open',
  1
);

-- Game 3: Badminton Singles - Free, Beginner
INSERT INTO playnow.games (
  created_by,
  sport_type,
  game_date,
  start_time,
  players_needed,
  game_type,
  skill_level,
  cost_per_player,
  is_free,
  join_type,
  description,
  status,
  current_players_count
) VALUES (
  (SELECT user_id FROM public.users WHERE user_id = auth.uid()::text LIMIT 1),
  'badminton',
  CURRENT_DATE + INTERVAL '3 days',
  '16:00',
  2,
  'singles',
  2,
  0.00,
  true,
  'auto',
  'Casual singles match for beginners',
  'open',
  1
);

-- =====================================================
-- 2. COMPLETED GAMES (for after-game features)
-- =====================================================

-- Completed Game 1: Badminton Doubles with 4 players
DO $$
DECLARE
  v_game_id UUID;
  v_user_id TEXT;
  v_other_users TEXT[];
  v_user TEXT;
BEGIN
  -- Get current user
  SELECT user_id INTO v_user_id
  FROM public.users
  WHERE user_id = auth.uid()::text
  LIMIT 1;

  -- Get 3 other users for the game (if available)
  SELECT ARRAY_AGG(user_id) INTO v_other_users
  FROM (
    SELECT user_id
    FROM public.users
    WHERE user_id != v_user_id
    LIMIT 3
  ) sub;

  -- Create completed game
  INSERT INTO playnow.games (
    created_by,
    sport_type,
    game_date,
    start_time,
    players_needed,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    description,
    status,
    current_players_count
  ) VALUES (
    v_user_id,
    'badminton',
    CURRENT_DATE - INTERVAL '1 day',
    '18:00',
    4,
    'doubles',
    3,
    50.00,
    false,
    'auto',
    'Great doubles match - completed!',
    'completed',
    CASE WHEN v_other_users IS NOT NULL THEN array_length(v_other_users, 1) + 1 ELSE 1 END
  ) RETURNING id INTO v_game_id;

  -- Add you as creator/participant
  INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
  VALUES (v_game_id, v_user_id, 'creator', NOW() - INTERVAL '2 days');

  -- Add other players if available
  IF v_other_users IS NOT NULL THEN
    FOREACH v_user IN ARRAY v_other_users
    LOOP
      INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
      VALUES (v_game_id, v_user, 'auto_join', NOW() - INTERVAL '2 days');
    END LOOP;
  END IF;

  RAISE NOTICE 'Created completed badminton game with % players',
    CASE WHEN v_other_users IS NOT NULL THEN array_length(v_other_users, 1) + 1 ELSE 1 END;
END $$;

-- Completed Game 2: Pickleball Singles with 2 players
DO $$
DECLARE
  v_game_id UUID;
  v_user_id TEXT;
  v_other_user TEXT;
BEGIN
  -- Get current user
  SELECT user_id INTO v_user_id
  FROM public.users
  WHERE user_id = auth.uid()::text
  LIMIT 1;

  -- Get 1 other user for singles match
  SELECT user_id INTO v_other_user
  FROM public.users
  WHERE user_id != v_user_id
  LIMIT 1;

  -- Create completed game
  INSERT INTO playnow.games (
    created_by,
    sport_type,
    game_date,
    start_time,
    players_needed,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    description,
    status,
    current_players_count
  ) VALUES (
    v_user_id,
    'pickleball',
    CURRENT_DATE - INTERVAL '2 days',
    '10:00',
    2,
    'singles',
    4,
    0.00,
    true,
    'auto',
    'Intense singles match - Level 4',
    'completed',
    CASE WHEN v_other_user IS NOT NULL THEN 2 ELSE 1 END
  ) RETURNING id INTO v_game_id;

  -- Add you as creator/participant
  INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
  VALUES (v_game_id, v_user_id, 'creator', NOW() - INTERVAL '3 days');

  -- Add other player if available
  IF v_other_user IS NOT NULL THEN
    INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
    VALUES (v_game_id, v_other_user, 'auto_join', NOW() - INTERVAL '3 days');
  END IF;

  RAISE NOTICE 'Created completed pickleball game with % players',
    CASE WHEN v_other_user IS NOT NULL THEN 2 ELSE 1 END;
END $$;

-- =====================================================
-- 3. FULL GAME (to test full status)
-- =====================================================

DO $$
DECLARE
  v_game_id UUID;
  v_user_id TEXT;
BEGIN
  -- Get current user
  SELECT user_id INTO v_user_id
  FROM public.users
  WHERE user_id = auth.uid()::text
  LIMIT 1;

  -- Create full game
  INSERT INTO playnow.games (
    created_by,
    sport_type,
    game_date,
    start_time,
    players_needed,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    description,
    status,
    current_players_count
  ) VALUES (
    v_user_id,
    'badminton',
    CURRENT_DATE + INTERVAL '4 days',
    '19:00',
    4,
    'doubles',
    3,
    75.00,
    false,
    'auto',
    'This game is full - no slots available',
    'full',
    4
  ) RETURNING id INTO v_game_id;

  -- Add you as creator/participant
  INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
  VALUES (v_game_id, v_user_id, 'creator', NOW() - INTERVAL '1 day');

  RAISE NOTICE 'Created full game';
END $$;

-- =====================================================
-- VERIFICATION
-- =====================================================

-- Show what was created
SELECT
  'Summary' as info,
  COUNT(*) FILTER (WHERE status = 'open') as open_games,
  COUNT(*) FILTER (WHERE status = 'completed') as completed_games,
  COUNT(*) FILTER (WHERE status = 'full') as full_games
FROM playnow.games
WHERE created_by = (SELECT user_id FROM public.users WHERE user_id = auth.uid()::text);

-- Show all your games
SELECT
  id,
  sport_type,
  game_type,
  status,
  current_players_count || '/' || players_needed as players,
  game_date,
  start_time,
  is_free,
  cost_per_player
FROM playnow.games
WHERE created_by = (SELECT user_id FROM public.users WHERE user_id = auth.uid()::text)
ORDER BY created_at DESC;
