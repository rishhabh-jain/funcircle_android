-- ============================================================================
-- Add is_organizer column to users table
-- ============================================================================
-- This column tracks whether a user is currently an approved organizer

-- Add is_organizer column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'users'
        AND column_name = 'is_organizer'
    ) THEN
        ALTER TABLE users ADD COLUMN is_organizer BOOLEAN DEFAULT false;
        RAISE NOTICE 'Column is_organizer added to users table';
    ELSE
        RAISE NOTICE 'Column is_organizer already exists';
    END IF;
END $$;

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_users_is_organizer ON users(is_organizer);

-- Sync existing data: Set is_organizer = true for users with approved applications
UPDATE users
SET is_organizer = true
WHERE user_id IN (
    SELECT user_id
    FROM playnow.game_organizers
    WHERE status = 'approved'
);

-- Sync existing data: Set is_organizer = false for users with rejected/suspended applications
UPDATE users
SET is_organizer = false
WHERE user_id IN (
    SELECT user_id
    FROM playnow.game_organizers
    WHERE status IN ('rejected', 'suspended')
);

-- Verify the sync
SELECT
    u.user_id,
    u.first_name,
    u.is_organizer,
    g.status as organizer_status
FROM users u
LEFT JOIN playnow.game_organizers g ON u.user_id = g.user_id
WHERE g.user_id IS NOT NULL
ORDER BY g.status, u.first_name;
