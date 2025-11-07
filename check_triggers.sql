-- Check for triggers on game_participants table
SELECT
  trigger_name,
  event_manipulation,
  event_object_table,
  action_statement,
  action_timing
FROM information_schema.triggers
WHERE event_object_schema = 'playnow'
  AND event_object_table = 'game_participants';

-- Also check the trigger function definitions
SELECT
  p.proname as function_name,
  pg_get_functiondef(p.oid) as function_definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'playnow'
  AND p.proname LIKE '%participant%';
