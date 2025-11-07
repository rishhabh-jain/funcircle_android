-- ============================================
-- Migration: Add Official Games Field
-- ============================================
-- This distinguishes FunCircle official games from
-- regular user-created paid games
-- ============================================

-- Add is_official column to games table
ALTER TABLE playnow.games
ADD COLUMN IF NOT EXISTS is_official BOOLEAN DEFAULT FALSE;

-- Add index for faster filtering
CREATE INDEX IF NOT EXISTS idx_games_is_official
ON playnow.games(is_official)
WHERE is_official = TRUE;

-- Create a view for official games only (optional, for convenience)
CREATE OR REPLACE VIEW playnow.official_games AS
SELECT * FROM playnow.games
WHERE is_official = TRUE;

-- ============================================
-- Mark existing FunCircle organized games as official
-- ============================================
-- You can identify them by checking if they have:
-- 1. payment_required = true
-- 2. created_by is from FunCircle admin accounts
-- 3. OR any other criteria you use

-- Example: Mark games created by specific admin user as official
-- UPDATE playnow.games
-- SET is_official = TRUE
-- WHERE created_by = 'ADMIN_USER_ID';

-- Example: Mark all games with specific venue IDs as official
-- UPDATE playnow.games
-- SET is_official = TRUE
-- WHERE venue_id IN (SELECT id FROM venues WHERE is_funcircle_venue = TRUE);

-- ============================================
-- Verification Query
-- ============================================
-- SELECT id, auto_title, is_official, payment_required, cost_per_player
-- FROM playnow.games
-- WHERE is_official = TRUE;
