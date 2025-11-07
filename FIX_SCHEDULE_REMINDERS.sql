-- Fix the schedule_game_reminders function
-- The issue: it's triggered on game_participants but tries to access NEW.game_date
-- Solution: Join with games table to get game_date
-- Run this in Supabase SQL Editor

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
  -- Get game details by joining with games table
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

-- Recreate the trigger
DROP TRIGGER IF EXISTS schedule_game_reminders_trigger ON playnow.game_participants;

CREATE TRIGGER schedule_game_reminders_trigger
  AFTER INSERT ON playnow.game_participants
  FOR EACH ROW
  EXECUTE FUNCTION playnow.schedule_game_reminders();
