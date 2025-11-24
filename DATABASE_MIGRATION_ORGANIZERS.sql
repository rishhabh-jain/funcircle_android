-- ============================================================================
-- FunCircle Game Organizers Feature - Database Migration
-- ============================================================================
-- This migration adds support for users to become game organizers
-- Run this on your Supabase database

-- ============================================================================
-- 1. ADD COLUMNS TO USERS TABLE
-- ============================================================================

-- Add organizer and admin flags to users
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS is_organizer boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS is_admin boolean DEFAULT false;

-- Create indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_users_is_organizer ON public.users(is_organizer) WHERE is_organizer = true;
CREATE INDEX IF NOT EXISTS idx_users_is_admin ON public.users(is_admin) WHERE is_admin = true;

-- ============================================================================
-- 2. CREATE GAME_ORGANIZERS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS playnow.game_organizers (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  sport_type text NOT NULL CHECK (sport_type = ANY (ARRAY['badminton'::text, 'pickleball'::text])),
  venue_id bigint NOT NULL,

  -- Availability
  available_days text[] NOT NULL, -- ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
  available_time_slots jsonb NOT NULL, -- [{"start_time": "06:00", "end_time": "08:00"}, {"start_time": "18:00", "end_time": "21:00"}]

  -- Organizer details
  skill_level integer NOT NULL CHECK (skill_level >= 1 AND skill_level <= 5),
  mobile_number text NOT NULL,
  bio text, -- Why they want to be an organizer
  experience text, -- Playing experience

  -- Application status
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'suspended'::text])),

  -- Approval tracking
  application_date timestamp with time zone NOT NULL DEFAULT now(),
  approved_date timestamp with time zone,
  approved_by text, -- admin user_id who approved
  rejection_reason text,
  rejection_date timestamp with time zone,
  rejected_by text, -- admin user_id who rejected
  suspended_reason text,
  suspended_date timestamp with time zone,
  suspended_by text,

  -- Metadata
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),

  CONSTRAINT game_organizers_pkey PRIMARY KEY (id),
  CONSTRAINT game_organizers_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE,
  CONSTRAINT game_organizers_venue_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(id),
  CONSTRAINT game_organizers_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(user_id),
  CONSTRAINT game_organizers_rejected_by_fkey FOREIGN KEY (rejected_by) REFERENCES public.users(user_id),
  CONSTRAINT game_organizers_suspended_by_fkey FOREIGN KEY (suspended_by) REFERENCES public.users(user_id),
  CONSTRAINT unique_organizer_per_sport_venue UNIQUE (user_id, sport_type, venue_id)
);

-- Create indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_organizers_status ON playnow.game_organizers(status);
CREATE INDEX IF NOT EXISTS idx_organizers_user_id ON playnow.game_organizers(user_id);
CREATE INDEX IF NOT EXISTS idx_organizers_sport_venue ON playnow.game_organizers(sport_type, venue_id);
CREATE INDEX IF NOT EXISTS idx_organizers_created_at ON playnow.game_organizers(created_at DESC);

-- ============================================================================
-- 3. CREATE ORGANIZER ACTIVITY LOG TABLE (for auditing)
-- ============================================================================

CREATE TABLE IF NOT EXISTS playnow.organizer_activity_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  organizer_id uuid NOT NULL,
  action text NOT NULL, -- 'application_submitted', 'approved', 'rejected', 'suspended', 'reactivated', 'game_created', 'game_cancelled'
  performed_by text, -- user_id (admin or organizer)
  details jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),

  CONSTRAINT organizer_activity_log_pkey PRIMARY KEY (id),
  CONSTRAINT organizer_activity_log_organizer_fkey FOREIGN KEY (organizer_id) REFERENCES playnow.game_organizers(id) ON DELETE CASCADE,
  CONSTRAINT organizer_activity_log_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(user_id)
);

CREATE INDEX IF NOT EXISTS idx_organizer_activity_organizer ON playnow.organizer_activity_log(organizer_id);
CREATE INDEX IF NOT EXISTS idx_organizer_activity_action ON playnow.organizer_activity_log(action);
CREATE INDEX IF NOT EXISTS idx_organizer_activity_created ON playnow.organizer_activity_log(created_at DESC);

-- ============================================================================
-- 4. CREATE FUNCTION TO AUTO-SET is_official FOR ORGANIZER GAMES
-- ============================================================================

CREATE OR REPLACE FUNCTION playnow.set_official_for_organizers()
RETURNS TRIGGER AS $$
BEGIN
  -- Check if creator is an approved organizer
  IF EXISTS (
    SELECT 1 FROM playnow.game_organizers
    WHERE user_id = NEW.created_by
    AND status = 'approved'
  ) THEN
    NEW.is_official := true;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS trigger_set_official_for_organizers ON playnow.games;
CREATE TRIGGER trigger_set_official_for_organizers
  BEFORE INSERT ON playnow.games
  FOR EACH ROW
  EXECUTE FUNCTION playnow.set_official_for_organizers();

-- ============================================================================
-- 5. CREATE FUNCTION TO UPDATE users.is_organizer FLAG
-- ============================================================================

