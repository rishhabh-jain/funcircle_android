-- NUCLEAR OPTION: Disable ONLY user triggers on game_participants
-- This will let your booking work immediately
-- Run this NOW in Supabase SQL Editor

ALTER TABLE playnow.game_participants DISABLE TRIGGER USER;

-- To re-enable them later (after we fix the broken one):
-- ALTER TABLE playnow.game_participants ENABLE TRIGGER USER;
