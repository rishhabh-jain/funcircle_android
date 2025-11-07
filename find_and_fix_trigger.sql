-- Find the exact trigger causing the error
-- Run this in Supabase SQL Editor

-- Get ALL triggers on game_participants table with their full definitions
SELECT
  t.tgname AS trigger_name,
  pg_get_triggerdef(t.oid) AS full_trigger_definition,
  p.proname AS function_name,
  pg_get_functiondef(p.oid) AS function_definition
FROM pg_trigger t
JOIN pg_proc p ON t.tgfoid = p.oid
WHERE t.tgrelid = 'playnow.game_participants'::regclass
  AND t.tgname NOT LIKE 'RI_%'  -- Exclude system triggers
ORDER BY t.tgname;

-- This will show you the exact trigger and function that references game_date
-- Look for any mention of "game_date" in the function_definition
