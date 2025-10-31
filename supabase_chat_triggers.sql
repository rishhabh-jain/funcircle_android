-- Trigger to automatically update room's updated_at when a message is inserted
-- Run this in Supabase SQL Editor

-- Function to update room timestamp
CREATE OR REPLACE FUNCTION chat.update_room_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE chat.rooms
  SET updated_at = NOW()
  WHERE id = NEW.room_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger that calls the function after message insert
DROP TRIGGER IF EXISTS trigger_update_room_timestamp ON chat.messages;
CREATE TRIGGER trigger_update_room_timestamp
  AFTER INSERT ON chat.messages
  FOR EACH ROW
  EXECUTE FUNCTION chat.update_room_timestamp();

-- Grant execute permission on the function
GRANT EXECUTE ON FUNCTION chat.update_room_timestamp() TO authenticated;
