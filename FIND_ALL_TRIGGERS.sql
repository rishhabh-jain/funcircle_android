-- Find EVERY trigger and function on game_participants
-- Run this and send me the output

-- 1. Show all triggers on game_participants
SELECT
  t.tgname AS trigger_name,
  p.proname AS function_name
FROM pg_trigger t
JOIN pg_proc p ON t.tgfoid = p.oid
WHERE t.tgrelid = 'playnow.game_participants'::regclass
  AND NOT t.tgisinternal;

-- 2. Show the FULL source code of each function
SELECT
  p.proname AS function_name,
  pg_get_functiondef(p.oid) AS source_code
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'playnow'
  AND (
    p.proname LIKE '%participant%'
    OR p.proname LIKE '%chat%'
    OR p.proname LIKE '%game%'
  )
ORDER BY p.proname;
