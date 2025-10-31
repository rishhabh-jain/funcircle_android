-- ========================================
-- PLAYNOW TABLES SETUP (in public schema)
-- Run this in Supabase SQL Editor
-- ========================================

-- ========================================
-- 1. GAMES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS public.playnow_games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by UUID NOT NULL,
    sport_type TEXT NOT NULL CHECK (sport_type IN ('badminton', 'pickleball')),
    game_date DATE NOT NULL,
    start_time TEXT NOT NULL,
    venue_id INTEGER,
    venue_name TEXT,
    custom_location TEXT,
    players_needed INTEGER NOT NULL CHECK (players_needed >= 2 AND players_needed <= 10),
    game_type TEXT NOT NULL CHECK (game_type IN ('singles', 'doubles', 'mixed_doubles')),
    skill_level INTEGER CHECK (skill_level >= 1 AND skill_level <= 5),
    cost_per_player DECIMAL(10, 2),
    is_free BOOLEAN NOT NULL DEFAULT true,
    join_type TEXT NOT NULL CHECK (join_type IN ('auto', 'request')) DEFAULT 'auto',
    is_venue_booked BOOLEAN NOT NULL DEFAULT false,
    is_women_only BOOLEAN NOT NULL DEFAULT false,
    is_mixed_only BOOLEAN NOT NULL DEFAULT false,
    description TEXT,
    status TEXT NOT NULL CHECK (status IN ('open', 'full', 'in_progress', 'completed', 'cancelled')) DEFAULT 'open',
    chat_room_id UUID,
    current_players_count INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_playnow_games_sport_type ON playnow_games(sport_type);
CREATE INDEX IF NOT EXISTS idx_playnow_games_status ON playnow_games(status);
CREATE INDEX IF NOT EXISTS idx_playnow_games_created_by ON playnow_games(created_by);
CREATE INDEX IF NOT EXISTS idx_playnow_games_game_date ON playnow_games(game_date);

-- ========================================
-- 2. GAME PARTICIPANTS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS public.playnow_game_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES playnow_games(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    join_type TEXT NOT NULL CHECK (join_type IN ('auto', 'request')) DEFAULT 'auto',
    status TEXT NOT NULL CHECK (status IN ('confirmed', 'pending', 'declined')) DEFAULT 'confirmed',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_playnow_participants_game_id ON playnow_game_participants(game_id);
CREATE INDEX IF NOT EXISTS idx_playnow_participants_user_id ON playnow_game_participants(user_id);

-- ========================================
-- 3. GAME JOIN REQUESTS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS public.playnow_game_join_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES playnow_games(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    message TEXT,
    status TEXT NOT NULL CHECK (status IN ('pending', 'approved', 'declined')) DEFAULT 'pending',
    responded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_playnow_join_requests_game_id ON playnow_game_join_requests(game_id);
CREATE INDEX IF NOT EXISTS idx_playnow_join_requests_status ON playnow_game_join_requests(status);

-- ========================================
-- 4. NOTIFICATIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS public.playnow_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    data JSONB,
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_playnow_notifications_user_id ON playnow_notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_playnow_notifications_is_read ON playnow_notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_playnow_notifications_created_at ON playnow_notifications(created_at DESC);

-- ========================================
-- 5. GAME COMPLETIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS public.playnow_game_completions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES playnow_games(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    result TEXT CHECK (result IN ('won', 'lost', 'draw')),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    feedback TEXT,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, user_id)
);

-- ========================================
-- 6. PLAYER RATINGS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS public.playnow_player_ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES playnow_games(id) ON DELETE CASCADE,
    rater_user_id UUID NOT NULL,
    rated_user_id UUID NOT NULL,
    skill_rating INTEGER NOT NULL CHECK (skill_rating >= 1 AND skill_rating <= 5),
    sportsmanship_rating INTEGER NOT NULL CHECK (sportsmanship_rating >= 1 AND sportsmanship_rating <= 5),
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, rater_user_id, rated_user_id)
);

-- ========================================
-- 7. USER OFFERS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS public.playnow_user_offers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    offer_type TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    discount_amount DECIMAL(10, 2),
    discount_percentage INTEGER CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
    status TEXT NOT NULL CHECK (status IN ('active', 'used', 'expired')) DEFAULT 'active',
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_playnow_offers_user_id ON playnow_user_offers(user_id);
CREATE INDEX IF NOT EXISTS idx_playnow_offers_status ON playnow_user_offers(status);

