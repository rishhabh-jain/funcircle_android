-- Find and fix the trigger issue on game_participants
-- Run this in Supabase SQL Editor

-- Step 1: Find all triggers on game_participants
SELECT
  tgname AS trigger_name,
  pg_get_triggerdef(oid) AS trigger_definition
FROM pg_trigger
WHERE tgrelid = 'playnow.game_participants'::regclass
  AND tgname NOT LIKE 'RI_%';  -- Exclude foreign key triggers

-- Step 2: If you find a problematic trigger, you can drop it
-- (Uncomment and modify the line below if needed)
-- DROP TRIGGER IF EXISTS trigger_name_here ON playnow.game_participants;

-- Step 3: Temporary workaround - Try inserting with explicit NULL for missing fields
-- This is what the app will try:
-- INSERT INTO playnow.game_participants (game_id, user_id, join_type, payment_status, payment_amount)
-- VALUES ('uuid-here', 'user-id-here', 'auto_join', 'waived', 0);
