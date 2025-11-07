-- Test Data for Find Players Feature
-- Run this in Supabase SQL Editor to populate test data

-- IMPORTANT: Replace 'YOUR_USER_ID' with your actual user_id from auth.users table
-- You can find it by running: SELECT user_id, first_name FROM users LIMIT 1;

-- Variable for your user ID (replace this)
DO $$
DECLARE
    v_user_id TEXT := 'YOUR_USER_ID'; -- REPLACE WITH YOUR ACTUAL USER ID
    v_request_id UUID;
    v_session_id UUID;
BEGIN

-- ==================== 1. TEST USER LOCATIONS (Players Tab) ====================
-- All locations set near Sector 55, Gurgaon

-- Add your current location as available (Sector 55 Market)
INSERT INTO findplayers.user_locations (user_id, latitude, longitude, is_available, sport_type, skill_level)
VALUES (v_user_id, 28.4178, 77.0952, true, 'badminton', 4)
ON CONFLICT (user_id) DO UPDATE
SET latitude = 28.4178,
    longitude = 77.0952,
    is_available = true,
    sport_type = 'badminton',
    skill_level = 4,
    updated_at = NOW();

-- Add test player 1 (nearby beginner - near Sector 54)
INSERT INTO findplayers.user_locations (user_id, latitude, longitude, is_available, sport_type, skill_level)
SELECT
    user_id,
    28.4192, -- Slightly north (Sector 54 area)
    77.0968,
    true,
    'badminton',
    2
FROM users
WHERE user_id != v_user_id
LIMIT 1
ON CONFLICT (user_id) DO NOTHING;

-- Add test player 2 (nearby intermediate - near Sector 56)
INSERT INTO findplayers.user_locations (user_id, latitude, longitude, is_available, sport_type, skill_level)
SELECT
    user_id,
    28.4165, -- Slightly south (Sector 56 area)
    77.0938,
    true,
    'pickleball',
    3
FROM users
WHERE user_id != v_user_id
OFFSET 1 LIMIT 1
ON CONFLICT (user_id) DO NOTHING;

RAISE NOTICE '✅ Added test player locations';

-- ==================== 2. TEST PLAYER REQUESTS (Requests Tab) ====================

-- Request 1: Your request (the one you just created shows here)
-- Already created via the app!

-- Request 2: Nearby request needing 2 players (Sector 55-56)
INSERT INTO findplayers.player_requests (
    user_id, sport_type, latitude, longitude,
    players_needed, scheduled_time, skill_level,
    description, status, expires_at
)
SELECT
    user_id,
    'badminton',
    28.4185, -- Near Sector 55-56 border
    77.0945,
    2,
    NOW() + INTERVAL '3 hours',
    3,
    'Looking for 2 players for casual badminton. All levels welcome!',
    'active',
    NOW() + INTERVAL '24 hours'
FROM users
WHERE user_id != v_user_id
LIMIT 1
RETURNING id INTO v_request_id;

RAISE NOTICE '✅ Added test request with ID: %', v_request_id;

-- Request 3: Pickleball request at a venue (Sector 54 park)
INSERT INTO findplayers.player_requests (
    user_id, sport_type, venue_id, latitude, longitude,
    players_needed, scheduled_time, skill_level,
    description, status, expires_at
)
SELECT
    user_id,
    'pickleball',
    (SELECT id FROM venues LIMIT 1), -- Uses first venue in DB
    28.4198, -- Near Sector 54 park
    77.0975,
    3,
    NOW() + INTERVAL '5 hours',
    4,
    'Advanced pickleball game near Sector 54. Need 3 more players.',
    'active',
    NOW() + INTERVAL '24 hours'
FROM users
WHERE user_id != v_user_id
OFFSET 1 LIMIT 1;

RAISE NOTICE '✅ Added venue-based request';

-- ==================== 3. TEST GAME SESSIONS (Sessions Tab) ====================

-- Session 1: Saturday morning doubles tournament
INSERT INTO findplayers.game_sessions (
    creator_id, sport_type, session_type, max_players,
    current_players, scheduled_time, duration_minutes,
    skill_level_required, latitude, longitude,
    cost_per_player, notes, status
)
SELECT
    user_id,
    'badminton',
    'doubles',
    8,
    jsonb_build_array(user_id), -- Creator auto-joins (as JSONB)
    CURRENT_DATE + INTERVAL '2 days' + INTERVAL '9 hours', -- This Saturday at 9 AM
    120,
    3,
    28.4170, -- Near Sector 55 sports complex
    77.0945,
    200.00,
    '🏆 Saturday Doubles Tournament - 8 players, round-robin format. Prize for winners!',
    'open'
FROM users
WHERE user_id != v_user_id
LIMIT 1
RETURNING id INTO v_session_id;

RAISE NOTICE '✅ Added doubles session with ID: %', v_session_id;

-- Session 2: Group pickleball game
INSERT INTO findplayers.game_sessions (
    creator_id, sport_type, session_type, max_players,
    current_players, scheduled_time, duration_minutes,
    skill_level_required, latitude, longitude,
    cost_per_player, notes, status
)
SELECT
    user_id,
    'pickleball',
    'group',
    4,
    jsonb_build_array(user_id),
    NOW() + INTERVAL '4 hours',
    90,
    2,
    28.4160, -- Near Sector 56 park
    77.0935,
    0.00,
    'Group pickleball game. All levels welcome! Free game at park.',
    'open'
FROM users
WHERE user_id != v_user_id
OFFSET 1 LIMIT 1;

RAISE NOTICE '✅ Added group session';

-- Session 3: Singles practice (almost full)
INSERT INTO findplayers.game_sessions (
    creator_id, sport_type, session_type, max_players,
    current_players, scheduled_time, duration_minutes,
    skill_level_required, latitude, longitude,
    cost_per_player, notes, status
)
SELECT
    u1.user_id,
    'badminton',
    'singles',
    4,
    jsonb_build_array(u1.user_id, u2.user_id, u3.user_id), -- 3 players already joined
    NOW() + INTERVAL '6 hours',
    120,
    4,
    28.4188, -- Near Sector 54 court
    77.0960,
    500.00,
    '🎯 Singles practice rounds with advanced players. 1 spot left!',
    'open'
FROM users u1
CROSS JOIN (SELECT user_id FROM users OFFSET 1 LIMIT 1) u2
CROSS JOIN (SELECT user_id FROM users OFFSET 2 LIMIT 1) u3
WHERE u1.user_id != v_user_id
LIMIT 1;

RAISE NOTICE '✅ Added singles session';

-- ==================== SUMMARY ====================

RAISE NOTICE '';
RAISE NOTICE '========================================';
RAISE NOTICE '✅ Test data creation complete!';
RAISE NOTICE '========================================';
RAISE NOTICE '';
RAISE NOTICE '📊 What was created:';
RAISE NOTICE '  • 3 available players (Players tab)';
RAISE NOTICE '  • 3 player requests (Requests tab)';
RAISE NOTICE '  • 3 game sessions (Sessions tab)';
RAISE NOTICE '';
RAISE NOTICE '🗺️  All markers are near Sector 55, Gurgaon';
RAISE NOTICE '📍 Coordinates: ~28.41-28.42°N, 77.09-77.10°E';
RAISE NOTICE '';
RAISE NOTICE '🔄 Now refresh your Find Players screen!';
RAISE NOTICE '';

END $$;
