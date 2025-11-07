-- Add payment_id field to store Razorpay payment ID
-- Run this migration in Supabase SQL Editor

-- Add column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'playnow'
    AND table_name = 'game_participants'
    AND column_name = 'payment_id'
  ) THEN
    ALTER TABLE playnow.game_participants
    ADD COLUMN payment_id TEXT;
  END IF;
END $$;

-- Create index if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE schemaname = 'playnow'
    AND tablename = 'game_participants'
    AND indexname = 'idx_game_participants_payment_id'
  ) THEN
    CREATE INDEX idx_game_participants_payment_id
    ON playnow.game_participants(payment_id)
    WHERE payment_id IS NOT NULL;
  END IF;
END $$;

-- Add comment
COMMENT ON COLUMN playnow.game_participants.payment_id
IS 'Razorpay payment ID for transaction tracking and reconciliation';
