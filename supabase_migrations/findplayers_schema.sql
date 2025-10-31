-- =====================================================
-- Find Players Feature - Database Schema
-- =====================================================
-- This migration creates all tables needed for the find players feature
-- including player requests, user locations, game sessions, and match system

-- Create findplayers schema
CREATE SCHEMA IF NOT EXISTS findplayers;

-- =====================================================
-- 1. Player Requests Table
-- =====================================================
CREATE TABLE IF NOT EXISTS findplayers.player_requests (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL,
  sport_type TEXT NOT NULL,
  venue_id BIGINT NULL,
  custom_location TEXT NULL,
  latitude NUMERIC(10, 8) NULL,
  longitude NUMERIC(11, 8) NULL,
  players_needed INTEGER NOT NULL DEFAULT 1,
  scheduled_time TIMESTAMP WITH TIME ZONE NOT NULL,
  skill_level INTEGER NULL CHECK (skill_level >= 1 AND skill_level <= 5),
  description TEXT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'fulfilled', 'cancelled', 'expired')),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  CONSTRAINT player_requests_pkey PRIMARY KEY (id),
  CONSTRAINT player_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
  CONSTRAINT player_requests_venue_id_fkey FOREIGN KEY (venue_id) REFERENCES public.venues (id) ON DELETE SET NULL
);

-- Index for efficient queries
CREATE INDEX IF NOT EXISTS idx_player_requests_sport_status ON findplayers.player_requests(sport_type, status);
CREATE INDEX IF NOT EXISTS idx_player_requests_user_id ON findplayers.player_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_player_requests_scheduled_time ON findplayers.player_requests(scheduled_time);

-- =====================================================
-- 2. User Locations Table (Real-time availability)
-- =====================================================
CREATE TABLE IF NOT EXISTS findplayers.user_locations (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL,
  latitude NUMERIC(10, 8) NOT NULL,
  longitude NUMERIC(11, 8) NOT NULL,
  is_available BOOLEAN NOT NULL DEFAULT false,
  sport_type TEXT NULL,
  skill_level INTEGER NULL CHECK (skill_level >= 1 AND skill_level <= 5),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  CONSTRAINT user_locations_pkey PRIMARY KEY (id),
  CONSTRAINT user_locations_user_id_key UNIQUE (user_id),
  CONSTRAINT user_locations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE
);

-- Index for location-based queries
CREATE INDEX IF NOT EXISTS idx_user_locations_sport_available ON findplayers.user_locations(sport_type, is_available);
CREATE INDEX IF NOT EXISTS idx_user_locations_updated_at ON findplayers.user_locations(updated_at);

