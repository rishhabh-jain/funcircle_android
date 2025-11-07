-- ============================================
-- CHAT ROOM INVITES FEATURE
-- ============================================
-- This migration adds invite link functionality for chat rooms
-- Users can generate shareable invite links to add players to chat rooms

-- ============================================
-- 1. CREATE ROOM INVITES TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS chat.room_invites (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  created_by text NOT NULL,
  invite_code text NOT NULL UNIQUE,
  invite_link text NOT NULL,
  max_uses integer DEFAULT NULL, -- NULL means unlimited
  current_uses integer DEFAULT 0,
  expires_at timestamp with time zone DEFAULT NULL, -- NULL means never expires
  is_active boolean DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT room_invites_pkey PRIMARY KEY (id),
  CONSTRAINT room_invites_room_fkey FOREIGN KEY (room_id) REFERENCES chat.rooms(id) ON DELETE CASCADE,
  CONSTRAINT room_invites_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE CASCADE,
  CONSTRAINT max_uses_positive CHECK (max_uses IS NULL OR max_uses > 0),
  CONSTRAINT current_uses_not_negative CHECK (current_uses >= 0)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_room_invites_invite_code ON chat.room_invites(invite_code);
CREATE INDEX IF NOT EXISTS idx_room_invites_room_id ON chat.room_invites(room_id);
CREATE INDEX IF NOT EXISTS idx_room_invites_created_by ON chat.room_invites(created_by);

-- Add comment
COMMENT ON TABLE chat.room_invites IS 'Stores invite links for chat rooms';

-- ============================================
-- 2. CREATE INVITE USAGE TRACKING TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS chat.room_invite_usage (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  invite_id uuid NOT NULL,
  user_id text NOT NULL,
  used_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT room_invite_usage_pkey PRIMARY KEY (id),
  CONSTRAINT room_invite_usage_invite_fkey FOREIGN KEY (invite_id) REFERENCES chat.room_invites(id) ON DELETE CASCADE,
  CONSTRAINT room_invite_usage_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE,
  CONSTRAINT unique_invite_user UNIQUE (invite_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_room_invite_usage_invite_id ON chat.room_invite_usage(invite_id);
CREATE INDEX IF NOT EXISTS idx_room_invite_usage_user_id ON chat.room_invite_usage(user_id);

-- Add comment
COMMENT ON TABLE chat.room_invite_usage IS 'Tracks who used which invite link';

-- ============================================
-- 3. AUTO-UPDATE TIMESTAMP TRIGGER
-- ============================================

CREATE OR REPLACE FUNCTION chat.update_room_invites_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_room_invites_timestamp
  BEFORE UPDATE ON chat.room_invites
  FOR EACH ROW
  EXECUTE FUNCTION chat.update_room_invites_updated_at();

-- ============================================
-- 4. INCREMENT INVITE USAGE TRIGGER
-- ============================================

CREATE OR REPLACE FUNCTION chat.increment_invite_usage()
RETURNS TRIGGER AS $$
BEGIN
  -- Increment current_uses count
  UPDATE chat.room_invites
  SET current_uses = current_uses + 1
  WHERE id = NEW.invite_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_increment_invite_usage
  AFTER INSERT ON chat.room_invite_usage
  FOR EACH ROW
  EXECUTE FUNCTION chat.increment_invite_usage();

-- ============================================
-- 5. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on room_invites
ALTER TABLE chat.room_invites ENABLE ROW LEVEL SECURITY;

-- Policy: Room members and admins can view invites for their rooms
CREATE POLICY "Room members can view room invites"
ON chat.room_invites
FOR SELECT
TO authenticated
USING (
  room_id IN (
    SELECT room_id FROM chat.room_members
    WHERE user_id = auth.uid()::text
  )
);

-- Policy: Room admins and moderators can create invites
CREATE POLICY "Room admins can create invites"
ON chat.room_invites
FOR INSERT
TO authenticated
WITH CHECK (
  room_id IN (
    SELECT room_id FROM chat.room_members
    WHERE user_id = auth.uid()::text
    AND role IN ('admin', 'moderator')
  )
);

-- Policy: Only creator can delete their invites
CREATE POLICY "Creators can delete their invites"
ON chat.room_invites
FOR DELETE
TO authenticated
USING (created_by = auth.uid()::text);

-- Policy: Admins and creators can update invites
CREATE POLICY "Admins can update invites"
ON chat.room_invites
FOR UPDATE
TO authenticated
USING (
  created_by = auth.uid()::text
  OR room_id IN (
    SELECT room_id FROM chat.room_members
    WHERE user_id = auth.uid()::text
    AND role = 'admin'
  )
);

-- Enable RLS on invite_usage
ALTER TABLE chat.room_invite_usage ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can insert usage (when joining via invite)
CREATE POLICY "Anyone can record invite usage"
ON chat.room_invite_usage
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid()::text);

-- Policy: Users can view their own usage
CREATE POLICY "Users can view their invite usage"
ON chat.room_invite_usage
FOR SELECT
TO authenticated
USING (
  user_id = auth.uid()::text
  OR invite_id IN (
    SELECT id FROM chat.room_invites WHERE created_by = auth.uid()::text
  )
);

-- ============================================
-- 6. HELPER FUNCTIONS
-- ============================================

-- Function to check if invite is valid
CREATE OR REPLACE FUNCTION chat.is_invite_valid(p_invite_code TEXT)
RETURNS BOOLEAN AS $$
DECLARE
  v_invite chat.room_invites;
BEGIN
  SELECT * INTO v_invite
  FROM chat.room_invites
  WHERE invite_code = p_invite_code
    AND is_active = true;

  -- Check if invite exists
  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;

  -- Check if expired
  IF v_invite.expires_at IS NOT NULL AND v_invite.expires_at < NOW() THEN
    RETURN FALSE;
  END IF;

  -- Check if max uses reached
  IF v_invite.max_uses IS NOT NULL AND v_invite.current_uses >= v_invite.max_uses THEN
    RETURN FALSE;
  END IF;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get invite details by code
CREATE OR REPLACE FUNCTION chat.get_invite_details(p_invite_code TEXT)
RETURNS TABLE(
  room_id uuid,
  room_name text,
  room_type text,
  sport_type text,
  avatar_url text,
  member_count bigint,
  max_members integer,
  created_by_name text,
  created_by_image text,
  is_valid boolean
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    r.id AS room_id,
    r.name AS room_name,
    r.type AS room_type,
    r.sport_type,
    r.avatar_url,
    (SELECT COUNT(*) FROM chat.room_members WHERE room_id = r.id) AS member_count,
    r.max_members,
    u.first_name AS created_by_name,
    (u.images)[1] AS created_by_image,
    chat.is_invite_valid(p_invite_code) AS is_valid
  FROM chat.room_invites i
  JOIN chat.rooms r ON i.room_id = r.id
  JOIN public.users u ON i.created_by = u.user_id
  WHERE i.invite_code = p_invite_code;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to deactivate expired invites (can be run periodically)
CREATE OR REPLACE FUNCTION chat.deactivate_expired_invites()
RETURNS INTEGER AS $$
DECLARE
  v_count INTEGER;
BEGIN
  UPDATE chat.room_invites
  SET is_active = false
  WHERE expires_at IS NOT NULL
    AND expires_at < NOW()
    AND is_active = true;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to deactivate maxed-out invites
CREATE OR REPLACE FUNCTION chat.deactivate_maxed_invites()
RETURNS INTEGER AS $$
DECLARE
  v_count INTEGER;
BEGIN
  UPDATE chat.room_invites
  SET is_active = false
  WHERE max_uses IS NOT NULL
    AND current_uses >= max_uses
    AND is_active = true;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 7. GRANT PERMISSIONS
-- ============================================

GRANT SELECT, INSERT ON chat.room_invites TO authenticated;
GRANT SELECT, INSERT ON chat.room_invite_usage TO authenticated;

GRANT EXECUTE ON FUNCTION chat.is_invite_valid(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION chat.get_invite_details(TEXT) TO authenticated;

-- ============================================
-- 8. CREATE VIEW FOR ROOM INVITES WITH DETAILS
-- ============================================

CREATE OR REPLACE VIEW chat.room_invites_view AS
SELECT
  i.id,
  i.room_id,
  i.invite_code,
  i.invite_link,
  i.max_uses,
  i.current_uses,
  i.expires_at,
  i.is_active,
  i.created_at,
  i.updated_at,
  i.created_by,
  u.first_name AS creator_name,
  (u.images)[1] AS creator_image,
  r.name AS room_name,
  r.type AS room_type,
  r.sport_type,
  (SELECT COUNT(*) FROM chat.room_members WHERE room_id = i.room_id) AS member_count,
  CASE
    WHEN i.is_active = false THEN 'inactive'
    WHEN i.expires_at IS NOT NULL AND i.expires_at < NOW() THEN 'expired'
    WHEN i.max_uses IS NOT NULL AND i.current_uses >= i.max_uses THEN 'maxed'
    ELSE 'active'
  END AS status
FROM chat.room_invites i
JOIN chat.rooms r ON i.room_id = r.id
JOIN public.users u ON i.created_by = u.user_id;

GRANT SELECT ON chat.room_invites_view TO authenticated;

-- ============================================
-- MIGRATION COMPLETE
-- ============================================

-- Verify tables were created
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'chat' AND table_name = 'room_invites') THEN
    RAISE NOTICE '✅ chat.room_invites table created successfully';
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'chat' AND table_name = 'room_invite_usage') THEN
    RAISE NOTICE '✅ chat.room_invite_usage table created successfully';
  END IF;

  RAISE NOTICE '✅ Chat room invites feature migration complete!';
  RAISE NOTICE 'ℹ️  You can now generate invite links for chat rooms';
END $$;
