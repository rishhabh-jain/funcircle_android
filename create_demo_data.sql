-- ============================================
-- Fun Circle - Demo Data Setup for App Review
-- ============================================
-- Run this in Supabase SQL Editor
-- Creates test accounts, games, chats, and bookings

-- ============================================
-- 1. CREATE DEMO USERS
-- ============================================

-- Demo User 1 (Primary test account)
INSERT INTO public.users (
  user_id,
  first_name,
  email,
  gender,
  preferred_sports,
  skill_level_badminton,
  skill_level_pickleball,
  age,
  location,
  bio,
  images,
  created,
  profile_picture,
  isOnline,
  lastactive
) VALUES (
  'demo_user_apple_review_001',
  'Alex Kumar',
  'demoplayer@funcircle.app',
  'male',
  ARRAY['badminton', 'pickleball'],
  4,
  3,
  '28',
  'Gurgaon, India',
  'Test account for App Store review. Love playing badminton and pickleball!',
  ARRAY['https://i.pravatar.cc/150?img=12'],
  NOW(),
  'https://i.pravatar.cc/150?img=12',
  true,
  NOW()
) ON CONFLICT (user_id) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  email = EXCLUDED.email;

-- Demo User 2 (Chat partner)
INSERT INTO public.users (
  user_id,
  first_name,
  email,
  gender,
  preferred_sports,
  skill_level_badminton,
  age,
  location,
  bio,
  images,
  created,
  profile_picture,
  isOnline,
  lastactive
) VALUES (
  'demo_user_apple_review_002',
  'Priya Sharma',
  'priya.demo@funcircle.app',
  'female',
  ARRAY['badminton'],
  3,
  '26',
  'Delhi, India',
  'Badminton enthusiast. Looking for doubles partners!',
  ARRAY['https://i.pravatar.cc/150?img=23'],
  NOW(),
  'https://i.pravatar.cc/150?img=23',
  true,
  NOW()
) ON CONFLICT (user_id) DO UPDATE SET
  first_name = EXCLUDED.first_name;

-- Demo User 3 (Another player)
INSERT INTO public.users (
  user_id,
  first_name,
  email,
  gender,
  preferred_sports,
  skill_level_pickleball,
  age,
  location,
  bio,
  images,
  created,
  profile_picture,
  isOnline,
  lastactive
) VALUES (
  'demo_user_apple_review_003',
  'Rahul Verma',
  'rahul.demo@funcircle.app',
  'male',
  ARRAY['pickleball'],
  4,
  '30',
  'Noida, India',
  'Pickleball player. Available most evenings!',
  ARRAY['https://i.pravatar.cc/150?img=33'],
  NOW(),
  'https://i.pravatar.cc/150?img=33',
  false,
  NOW() - INTERVAL '2 hours'
) ON CONFLICT (user_id) DO UPDATE SET
  first_name = EXCLUDED.first_name;

-- ============================================
-- 2. CREATE DEMO CHAT ROOM AND MESSAGES
-- ============================================

-- Create a chat room
DO $$
DECLARE
  room_uuid UUID;
BEGIN
  -- Create room
  INSERT INTO chat.rooms (
    id,
    name,
    description,
    type,
    sport_type,
    created_by,
    is_active,
    created_at
  ) VALUES (
    gen_random_uuid(),
    'Badminton Saturday Game',
    'Demo chat for App Store review',
    'group',
    'badminton',
    'demo_user_apple_review_001',
    true,
    NOW()
  ) RETURNING id INTO room_uuid;

  -- Add room members
  INSERT INTO chat.room_members (room_id, user_id, role, joined_at)
  VALUES
    (room_uuid, 'demo_user_apple_review_001', 'admin', NOW()),
    (room_uuid, 'demo_user_apple_review_002', 'member', NOW()),
    (room_uuid, 'demo_user_apple_review_003', 'member', NOW());

  -- Add demo messages
  INSERT INTO chat.messages (room_id, sender_id, content, message_type, created_at)
  VALUES
    (room_uuid, 'demo_user_apple_review_001', 'Hey everyone! Looking forward to Saturday''s game!', 'text', NOW() - INTERVAL '2 days'),
    (room_uuid, 'demo_user_apple_review_002', 'Me too! What time are we playing?', 'text', NOW() - INTERVAL '2 days' + INTERVAL '5 minutes'),
    (room_uuid, 'demo_user_apple_review_001', '6 PM at Sector 52 Badminton Club. I''ve booked the court.', 'text', NOW() - INTERVAL '2 days' + INTERVAL '10 minutes'),
    (room_uuid, 'demo_user_apple_review_003', 'Perfect! I''ll bring the shuttlecocks 🏸', 'text', NOW() - INTERVAL '2 days' + INTERVAL '15 minutes'),
    (room_uuid, 'demo_user_apple_review_002', 'Great! See you all there!', 'text', NOW() - INTERVAL '2 days' + INTERVAL '20 minutes');

  RAISE NOTICE 'Created chat room: %', room_uuid;
