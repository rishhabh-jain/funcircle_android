-- Create message_reports table for content moderation in the chat schema
-- This table tracks reported messages from users

CREATE TABLE IF NOT EXISTS chat.message_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES chat.messages(id),
    room_id UUID NOT NULL REFERENCES chat.rooms(id),
    reporter_id TEXT NOT NULL REFERENCES public.users(user_id),
    reported_user_id TEXT NOT NULL REFERENCES public.users(user_id),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
    admin_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    reviewed_at TIMESTAMPTZ,
    reviewed_by TEXT REFERENCES public.users(user_id)
);

-- Create indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_message_reports_message_id ON chat.message_reports(message_id);
CREATE INDEX IF NOT EXISTS idx_message_reports_reporter_id ON chat.message_reports(reporter_id);
CREATE INDEX IF NOT EXISTS idx_message_reports_status ON chat.message_reports(status);
CREATE INDEX IF NOT EXISTS idx_message_reports_created_at ON chat.message_reports(created_at DESC);

-- Row Level Security (RLS) Configuration
-- Note: This app uses Firebase Auth, not Supabase Auth
-- RLS is enabled but uses permissive policies since auth happens at app level

ALTER TABLE chat.message_reports ENABLE ROW LEVEL SECURITY;

-- Allow all operations for authenticated and anon users
-- Security is handled at the application level (Flutter app)
CREATE POLICY "Allow all operations on message_reports"
ON chat.message_reports FOR ALL
TO public
USING (true)
WITH CHECK (true);

COMMENT ON TABLE chat.message_reports IS 'Stores user reports of inappropriate messages for content moderation';
COMMENT ON COLUMN chat.message_reports.status IS 'Status of the report: pending, reviewed, resolved, dismissed';
COMMENT ON COLUMN chat.message_reports.admin_notes IS 'Notes added by moderators during review';
