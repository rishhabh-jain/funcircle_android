-- Fix for ambiguous column reference in playnow.add_participant_to_chat() function
-- This function is triggered when a participant joins a game

-- Drop the existing function
DROP FUNCTION IF EXISTS playnow.add_participant_to_chat() CASCADE;

-- Recreate the function with proper variable naming to avoid ambiguity
CREATE OR REPLACE FUNCTION playnow.add_participant_to_chat()
RETURNS TRIGGER AS $$
DECLARE
  v_room_id UUID;  -- Use v_ prefix to avoid ambiguity with column name
BEGIN
  -- Get the chat_room_id from the game
  SELECT chat_room_id INTO v_room_id
  FROM playnow.games
  WHERE id = NEW.game_id;

  -- If the game has a chat room, add the participant as a member
  IF v_room_id IS NOT NULL THEN
    INSERT INTO chat.room_members (room_id, user_id, role)
    VALUES (v_room_id, NEW.user_id, 'member')  -- Now using v_room_id
    ON CONFLICT (room_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recreate the trigger
DROP TRIGGER IF EXISTS add_participant_to_chat_trigger ON playnow.game_participants;

CREATE TRIGGER add_participant_to_chat_trigger
  AFTER INSERT ON playnow.game_participants
  FOR EACH ROW
  EXECUTE FUNCTION playnow.add_participant_to_chat();

-- Test the fix
-- You can verify it's working by trying to join a game after running this
