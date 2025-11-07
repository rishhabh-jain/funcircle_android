-- Migration: Create public views for findplayers schema tables
-- This allows the Flutter app to access findplayers data through the public schema
-- Run this in your Supabase SQL Editor

-- ==================== DROP EXISTING VIEWS (if any) ====================

DROP VIEW IF EXISTS public.user_locations CASCADE;
DROP VIEW IF EXISTS public.player_requests CASCADE;
DROP VIEW IF EXISTS public.player_request_responses CASCADE;
DROP VIEW IF EXISTS public.game_sessions CASCADE;
DROP VIEW IF EXISTS public.game_session_joins CASCADE;
DROP VIEW IF EXISTS public.match_history CASCADE;
DROP VIEW IF EXISTS public.match_preferences CASCADE;

-- ==================== CREATE VIEWS ====================

-- 1. User Locations View
CREATE OR REPLACE VIEW public.user_locations AS
SELECT * FROM findplayers.user_locations;

-- 2. Player Requests View
CREATE OR REPLACE VIEW public.player_requests AS
SELECT * FROM findplayers.player_requests;

-- 3. Player Request Responses View
CREATE OR REPLACE VIEW public.player_request_responses AS
SELECT * FROM findplayers.player_request_responses;

-- 4. Game Sessions View
CREATE OR REPLACE VIEW public.game_sessions AS
SELECT * FROM findplayers.game_sessions;

-- 5. Game Session Joins View
CREATE OR REPLACE VIEW public.game_session_joins AS
SELECT * FROM findplayers.game_session_joins;

-- 6. Match History View
CREATE OR REPLACE VIEW public.match_history AS
SELECT * FROM findplayers.match_history;

-- 7. Match Preferences View
CREATE OR REPLACE VIEW public.match_preferences AS
SELECT * FROM findplayers.match_preferences;

-- ==================== GRANT PERMISSIONS ====================

-- Grant SELECT permissions to authenticated users
GRANT SELECT ON public.user_locations TO authenticated;
GRANT SELECT ON public.player_requests TO authenticated;
GRANT SELECT ON public.player_request_responses TO authenticated;
GRANT SELECT ON public.game_sessions TO authenticated;
GRANT SELECT ON public.game_session_joins TO authenticated;
GRANT SELECT ON public.match_history TO authenticated;
GRANT SELECT ON public.match_preferences TO authenticated;

-- ==================== ENABLE INSERT/UPDATE/DELETE ON VIEWS ====================

-- User Locations - Enable INSERT, UPDATE, DELETE
CREATE OR REPLACE RULE user_locations_insert AS
ON INSERT TO public.user_locations
DO INSTEAD
INSERT INTO findplayers.user_locations VALUES (NEW.*);

CREATE OR REPLACE RULE user_locations_update AS
ON UPDATE TO public.user_locations
DO INSTEAD
UPDATE findplayers.user_locations
SET
  user_id = NEW.user_id,
  latitude = NEW.latitude,
  longitude = NEW.longitude,
  is_available = NEW.is_available,
  sport_type = NEW.sport_type,
  skill_level = NEW.skill_level,
  updated_at = NEW.updated_at
WHERE id = OLD.id;

CREATE OR REPLACE RULE user_locations_delete AS
ON DELETE TO public.user_locations
DO INSTEAD
DELETE FROM findplayers.user_locations WHERE id = OLD.id;

-- Player Requests - Enable INSERT, UPDATE, DELETE
CREATE OR REPLACE RULE player_requests_insert AS
ON INSERT TO public.player_requests
DO INSTEAD
INSERT INTO findplayers.player_requests VALUES (NEW.*);

CREATE OR REPLACE RULE player_requests_update AS
ON UPDATE TO public.player_requests
DO INSTEAD
UPDATE findplayers.player_requests
SET
  user_id = NEW.user_id,
  sport_type = NEW.sport_type,
  venue_id = NEW.venue_id,
  custom_location = NEW.custom_location,
  latitude = NEW.latitude,
  longitude = NEW.longitude,
  players_needed = NEW.players_needed,
  scheduled_time = NEW.scheduled_time,
  skill_level = NEW.skill_level,
  description = NEW.description,
  status = NEW.status,
  created_at = NEW.created_at,
  expires_at = NEW.expires_at
