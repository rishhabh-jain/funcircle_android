-- EASIEST Test Data Script for PlayNow Module
-- Step 1: Find your user_id first, then use it below

-- =====================================================
-- STEP 1: RUN THIS FIRST TO FIND YOUR USER ID
-- =====================================================
-- Copy the result and use it in STEP 2

SELECT user_id, email, first_name
FROM public.users
LIMIT 10;

-- Copy your user_id from the results above
-- =====================================================

-- =====================================================
-- STEP 2: SET YOUR USER ID HERE
-- =====================================================

-- Replace this with your user_id from Step 1
DO $$
DECLARE
  my_user_id TEXT := 'PASTE_YOUR_USER_ID_HERE';  -- <-- CHANGE THIS!
  v_game_id UUID;
  v_other_users TEXT[] := ARRAY[]::TEXT[];
  v_user TEXT;
BEGIN
  -- Verify user exists
  IF NOT EXISTS (SELECT 1 FROM public.users WHERE user_id = my_user_id) THEN
    RAISE EXCEPTION 'User ID % not found. Please update my_user_id variable.', my_user_id;
  END IF;

  RAISE NOTICE 'Creating test games for user: %', my_user_id;

  -- Get some other users for multiplayer games
  SELECT ARRAY_AGG(user_id) INTO v_other_users
  FROM (
    SELECT user_id
    FROM public.users
    WHERE user_id != my_user_id
    LIMIT 3
  ) sub;

  -- =====================================================
  -- 1. OPEN GAMES
  -- =====================================================

  -- Open Game 1: Badminton Doubles - Auto Join
  INSERT INTO playnow.games (
    created_by, sport_type, game_date, start_time,
    players_needed, game_type, skill_level,
    cost_per_player, is_free, join_type,
    description, status, current_players_count
  ) VALUES (
    my_user_id, 'badminton', CURRENT_DATE + 2, '18:00',
    4, 'doubles', 3,
    50.00, false, 'auto',
    'Looking for 3 more players for a fun doubles game!', 'open', 1
  );
  RAISE NOTICE '✓ Created open badminton game (auto join)';

  -- Open Game 2: Pickleball Doubles - Request to Join
  INSERT INTO playnow.games (
    created_by, sport_type, game_date, start_time,
    players_needed, game_type, skill_level,
    cost_per_player, is_free, join_type,
    description, status, current_players_count
  ) VALUES (
    my_user_id, 'pickleball', CURRENT_DATE + 1, '10:00',
    4, 'doubles', 4,
    0.00, true, 'request',
    'Advanced pickleball - Request to join!', 'open', 1
  );
  RAISE NOTICE '✓ Created open pickleball game (request join)';

  -- Open Game 3: Badminton Singles - Free
  INSERT INTO playnow.games (
    created_by, sport_type, game_date, start_time,
    players_needed, game_type, skill_level,
    cost_per_player, is_free, join_type,
    description, status, current_players_count
  ) VALUES (
    my_user_id, 'badminton', CURRENT_DATE + 3, '16:00',
    2, 'singles', 2,
    0.00, true, 'auto',
    'Casual singles match for beginners', 'open', 1
  );
  RAISE NOTICE '✓ Created open badminton singles game';

  -- =====================================================
  -- 2. COMPLETED GAMES
  -- =====================================================

  -- Completed Game 1: Badminton Doubles with multiple players
  INSERT INTO playnow.games (
    created_by, sport_type, game_date, start_time,
    players_needed, game_type, skill_level,
    cost_per_player, is_free, join_type,
    description, status, current_players_count
  ) VALUES (
    my_user_id, 'badminton', CURRENT_DATE - 1, '18:00',
    4, 'doubles', 3,
    50.00, false, 'auto',
    'Great doubles match - completed!', 'completed',
    CASE WHEN array_length(v_other_users, 1) >= 3 THEN 4 ELSE array_length(v_other_users, 1) + 1 END
  ) RETURNING id INTO v_game_id;

  -- Add you as participant
  INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
  VALUES (v_game_id, my_user_id, 'creator', NOW() - INTERVAL '2 days');

  -- Add other players if available
  IF array_length(v_other_users, 1) >= 1 THEN
    FOR i IN 1..LEAST(3, array_length(v_other_users, 1)) LOOP
      INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
      VALUES (v_game_id, v_other_users[i], 'auto_join', NOW() - INTERVAL '2 days');
    END LOOP;
  END IF;
  RAISE NOTICE '✓ Created completed badminton game with % players',
    CASE WHEN array_length(v_other_users, 1) >= 3 THEN 4 ELSE COALESCE(array_length(v_other_users, 1), 0) + 1 END;

  -- Completed Game 2: Pickleball Singles
  INSERT INTO playnow.games (
    created_by, sport_type, game_date, start_time,
    players_needed, game_type, skill_level,
    cost_per_player, is_free, join_type,
    description, status, current_players_count
  ) VALUES (
    my_user_id, 'pickleball', CURRENT_DATE - 2, '10:00',
    2, 'singles', 4,
    0.00, true, 'auto',
    'Intense singles match - Level 4', 'completed',
    CASE WHEN array_length(v_other_users, 1) >= 1 THEN 2 ELSE 1 END
  ) RETURNING id INTO v_game_id;

  -- Add you as participant
  INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
  VALUES (v_game_id, my_user_id, 'creator', NOW() - INTERVAL '3 days');

  -- Add 1 other player if available
  IF array_length(v_other_users, 1) >= 1 THEN
    INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
    VALUES (v_game_id, v_other_users[1], 'auto_join', NOW() - INTERVAL '3 days');
  END IF;
  RAISE NOTICE '✓ Created completed pickleball game with % players',
    CASE WHEN array_length(v_other_users, 1) >= 1 THEN 2 ELSE 1 END;

  -- =====================================================
  -- 3. FULL GAME
  -- =====================================================

  INSERT INTO playnow.games (
    created_by, sport_type, game_date, start_time,
    players_needed, game_type, skill_level,
    cost_per_player, is_free, join_type,
    description, status, current_players_count
  ) VALUES (
    my_user_id, 'badminton', CURRENT_DATE + 4, '19:00',
    4, 'doubles', 3,
    75.00, false, 'auto',
    'This game is full - no slots available', 'full', 4
  ) RETURNING id INTO v_game_id;

  INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
  VALUES (v_game_id, my_user_id, 'creator', NOW() - INTERVAL '1 day');
  RAISE NOTICE '✓ Created full game';

  RAISE NOTICE '════════════════════════════════════════';
  RAISE NOTICE '✅ All test games created successfully!';
  RAISE NOTICE '════════════════════════════════════════';

END $$;

-- =====================================================
-- VERIFICATION - View your games
-- =====================================================

SELECT
  id,
  sport_type,
  game_type,
  status,
  current_players_count || '/' || players_needed as players,
  game_date::date as date,
  start_time,
  CASE WHEN is_free THEN 'Free' ELSE '₹' || cost_per_player::text END as cost,
  join_type
FROM playnow.games
WHERE created_by = 'PASTE_YOUR_USER_ID_HERE'  -- <-- CHANGE THIS TOO!
ORDER BY
  CASE status
    WHEN 'open' THEN 1
    WHEN 'completed' THEN 2
    WHEN 'full' THEN 3
    ELSE 4
  END,
  game_date;