CREATE OR REPLACE FUNCTION playnow.update_user_organizer_status()
RETURNS TRIGGER AS $$
BEGIN
  -- When organizer is approved, set is_organizer to true
  IF NEW.status = 'approved' AND (OLD.status IS NULL OR OLD.status != 'approved') THEN
    UPDATE public.users
    SET is_organizer = true
    WHERE user_id = NEW.user_id;

    -- Log the approval
    INSERT INTO playnow.organizer_activity_log (organizer_id, action, performed_by, details)
    VALUES (NEW.id, 'approved', NEW.approved_by, jsonb_build_object('sport_type', NEW.sport_type, 'venue_id', NEW.venue_id));
  END IF;

  -- When organizer is rejected or suspended, check if they have any other approved applications
  IF (NEW.status = 'rejected' OR NEW.status = 'suspended') AND (OLD.status = 'approved') THEN
    -- If no other approved organizer records exist, set is_organizer to false
    IF NOT EXISTS (
      SELECT 1 FROM playnow.game_organizers
      WHERE user_id = NEW.user_id
      AND status = 'approved'
      AND id != NEW.id
    ) THEN
      UPDATE public.users
      SET is_organizer = false
      WHERE user_id = NEW.user_id;
    END IF;

    -- Log the action
    IF NEW.status = 'rejected' THEN
      INSERT INTO playnow.organizer_activity_log (organizer_id, action, performed_by, details)
      VALUES (NEW.id, 'rejected', NEW.rejected_by, jsonb_build_object('reason', NEW.rejection_reason));
    ELSIF NEW.status = 'suspended' THEN
      INSERT INTO playnow.organizer_activity_log (organizer_id, action, performed_by, details)
      VALUES (NEW.id, 'suspended', NEW.suspended_by, jsonb_build_object('reason', NEW.suspended_reason));
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS trigger_update_user_organizer_status ON playnow.game_organizers;
CREATE TRIGGER trigger_update_user_organizer_status
  AFTER INSERT OR UPDATE ON playnow.game_organizers
  FOR EACH ROW
  EXECUTE FUNCTION playnow.update_user_organizer_status();

-- ============================================================================
-- 6. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on game_organizers table
ALTER TABLE playnow.game_organizers ENABLE ROW LEVEL SECURITY;

-- Users can view their own organizer applications
CREATE POLICY "Users can view own organizer application"
  ON playnow.game_organizers FOR SELECT
  USING (auth.uid()::text = user_id);

-- Users can insert their own application (one per sport/venue combination)
CREATE POLICY "Users can apply to be organizer"
  ON playnow.game_organizers FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

-- Users can update their own pending applications
CREATE POLICY "Users can update own pending application"
  ON playnow.game_organizers FOR UPDATE
  USING (auth.uid()::text = user_id AND status = 'pending')
  WITH CHECK (auth.uid()::text = user_id AND status = 'pending');

-- Admins can view all applications
CREATE POLICY "Admins can view all organizer applications"
  ON playnow.game_organizers FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE user_id = auth.uid()::text AND is_admin = true
    )
  );

-- Admins can update any organizer application
CREATE POLICY "Admins can update organizer status"
  ON playnow.game_organizers FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE user_id = auth.uid()::text AND is_admin = true
    )
  );

-- Enable RLS on organizer_activity_log table
ALTER TABLE playnow.organizer_activity_log ENABLE ROW LEVEL SECURITY;

-- Admins can view all activity logs
CREATE POLICY "Admins can view all activity logs"
  ON playnow.organizer_activity_log FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE user_id = auth.uid()::text AND is_admin = true
    )
  );

-- System can insert activity logs
CREATE POLICY "System can insert activity logs"
  ON playnow.organizer_activity_log FOR INSERT
  WITH CHECK (true);

-- ============================================================================
-- 7. HELPER FUNCTIONS
-- ============================================================================

-- Function to get organizer details for a user
CREATE OR REPLACE FUNCTION playnow.get_user_organizer_info(p_user_id text)
RETURNS TABLE (
  organizer_id uuid,
  sport_type text,
  venue_id bigint,
  venue_name text,
  status text,
  available_days text[],
  available_time_slots jsonb,
  skill_level integer,
  mobile_number text
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    go.id,
    go.sport_type,
    go.venue_id,
    v.venue_name,
    go.status,
    go.available_days,
    go.available_time_slots,
    go.skill_level,
    go.mobile_number
  FROM playnow.game_organizers go
  LEFT JOIN public.venues v ON v.id = go.venue_id
  WHERE go.user_id = p_user_id
  AND go.status = 'approved';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 8. SET ADMIN USER
-- ============================================================================

-- Set admin status for the provided email
UPDATE public.users SET is_admin = true WHERE email = 'imrj1999@gmail.com';

-- Verify admin was set
SELECT user_id, first_name, email, is_admin
FROM public.users
WHERE email = 'imrj1999@gmail.com';

-- ============================================================================
-- MIGRATION COMPLETE
-- ============================================================================

-- To verify the migration:
-- SELECT * FROM playnow.game_organizers;
-- SELECT * FROM playnow.organizer_activity_log;
-- SELECT user_id, first_name, email, is_organizer, is_admin FROM public.users WHERE is_organizer = true OR is_admin = true;