WHERE id = OLD.id;

CREATE OR REPLACE RULE player_requests_delete AS
ON DELETE TO public.player_requests
DO INSTEAD
DELETE FROM findplayers.player_requests WHERE id = OLD.id;

-- Player Request Responses - Enable INSERT, UPDATE, DELETE
CREATE OR REPLACE RULE player_request_responses_insert AS
ON INSERT TO public.player_request_responses
DO INSTEAD
INSERT INTO findplayers.player_request_responses VALUES (NEW.*);

CREATE OR REPLACE RULE player_request_responses_update AS
ON UPDATE TO public.player_request_responses
DO INSTEAD
UPDATE findplayers.player_request_responses
SET
  request_id = NEW.request_id,
  responder_id = NEW.responder_id,
  status = NEW.status,
  message = NEW.message,
  created_at = NEW.created_at
WHERE id = OLD.id;

CREATE OR REPLACE RULE player_request_responses_delete AS
ON DELETE TO public.player_request_responses
DO INSTEAD
DELETE FROM findplayers.player_request_responses WHERE id = OLD.id;

-- Game Sessions - Enable INSERT, UPDATE, DELETE
CREATE OR REPLACE RULE game_sessions_insert AS
ON INSERT TO public.game_sessions
DO INSTEAD
INSERT INTO findplayers.game_sessions VALUES (NEW.*);

CREATE OR REPLACE RULE game_sessions_update AS
ON UPDATE TO public.game_sessions
DO INSTEAD
UPDATE findplayers.game_sessions
SET
  creator_id = NEW.creator_id,
  sport_type = NEW.sport_type,
  venue_id = NEW.venue_id,
  session_type = NEW.session_type,
  max_players = NEW.max_players,
  current_players = NEW.current_players,
  scheduled_time = NEW.scheduled_time,
  duration_minutes = NEW.duration_minutes,
  skill_level_required = NEW.skill_level_required,
  is_private = NEW.is_private,
  session_code = NEW.session_code,
  status = NEW.status,
  latitude = NEW.latitude,
  longitude = NEW.longitude,
  cost_per_player = NEW.cost_per_player,
  notes = NEW.notes,
  created_at = NEW.created_at,
  updated_at = NEW.updated_at
WHERE id = OLD.id;

CREATE OR REPLACE RULE game_sessions_delete AS
ON DELETE TO public.game_sessions
DO INSTEAD
DELETE FROM findplayers.game_sessions WHERE id = OLD.id;

-- ==================== GRANT INSERT/UPDATE/DELETE PERMISSIONS ====================

GRANT INSERT, UPDATE, DELETE ON public.user_locations TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.player_requests TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.player_request_responses TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.game_sessions TO authenticated;

-- ==================== ENABLE ROW LEVEL SECURITY ====================

ALTER VIEW public.user_locations SET (security_invoker = on);
ALTER VIEW public.player_requests SET (security_invoker = on);
ALTER VIEW public.player_request_responses SET (security_invoker = on);
ALTER VIEW public.game_sessions SET (security_invoker = on);

-- ==================== VERIFICATION ====================

-- Verify views exist
SELECT
  schemaname,
  viewname
FROM pg_views
WHERE schemaname = 'public'
  AND viewname IN (
    'user_locations',
    'player_requests',
    'player_request_responses',
    'game_sessions'
  );

-- Test view access (should return 0 if no data exists yet)
SELECT COUNT(*) as user_locations_count FROM public.user_locations;
SELECT COUNT(*) as player_requests_count FROM public.player_requests;
SELECT COUNT(*) as game_sessions_count FROM public.game_sessions;

COMMENT ON VIEW public.user_locations IS 'Public view for findplayers.user_locations - used by Flutter app';
COMMENT ON VIEW public.player_requests IS 'Public view for findplayers.player_requests - used by Flutter app';
COMMENT ON VIEW public.player_request_responses IS 'Public view for findplayers.player_request_responses - used by Flutter app';
COMMENT ON VIEW public.game_sessions IS 'Public view for findplayers.game_sessions - used by Flutter app';
