-- Migration: Add location and new sport skill level columns to users table
-- Date: 2026-01-07
-- Description: Adds lat, lng, skill_level_tennis, and skill_level_padel columns

-- Add latitude column
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS lat NUMERIC;

-- Add longitude column
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS lng NUMERIC;

-- Add Tennis skill level column (1-5 scale)
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS skill_level_tennis INTEGER;

-- Add Padel skill level column (1-5 scale)
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS skill_level_padel INTEGER;

-- Add check constraints to ensure skill levels are between 1 and 5
ALTER TABLE public.users
ADD CONSTRAINT check_skill_level_tennis
CHECK (skill_level_tennis IS NULL OR (skill_level_tennis >= 1 AND skill_level_tennis <= 5));

ALTER TABLE public.users
ADD CONSTRAINT check_skill_level_padel
CHECK (skill_level_padel IS NULL OR (skill_level_padel >= 1 AND skill_level_padel <= 5));

-- Add comments for documentation
COMMENT ON COLUMN public.users.lat IS 'User latitude coordinate for location-based features';
COMMENT ON COLUMN public.users.lng IS 'User longitude coordinate for location-based features';
COMMENT ON COLUMN public.users.skill_level_tennis IS 'Tennis skill level (1=Beginner, 5=Expert)';
COMMENT ON COLUMN public.users.skill_level_padel IS 'Padel skill level (1=Beginner, 5=Expert)';

-- Create indexes for location-based queries (optional but recommended)
CREATE INDEX IF NOT EXISTS idx_users_location ON public.users(lat, lng)
WHERE lat IS NOT NULL AND lng IS NOT NULL;
