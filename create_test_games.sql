-- Create Test Games for PlayNow Module
-- User: GhO4QtVW4Dh7MrjfRmiqJI0gZQv2

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

  RAISE NOTICE 'Creating PlayNow Test Games...';

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
  RAISE NOTICE 'Created: Badminton Doubles (Auto Join)';

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
  RAISE NOTICE 'Created: Pickleball Doubles (Request Join)';

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
  RAISE NOTICE 'Created: Badminton Singles (Free)';

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
    RAISE NOTICE 'Created: Completed Badminton Doubles with % players',
      LEAST(4, COALESCE(array_length(v_other_users, 1), 0) + 1);
  ELSE
    RAISE NOTICE 'Created: Completed Badminton Doubles (1 player only)';
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
    RAISE NOTICE 'Created: Completed Pickleball Singles with 2 players';
  ELSE
    RAISE NOTICE 'Created: Completed Pickleball Singles (1 player only)';
  END IF;

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
  RAISE NOTICE 'Created: Full Badminton Doubles';

  RAISE NOTICE 'All test games created successfully!';

END $$;

-- Show summary
SELECT
  COUNT(*) FILTER (WHERE status = 'open') as "Open",
  COUNT(*) FILTER (WHERE status = 'completed') as "Completed",
  COUNT(*) FILTER (WHERE status = 'full') as "Full",
  COUNT(*) as "Total"
FROM playnow.games
WHERE created_by = 'GhO4QtVW4Dh7MrjfRmiqJI0gZQv2';

-- Show all games
SELECT
  sport_type as "Sport",
  game_type as "Type",
  status as "Status",
  current_players_count || '/' || players_needed as "Players",
  game_date as "Date",
  start_time as "Time",
  CASE WHEN is_free THEN 'Free' ELSE 'Rs ' || cost_per_player::text END as "Cost",
  join_type as "Join"
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
