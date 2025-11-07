-- Ready-to-Run Test Data for PlayNow Module
-- User: GhO4QtVW4Dh7MrjfRmiqJI0gZQv2
-- Just copy this entire file and run it in Supabase SQL Editor!

DO $$
DECLARE
  my_user_id TEXT := 'GhO4QtVW4Dh7MrjfRmiqJI0gZQv2';
  v_game_id UUID;
  v_other_users TEXT[] := ARRAY[]::TEXT[];
BEGIN
  -- Get some other users for multiplayer games
  SELECT ARRAY_AGG(user_id) INTO v_other_users
  FROM (
    SELECT user_id
    FROM public.users
    WHERE user_id != my_user_id
    LIMIT 3
  ) sub;

  RAISE NOTICE '════════════════════════════════════════';
  RAISE NOTICE '🎮 Creating PlayNow Test Games...';
  RAISE NOTICE '════════════════════════════════════════';

  -- =====================================================
  -- 1. OPEN GAMES (you can join/request these)
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
  RAISE NOTICE '✓ Badminton Doubles (Auto Join) - 2 days from now at 6:00 PM';

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
  RAISE NOTICE '✓ Pickleball Doubles (Request Join) - Tomorrow at 10:00 AM';

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
  RAISE NOTICE '✓ Badminton Singles (Free) - 3 days from now at 4:00 PM';

  -- =====================================================
  -- 2. COMPLETED GAMES (for after-game features)
  -- =====================================================

  RAISE NOTICE '';
  RAISE NOTICE '📊 Creating completed games for testing after-game features...';

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
    CASE WHEN array_length(v_other_users, 1) >= 3 THEN 4
         ELSE COALESCE(array_length(v_other_users, 1), 0) + 1 END
  ) RETURNING id INTO v_game_id;

  -- Add you as participant
  INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
  VALUES (v_game_id, my_user_id, 'creator', NOW() - INTERVAL '2 days');

  -- Add other players if available
  IF v_other_users IS NOT NULL AND array_length(v_other_users, 1) >= 1 THEN
    FOR i IN 1..LEAST(3, array_length(v_other_users, 1)) LOOP
      INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
      VALUES (v_game_id, v_other_users[i], 'auto_join', NOW() - INTERVAL '2 days');
    END LOOP;
    RAISE NOTICE '✓ Completed Badminton Doubles - Yesterday (% players)',
      LEAST(4, COALESCE(array_length(v_other_users, 1), 0) + 1);
  ELSE
    RAISE NOTICE '✓ Completed Badminton Doubles - Yesterday (1 player - you)';
    RAISE NOTICE '  ⚠️  No other users found. After-game features will be limited.';
  END IF;

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
  IF v_other_users IS NOT NULL AND array_length(v_other_users, 1) >= 1 THEN
    INSERT INTO playnow.game_participants (game_id, user_id, join_type, joined_at)
    VALUES (v_game_id, v_other_users[1], 'auto_join', NOW() - INTERVAL '3 days');
    RAISE NOTICE '✓ Completed Pickleball Singles - 2 days ago (2 players)';
  ELSE
    RAISE NOTICE '✓ Completed Pickleball Singles - 2 days ago (1 player - you)';
  END IF;

  -- =====================================================
  -- 3. FULL GAME (to test full status)
  -- =====================================================

  RAISE NOTICE '';
  RAISE NOTICE '🔒 Creating full game...';

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
  RAISE NOTICE '✓ Full Badminton Doubles - 4 days from now';

  RAISE NOTICE '';
  RAISE NOTICE '════════════════════════════════════════';
  RAISE NOTICE '✅ All test games created successfully!';
  RAISE NOTICE '════════════════════════════════════════';
  RAISE NOTICE '';
  RAISE NOTICE '📱 What to do next:';
  RAISE NOTICE '1. Go to your app and navigate to PlayNow';
  RAISE NOTICE '2. Pull to refresh or restart the app';
  RAISE NOTICE '3. You should see 6 test games!';
  RAISE NOTICE '';
  RAISE NOTICE '🎯 What you can test:';
  RAISE NOTICE '✓ Join open games (auto join)';
  RAISE NOTICE '✓ Request to join games (approval needed)';
  RAISE NOTICE '✓ View full games';
  RAISE NOTICE '✓ Record scores in completed games';
  RAISE NOTICE '✓ Rate players in completed games';
  RAISE NOTICE '✓ Tag players in completed games';
  RAISE NOTICE '✓ Add play pals from completed games';
  RAISE NOTICE '';

END $$;

-- Show summary
SELECT
  'Test Games Summary' as "📊 Summary",
  COUNT(*) FILTER (WHERE status = 'open') as "Open Games",
  COUNT(*) FILTER (WHERE status = 'completed') as "Completed Games",
  COUNT(*) FILTER (WHERE status = 'full') as "Full Games",
  COUNT(*) as "Total Games"
FROM playnow.games
WHERE created_by = 'GhO4QtVW4Dh7MrjfRmiqJI0gZQv2';

-- Show all games
SELECT
  CASE status
    WHEN 'open' THEN '🟢'
    WHEN 'completed' THEN '✅'
    WHEN 'full' THEN '🔴'
    ELSE '⚪'
  END as "",
  CASE sport_type
    WHEN 'badminton' THEN '🏸'
    WHEN 'pickleball' THEN '🎾'
    ELSE '🎮'
  END as "",
  game_type as "Type",
  status as "Status",
  current_players_count || '/' || players_needed as "Players",
  game_date::date as "Date",
  start_time as "Time",
  CASE WHEN is_free THEN 'Free' ELSE '₹' || cost_per_player::text END as "Cost",
  join_type as "Join Type"
FROM playnow.games
WHERE created_by = 'GhO4QtVW4Dh7MrjfRmiqJI0gZQv2'
ORDER BY
  CASE status
    WHEN 'open' THEN 1
    WHEN 'completed' THEN 2
    WHEN 'full' THEN 3
    ELSE 4
  END,
  game_date;