END $$;

-- ============================================
-- 3. CREATE DEMO VENUE (if not exists)
-- ============================================

INSERT INTO public.venues (
  venue_name,
  location,
  city,
  state,
  sport_type,
  description,
  amenities,
  court_count,
  price_per_hour,
  is_featured,
  lat,
  lng,
  images,
  created_at
) VALUES (
  'Sector 52 Badminton Club',
  'Sector 52, Golf Course Road',
  'Gurgaon',
  'Haryana',
  'badminton',
  'Premium badminton facility with 4 courts, air-conditioned, wooden flooring',
  ARRAY['Air Conditioned', 'Parking', 'Changing Rooms', 'Water', 'Equipment Rental'],
  4,
  500,
  true,
  28.4400,
  77.0600,
  ARRAY['https://images.unsplash.com/photo-1626224583764-f87db24ac4ea'],
  NOW()
) ON CONFLICT DO NOTHING;

-- ============================================
-- 4. CREATE OFFICIAL DEMO GAMES
-- ============================================

-- Get venue ID
DO $$
DECLARE
  venue_id_var BIGINT;
  game_uuid_1 UUID;
  game_uuid_2 UUID;
  room_uuid UUID;
BEGIN
  -- Get a venue ID
  SELECT id INTO venue_id_var FROM public.venues LIMIT 1;

  -- Create official game 1 (Tomorrow evening)
  INSERT INTO playnow.games (
    id,
    created_by,
    sport_type,
    game_date,
    start_time,
    end_time,
    venue_id,
    players_needed,
    current_players_count,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    status,
    is_official,
    description,
    created_at
  ) VALUES (
    gen_random_uuid(),
    'demo_user_apple_review_001',
    'badminton',
    CURRENT_DATE + INTERVAL '1 day',
    '18:00',
    '19:00',
    venue_id_var,
    4,
    1,
    'doubles',
    3,
    250,
    false,
    'auto',
    'open',
    true,
    'Demo official game for App Store review. Join us for doubles badminton!',
    NOW()
  ) RETURNING id INTO game_uuid_1;

  -- Create chat room for game 1
  INSERT INTO chat.rooms (
    id,
    name,
    type,
    sport_type,
    created_by,
    is_active
  ) VALUES (
    gen_random_uuid(),
    'Badminton Doubles - Tomorrow 6 PM',
    'group',
    'badminton',
    'demo_user_apple_review_001',
    true
  ) RETURNING id INTO room_uuid;

  -- Update game with chat room
  UPDATE playnow.games SET chat_room_id = room_uuid WHERE id = game_uuid_1;

  -- Add game participant
  INSERT INTO playnow.game_participants (game_id, user_id, joined_at, join_type)
  VALUES (game_uuid_1, 'demo_user_apple_review_001', NOW(), 'creator');

  -- Create official game 2 (This weekend)
  INSERT INTO playnow.games (
    id,
    created_by,
    sport_type,
    game_date,
    start_time,
    end_time,
    venue_id,
    players_needed,
    current_players_count,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    status,
    is_official,
    description,
    created_at
  ) VALUES (
    gen_random_uuid(),
    'demo_user_apple_review_001',
    'pickleball',
    CURRENT_DATE + INTERVAL '3 days',
    '10:00',
    '11:30',
    venue_id_var,
    4,
    2,
    'doubles',
    4,
    300,
    false,
    'request',
    'open',
    true,
    'Weekend pickleball doubles. Intermediate to advanced players welcome!',
    NOW()
  ) RETURNING id INTO game_uuid_2;

  -- Add participants
  INSERT INTO playnow.game_participants (game_id, user_id, joined_at, join_type)
  VALUES
    (game_uuid_2, 'demo_user_apple_review_001', NOW(), 'creator'),
    (game_uuid_2, 'demo_user_apple_review_003', NOW(), 'accepted_request');

  RAISE NOTICE 'Created official games: % and %', game_uuid_1, game_uuid_2;
