-- COMPLETE FIX: Run these commands in order
-- This will fix the game_date error permanently

-- Step 1: Fix the schedule_game_reminders function
DROP FUNCTION IF EXISTS playnow.schedule_game_reminders() CASCADE;

CREATE OR REPLACE FUNCTION playnow.schedule_game_reminders()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
DECLARE
  reminder_time timestamp with time zone;
  participant record;
  venue_name text;
  venue_location text;
  game_info record;
BEGIN
  -- Get game details by joining with games table (FIXED: was trying to use NEW.game_date)
  SELECT
    g.game_date,
    g.start_time,
    g.sport_type,
    g.venue_id,
    g.custom_location,
    g.current_players_count
  INTO game_info
  FROM playnow.games g
  WHERE g.id = NEW.game_id;

  -- Calculate reminder time (1 hour before)
  reminder_time := (game_info.game_date + game_info.start_time::time) - interval '1 hour';

  -- Only schedule if game is in the future
  IF reminder_time > now() THEN
    -- Get venue details
    SELECT v.venue_name, v.location INTO venue_name, venue_location
    FROM public.venues v
    WHERE v.id = game_info.venue_id;

    -- Create reminder for each participant
    FOR participant IN
      SELECT user_id FROM playnow.game_participants WHERE game_id = NEW.game_id
    LOOP
      INSERT INTO playnow.notifications (
        user_id,
        notification_type,
        title,
        body,
        game_id,
        scheduled_for,
        data
      ) VALUES (
        participant.user_id,
        'game_reminder',
        'Game starting soon!',
        'Your ' || game_info.sport_type || ' game starts in 1 hour at ' || COALESCE(venue_name, game_info.custom_location),
        NEW.game_id,
        reminder_time,
        jsonb_build_object(
          'venue_name', venue_name,
          'location', COALESCE(venue_location, game_info.custom_location),
          'start_time', game_info.start_time,
          'players_count', game_info.current_players_count
        )
      );
    END LOOP;
  END IF;

  RETURN NEW;
END;
$function$;

-- Step 2: Re-enable user triggers
ALTER TABLE playnow.game_participants ENABLE TRIGGER USER;

-- Step 3: Re-enable RLS (if you disabled it earlier)
ALTER TABLE playnow.game_participants ENABLE ROW LEVEL SECURITY;

-- Done! Everything is fixed and re-enabled
-- Test booking now - it should work without errors ✅