-- =====================================================
-- 3. Player Request Responses Table
-- =====================================================
CREATE TABLE IF NOT EXISTS findplayers.player_request_responses (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  request_id UUID NOT NULL,
  responder_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
  message TEXT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  CONSTRAINT player_request_responses_pkey PRIMARY KEY (id),
  CONSTRAINT player_request_responses_request_fkey FOREIGN KEY (request_id) REFERENCES findplayers.player_requests (id) ON DELETE CASCADE,
  CONSTRAINT player_request_responses_responder_fkey FOREIGN KEY (responder_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
  CONSTRAINT unique_request_response UNIQUE (request_id, responder_id)
);

-- Index for queries
CREATE INDEX IF NOT EXISTS idx_player_request_responses_request_id ON findplayers.player_request_responses(request_id);
CREATE INDEX IF NOT EXISTS idx_player_request_responses_responder_id ON findplayers.player_request_responses(responder_id);

-- =====================================================
-- 4. Game Sessions Table (Phase 2 - Group Play)
-- =====================================================
CREATE TABLE IF NOT EXISTS findplayers.game_sessions (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  creator_id TEXT NOT NULL,
  sport_type TEXT NOT NULL,
  venue_id BIGINT NULL,
  session_type TEXT NOT NULL CHECK (session_type IN ('singles', 'doubles', 'group')),
  max_players INTEGER NOT NULL,
  current_players JSONB NOT NULL DEFAULT '[]'::jsonb,
  scheduled_time TIMESTAMP WITH TIME ZONE NOT NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 60,
  skill_level_required INTEGER NULL CHECK (skill_level_required >= 1 AND skill_level_required <= 5),
  is_private BOOLEAN DEFAULT false,
  session_code TEXT NULL,
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'full', 'in_progress', 'completed', 'cancelled')),
  latitude NUMERIC(10, 8) NULL,
  longitude NUMERIC(11, 8) NULL,
  cost_per_player NUMERIC(10, 2) NULL,
  notes TEXT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  CONSTRAINT game_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT game_sessions_creator_fkey FOREIGN KEY (creator_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
  CONSTRAINT game_sessions_venue_fkey FOREIGN KEY (venue_id) REFERENCES public.venues (id) ON DELETE SET NULL
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_game_sessions_sport_status ON findplayers.game_sessions(sport_type, status);
CREATE INDEX IF NOT EXISTS idx_game_sessions_creator_id ON findplayers.game_sessions(creator_id);
CREATE INDEX IF NOT EXISTS idx_game_sessions_scheduled_time ON findplayers.game_sessions(scheduled_time);
CREATE INDEX IF NOT EXISTS idx_game_sessions_session_code ON findplayers.game_sessions(session_code) WHERE session_code IS NOT NULL;

-- =====================================================
-- 5. Match Preferences Table (Phase 3 - Quick Match)
-- =====================================================
CREATE TABLE IF NOT EXISTS findplayers.match_preferences (
  user_id TEXT NOT NULL,
  sport_type TEXT NOT NULL,
  max_distance_km NUMERIC(5, 2) DEFAULT 10.0,
  preferred_times JSONB NULL,
  skill_level_range INTEGER[] NULL,
  preferred_venues BIGINT[] NULL,
  auto_match_enabled BOOLEAN DEFAULT false,
  notification_enabled BOOLEAN DEFAULT true,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT match_preferences_pkey PRIMARY KEY (user_id, sport_type),
  CONSTRAINT match_preferences_user_fkey FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE
);

-- Index
CREATE INDEX IF NOT EXISTS idx_match_preferences_auto_match ON findplayers.match_preferences(auto_match_enabled) WHERE auto_match_enabled = true;

-- =====================================================
-- 6. Match History Table (Phase 3 - Quick Match)
-- =====================================================
CREATE TABLE IF NOT EXISTS findplayers.match_history (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  user1_id TEXT NOT NULL,
  user2_id TEXT NOT NULL,
  sport_type TEXT NOT NULL,
  match_quality_score NUMERIC(3, 2),
  user1_feedback TEXT CHECK (user1_feedback IN ('positive', 'neutral', 'negative')),
  user2_feedback TEXT CHECK (user2_feedback IN ('positive', 'neutral', 'negative')),
  played_together BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT match_history_pkey PRIMARY KEY (id),
  CONSTRAINT match_history_user1_fkey FOREIGN KEY (user1_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
  CONSTRAINT match_history_user2_fkey FOREIGN KEY (user2_id) REFERENCES public.users (user_id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_match_history_user1_id ON findplayers.match_history(user1_id);
CREATE INDEX IF NOT EXISTS idx_match_history_user2_id ON findplayers.match_history(user2_id);
CREATE INDEX IF NOT EXISTS idx_match_history_users_sport ON findplayers.match_history(user1_id, user2_id, sport_type);

-- =====================================================
-- Add skill level columns to public.users table if not exists
-- =====================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'users'
    AND column_name = 'skill_level_badminton'
  ) THEN
    ALTER TABLE public.users ADD COLUMN skill_level_badminton INTEGER CHECK (skill_level_badminton >= 1 AND skill_level_badminton <= 5);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'users'
    AND column_name = 'skill_level_pickleball'
  ) THEN
    ALTER TABLE public.users ADD COLUMN skill_level_pickleball INTEGER CHECK (skill_level_pickleball >= 1 AND skill_level_pickleball <= 5);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'users'
    AND column_name = 'profile_picture'
  ) THEN
    ALTER TABLE public.users ADD COLUMN profile_picture TEXT;
  END IF;
END $$;

-- =====================================================
-- Add sport_type column to venues table if not exists
-- =====================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'venues'
    AND column_name = 'sport_type'
  ) THEN
    ALTER TABLE public.venues ADD COLUMN sport_type TEXT;
  END IF;
END $$;

-- =====================================================
-- Enable Row Level Security (RLS)
-- =====================================================
ALTER TABLE findplayers.player_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE findplayers.user_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE findplayers.player_request_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE findplayers.game_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE findplayers.match_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE findplayers.match_history ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- RLS Policies
-- =====================================================

-- Player Requests: Anyone can view active requests
CREATE POLICY "Anyone can view active player requests" ON findplayers.player_requests
  FOR SELECT USING (status = 'active');

-- Users can insert their own requests
CREATE POLICY "Users can create their own requests" ON findplayers.player_requests
  FOR INSERT WITH CHECK (auth.uid()::text = user_id);

-- Users can update their own requests
CREATE POLICY "Users can update their own requests" ON findplayers.player_requests
  FOR UPDATE USING (auth.uid()::text = user_id);

-- Users can delete their own requests
CREATE POLICY "Users can delete their own requests" ON findplayers.player_requests
  FOR DELETE USING (auth.uid()::text = user_id);

-- User Locations: Anyone can view available users
CREATE POLICY "Anyone can view available user locations" ON findplayers.user_locations
  FOR SELECT USING (is_available = true);