END $$;

-- ============================================
-- 5. CREATE USER-CREATED GAMES (Free)
-- ============================================

DO $$
DECLARE
  venue_id_var BIGINT;
  game_uuid UUID;
BEGIN
  SELECT id INTO venue_id_var FROM public.venues LIMIT 1;

  -- Create free user game
  INSERT INTO playnow.games (
    id,
    created_by,
    sport_type,
    game_date,
    start_time,
    end_time,
    venue_id,
    players_needed,
    current_players_count,
    game_type,
    skill_level,
    cost_per_player,
    is_free,
    join_type,
    status,
    is_official,
    description,
    created_at
  ) VALUES (
    gen_random_uuid(),
    'demo_user_apple_review_002',
    'badminton',
    CURRENT_DATE + INTERVAL '2 days',
    '19:30',
    '20:30',
    venue_id_var,
    2,
    1,
    'singles',
    3,
    0,
    true,
    'auto',
    'open',
    false,
    'Casual singles match. Free to join, bring your own racket!',
    NOW()
  ) RETURNING id INTO game_uuid;

  INSERT INTO playnow.game_participants (game_id, user_id, joined_at, join_type)
  VALUES (game_uuid, 'demo_user_apple_review_002', NOW(), 'creator');

  RAISE NOTICE 'Created user game: %', game_uuid;
END $$;

-- ============================================
-- 6. CREATE CONNECTIONS
-- ============================================

INSERT INTO public.connections (user_id1, user_id2, status)
VALUES
  ('demo_user_apple_review_001', 'demo_user_apple_review_002', 'accepted'),
  ('demo_user_apple_review_001', 'demo_user_apple_review_003', 'accepted')
ON CONFLICT DO NOTHING;

-- ============================================
-- 7. CREATE DEMO NOTIFICATIONS
-- ============================================

INSERT INTO playnow.notifications (
  user_id,
  notification_type,
  title,
  body,
  from_user_id,
  is_read,
  created_at
) VALUES
  (
    'demo_user_apple_review_001',
    'friend_joined_game',
    'Priya joined your game!',
    'Priya Sharma joined your badminton game on Saturday',
    'demo_user_apple_review_002',
    false,
    NOW() - INTERVAL '1 hour'
  ),
  (
    'demo_user_apple_review_001',
    'chat_message',
    'New message from Priya',
    'What time are we playing?',
    'demo_user_apple_review_002',
    true,
    NOW() - INTERVAL '2 days'
  );

-- ============================================
-- SUCCESS MESSAGE
-- ============================================

DO $$
BEGIN
  RAISE NOTICE '✅ Demo data created successfully!';
  RAISE NOTICE '';
  RAISE NOTICE '📧 Demo Account Email: demoplayer@funcircle.app';
  RAISE NOTICE '🔑 Demo Account Password: DemoPass123!';
  RAISE NOTICE '';
  RAISE NOTICE 'Created:';
  RAISE NOTICE '  • 3 demo users';
  RAISE NOTICE '  • 1 chat room with messages';
  RAISE NOTICE '  • 1 demo venue';
  RAISE NOTICE '  • 2 official games (with payment)';
  RAISE NOTICE '  • 1 free user game';
  RAISE NOTICE '  • 2 connections';
  RAISE NOTICE '  • 2 notifications';
  RAISE NOTICE '';
  RAISE NOTICE '🎮 Official games are marked with is_official = true';
  RAISE NOTICE '💳 These will require payment in the app';
END $$;
