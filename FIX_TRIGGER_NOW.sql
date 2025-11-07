-- IMMEDIATE FIX: Drop and recreate the add_participant_to_chat trigger
-- This is the trigger causing the "game_date" error
-- Run this ENTIRE file in Supabase SQL Editor NOW

-- Step 1: Drop the broken trigger and function
DROP TRIGGER IF EXISTS add_participant_to_chat_trigger ON playnow.game_participants CASCADE;
DROP FUNCTION IF EXISTS playnow.add_participant_to_chat() CASCADE;

-- Step 2: Recreate the function WITHOUT referencing game_date
CREATE OR REPLACE FUNCTION playnow.add_participant_to_chat()
RETURNS TRIGGER AS $$
DECLARE
  v_room_id UUID;
BEGIN
  -- Get the chat_room_id from the game (using the game_id from the INSERT)
  SELECT chat_room_id INTO v_room_id
  FROM playnow.games
  WHERE id = NEW.game_id;

  -- If the game has a chat room, add the participant as a member
  IF v_room_id IS NOT NULL THEN
    INSERT INTO chat.room_members (room_id, user_id, role)
    VALUES (v_room_id, NEW.user_id, 'member')
    ON CONFLICT (room_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 3: Recreate the trigger
CREATE TRIGGER add_participant_to_chat_trigger
  AFTER INSERT ON playnow.game_participants
  FOR EACH ROW
  EXECUTE FUNCTION playnow.add_participant_to_chat();

-- Done! The trigger is now fixed and won't reference game_date