-- ========================================
-- 8. REFERRALS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS public.playnow_referrals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    referrer_user_id UUID NOT NULL,
    referred_user_id UUID NOT NULL,
    referral_code TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'completed', 'rewarded')) DEFAULT 'pending',
    reward_amount DECIMAL(10, 2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    UNIQUE(referrer_user_id, referred_user_id)
);

CREATE INDEX IF NOT EXISTS idx_playnow_referrals_referrer ON playnow_referrals(referrer_user_id);
CREATE INDEX IF NOT EXISTS idx_playnow_referrals_code ON playnow_referrals(referral_code);

-- ========================================
-- RLS POLICIES
-- ========================================

-- Enable RLS on all tables
ALTER TABLE playnow_games ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow_game_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow_game_join_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow_game_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow_player_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow_user_offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow_referrals ENABLE ROW LEVEL SECURITY;

-- Games policies
DROP POLICY IF EXISTS "Games are viewable by everyone" ON playnow_games;
CREATE POLICY "Games are viewable by everyone"
    ON playnow_games FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated users can create games" ON playnow_games;
CREATE POLICY "Authenticated users can create games"
    ON playnow_games FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update their own games" ON playnow_games;
CREATE POLICY "Users can update their own games"
    ON playnow_games FOR UPDATE USING (true);

-- Participants policies
DROP POLICY IF EXISTS "Participants viewable by everyone" ON playnow_game_participants;
CREATE POLICY "Participants viewable by everyone"
    ON playnow_game_participants FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can join games" ON playnow_game_participants;
CREATE POLICY "Users can join games"
    ON playnow_game_participants FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Users can leave" ON playnow_game_participants;
CREATE POLICY "Users can leave"
    ON playnow_game_participants FOR DELETE USING (true);

-- Join requests policies
DROP POLICY IF EXISTS "View join requests" ON playnow_game_join_requests;
CREATE POLICY "View join requests"
    ON playnow_game_join_requests FOR SELECT USING (true);

DROP POLICY IF EXISTS "Create join requests" ON playnow_game_join_requests;
CREATE POLICY "Create join requests"
    ON playnow_game_join_requests FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Update join requests" ON playnow_game_join_requests;
CREATE POLICY "Update join requests"
    ON playnow_game_join_requests FOR UPDATE USING (true);

-- Notifications policies
DROP POLICY IF EXISTS "View own notifications" ON playnow_notifications;
CREATE POLICY "View own notifications"
    ON playnow_notifications FOR SELECT USING (true);

DROP POLICY IF EXISTS "Create notifications" ON playnow_notifications;
CREATE POLICY "Create notifications"
    ON playnow_notifications FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Update own notifications" ON playnow_notifications;
CREATE POLICY "Update own notifications"
    ON playnow_notifications FOR UPDATE USING (true);

-- Completions policies
DROP POLICY IF EXISTS "View completions" ON playnow_game_completions;
CREATE POLICY "View completions"
    ON playnow_game_completions FOR SELECT USING (true);

DROP POLICY IF EXISTS "Create completions" ON playnow_game_completions;
CREATE POLICY "Create completions"
    ON playnow_game_completions FOR INSERT WITH CHECK (true);

-- Ratings policies
DROP POLICY IF EXISTS "View ratings" ON playnow_player_ratings;
CREATE POLICY "View ratings"
    ON playnow_player_ratings FOR SELECT USING (true);

DROP POLICY IF EXISTS "Create ratings" ON playnow_player_ratings;
CREATE POLICY "Create ratings"
    ON playnow_player_ratings FOR INSERT WITH CHECK (true);

-- Offers policies
DROP POLICY IF EXISTS "View offers" ON playnow_user_offers;
CREATE POLICY "View offers"
    ON playnow_user_offers FOR SELECT USING (true);

DROP POLICY IF EXISTS "Create offers" ON playnow_user_offers;
CREATE POLICY "Create offers"
    ON playnow_user_offers FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Update offers" ON playnow_user_offers;
CREATE POLICY "Update offers"
    ON playnow_user_offers FOR UPDATE USING (true);

-- Referrals policies
DROP POLICY IF EXISTS "View referrals" ON playnow_referrals;
CREATE POLICY "View referrals"
    ON playnow_referrals FOR SELECT USING (true);

DROP POLICY IF EXISTS "Manage referrals" ON playnow_referrals;
CREATE POLICY "Manage referrals"
    ON playnow_referrals FOR ALL USING (true) WITH CHECK (true);

-- ========================================
-- SUCCESS!
-- ========================================
SELECT 'PlayNow tables created successfully in public schema!' as status;
