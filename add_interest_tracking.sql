-- ============================================
-- Migration: Add Interest Tracking for FindPlayers
-- ============================================
-- This allows users to show interest in FindPlayers requests
-- and track those interests in My Games screen
-- ============================================

-- Create player_request_interests table
CREATE TABLE IF NOT EXISTS findplayers.player_request_interests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL REFERENCES findplayers.player_requests(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    -- Ensure one user can only show interest once per request
    UNIQUE(request_id, user_id)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_player_request_interests_user
ON findplayers.player_request_interests(user_id);

CREATE INDEX IF NOT EXISTS idx_player_request_interests_request
ON findplayers.player_request_interests(request_id);

-- Add RLS policies
ALTER TABLE findplayers.player_request_interests ENABLE ROW LEVEL SECURITY;

-- Users can view their own interests
CREATE POLICY "Users can view own interests"
ON findplayers.player_request_interests
FOR SELECT
USING (user_id = current_setting('request.jwt.claims')::json->>'sub');

-- Users can create their own interests
CREATE POLICY "Users can create own interests"
ON findplayers.player_request_interests
FOR INSERT
WITH CHECK (user_id = current_setting('request.jwt.claims')::json->>'sub');

-- Users can delete their own interests (remove interest)
CREATE POLICY "Users can delete own interests"
ON findplayers.player_request_interests
FOR DELETE
USING (user_id = current_setting('request.jwt.claims')::json->>'sub');

-- ============================================
-- Verification Query
-- ============================================
-- SELECT * FROM findplayers.player_request_interests
-- WHERE user_id = 'YOUR_USER_ID';