-- Users can manage their own location
CREATE POLICY "Users can manage their own location" ON findplayers.user_locations
  FOR ALL USING (auth.uid()::text = user_id);

-- Request Responses: Request creator and responders can view
CREATE POLICY "Users can view relevant responses" ON findplayers.player_request_responses
  FOR SELECT USING (
    auth.uid()::text = responder_id OR
    auth.uid()::text IN (SELECT user_id FROM findplayers.player_requests WHERE id = request_id)
  );

-- Users can create responses
CREATE POLICY "Users can create responses" ON findplayers.player_request_responses
  FOR INSERT WITH CHECK (auth.uid()::text = responder_id);

-- Request creators can update response status
CREATE POLICY "Request creators can update responses" ON findplayers.player_request_responses
  FOR UPDATE USING (
    auth.uid()::text IN (SELECT user_id FROM findplayers.player_requests WHERE id = request_id)
  );

-- Game Sessions: Anyone can view open sessions
CREATE POLICY "Anyone can view open game sessions" ON findplayers.game_sessions
  FOR SELECT USING (status IN ('open', 'full', 'in_progress') AND (is_private = false OR session_code IS NOT NULL));

-- Users can create sessions
CREATE POLICY "Users can create game sessions" ON findplayers.game_sessions
  FOR INSERT WITH CHECK (auth.uid()::text = creator_id);

-- Creators can update their sessions
CREATE POLICY "Creators can update their sessions" ON findplayers.game_sessions
  FOR UPDATE USING (auth.uid()::text = creator_id);

-- Creators can delete their sessions
CREATE POLICY "Creators can delete their sessions" ON findplayers.game_sessions
  FOR DELETE USING (auth.uid()::text = creator_id);

-- Match Preferences: Users can manage their own preferences
CREATE POLICY "Users can manage their own match preferences" ON findplayers.match_preferences
  FOR ALL USING (auth.uid()::text = user_id);

-- Match History: Users can view their own history
CREATE POLICY "Users can view their match history" ON findplayers.match_history
  FOR SELECT USING (auth.uid()::text = user1_id OR auth.uid()::text = user2_id);

-- Users can insert match history
CREATE POLICY "Users can create match history" ON findplayers.match_history
  FOR INSERT WITH CHECK (auth.uid()::text = user1_id OR auth.uid()::text = user2_id);

-- Users can update their feedback in match history
CREATE POLICY "Users can update their match feedback" ON findplayers.match_history
  FOR UPDATE USING (auth.uid()::text = user1_id OR auth.uid()::text = user2_id);

-- =====================================================
-- Functions for automatic cleanup and updates
-- =====================================================

-- Function to expire old requests
CREATE OR REPLACE FUNCTION findplayers.expire_old_requests()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE findplayers.player_requests
  SET status = 'expired'
  WHERE status = 'active' AND expires_at < NOW();
END;
$$;

-- Function to clean up old user locations (older than 1 hour)
CREATE OR REPLACE FUNCTION findplayers.cleanup_stale_locations()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE findplayers.user_locations
  SET is_available = false
  WHERE is_available = true AND updated_at < NOW() - INTERVAL '1 hour';
END;
$$;

-- Function to update game session status when full
CREATE OR REPLACE FUNCTION findplayers.update_session_status()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF jsonb_array_length(NEW.current_players) >= NEW.max_players THEN
    NEW.status := 'full';
  ELSIF NEW.status = 'full' AND jsonb_array_length(NEW.current_players) < NEW.max_players THEN
    NEW.status := 'open';
  END IF;
  RETURN NEW;
END;
$$;

-- Trigger to auto-update game session status
CREATE TRIGGER game_session_status_trigger
BEFORE UPDATE ON findplayers.game_sessions
FOR EACH ROW
EXECUTE FUNCTION findplayers.update_session_status();

-- =====================================================
-- Grant permissions
-- =====================================================
GRANT USAGE ON SCHEMA findplayers TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA findplayers TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA findplayers TO anon, authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA findplayers TO anon, authenticated;

-- =====================================================
-- Comments for documentation
-- =====================================================
COMMENT ON SCHEMA findplayers IS 'Schema for find players feature including requests, locations, sessions, and matching';
COMMENT ON TABLE findplayers.player_requests IS 'Player availability requests for finding game partners';
COMMENT ON TABLE findplayers.user_locations IS 'Real-time user locations and availability status';
COMMENT ON TABLE findplayers.player_request_responses IS 'Responses to player finding requests';
COMMENT ON TABLE findplayers.game_sessions IS 'Organized game sessions with multiple players';
COMMENT ON TABLE findplayers.match_preferences IS 'User preferences for smart matching algorithm';
COMMENT ON TABLE findplayers.match_history IS 'History of matched players for ML-based recommendations';
