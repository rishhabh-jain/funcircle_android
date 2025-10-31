-- ========================================
-- PLAYNOW SCHEMA SETUP
-- Run this in Supabase SQL Editor
-- ========================================

-- Create schema if not exists
CREATE SCHEMA IF NOT EXISTS playnow;

-- ========================================
-- 1. GAMES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS playnow.games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
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

-- Indexes for games
CREATE INDEX IF NOT EXISTS idx_games_sport_type ON playnow.games(sport_type);
CREATE INDEX IF NOT EXISTS idx_games_status ON playnow.games(status);
CREATE INDEX IF NOT EXISTS idx_games_created_by ON playnow.games(created_by);
CREATE INDEX IF NOT EXISTS idx_games_game_date ON playnow.games(game_date);

-- ========================================
-- 2. GAME PARTICIPANTS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS playnow.game_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES playnow.games(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    join_type TEXT NOT NULL CHECK (join_type IN ('auto', 'request')) DEFAULT 'auto',
    status TEXT NOT NULL CHECK (status IN ('confirmed', 'pending', 'declined')) DEFAULT 'confirmed',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, user_id)
);

-- Indexes for participants
CREATE INDEX IF NOT EXISTS idx_participants_game_id ON playnow.game_participants(game_id);
CREATE INDEX IF NOT EXISTS idx_participants_user_id ON playnow.game_participants(user_id);

-- ========================================
-- 3. GAME JOIN REQUESTS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS playnow.game_join_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES playnow.games(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    message TEXT,
    status TEXT NOT NULL CHECK (status IN ('pending', 'approved', 'declined')) DEFAULT 'pending',
    responded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, user_id)
);

-- Indexes for join requests
CREATE INDEX IF NOT EXISTS idx_join_requests_game_id ON playnow.game_join_requests(game_id);
CREATE INDEX IF NOT EXISTS idx_join_requests_status ON playnow.game_join_requests(status);

-- ========================================
-- 4. NOTIFICATIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS playnow.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    data JSONB,
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON playnow.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON playnow.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON playnow.notifications(created_at DESC);

-- ========================================
-- 5. GAME COMPLETIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS playnow.game_completions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES playnow.games(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    result TEXT CHECK (result IN ('won', 'lost', 'draw')),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    feedback TEXT,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, user_id)
);

-- ========================================
-- 6. PLAYER RATINGS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS playnow.player_ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES playnow.games(id) ON DELETE CASCADE,
    rater_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    rated_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    skill_rating INTEGER NOT NULL CHECK (skill_rating >= 1 AND skill_rating <= 5),
    sportsmanship_rating INTEGER NOT NULL CHECK (sportsmanship_rating >= 1 AND sportsmanship_rating <= 5),
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, rater_user_id, rated_user_id)
);

-- ========================================
-- 7. USER OFFERS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS playnow.user_offers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    offer_type TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    discount_amount DECIMAL(10, 2),
    discount_percentage INTEGER CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
    status TEXT NOT NULL CHECK (status IN ('active', 'used', 'expired')) DEFAULT 'active',
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for offers
CREATE INDEX IF NOT EXISTS idx_offers_user_id ON playnow.user_offers(user_id);
CREATE INDEX IF NOT EXISTS idx_offers_status ON playnow.user_offers(status);

-- ========================================
-- 8. REFERRALS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS playnow.referrals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    referrer_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    referred_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    referral_code TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'completed', 'rewarded')) DEFAULT 'pending',
    reward_amount DECIMAL(10, 2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    UNIQUE(referrer_user_id, referred_user_id)
);

-- Indexes for referrals
CREATE INDEX IF NOT EXISTS idx_referrals_referrer ON playnow.referrals(referrer_user_id);
CREATE INDEX IF NOT EXISTS idx_referrals_code ON playnow.referrals(referral_code);

-- ========================================
-- 9. ADD REFERRAL CODE TO USERS TABLE
-- ========================================
-- Add referral_code column to public.users if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'users'
        AND column_name = 'referral_code'
    ) THEN
        ALTER TABLE public.users ADD COLUMN referral_code TEXT UNIQUE;
    END IF;
END $$;

-- ========================================
-- RLS POLICIES
-- ========================================

-- Enable RLS on all tables
ALTER TABLE playnow.games ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow.game_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow.game_join_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow.game_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow.player_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow.user_offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE playnow.referrals ENABLE ROW LEVEL SECURITY;

-- Games policies
DROP POLICY IF EXISTS "Games are viewable by everyone" ON playnow.games;
CREATE POLICY "Games are viewable by everyone"
    ON playnow.games FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Authenticated users can create games" ON playnow.games;
CREATE POLICY "Authenticated users can create games"
    ON playnow.games FOR INSERT
    WITH CHECK (auth.uid() = created_by);

DROP POLICY IF EXISTS "Users can update their own games" ON playnow.games;
CREATE POLICY "Users can update their own games"
    ON playnow.games FOR UPDATE
    USING (auth.uid() = created_by);

-- Game participants policies
DROP POLICY IF EXISTS "Participants are viewable by everyone" ON playnow.game_participants;
CREATE POLICY "Participants are viewable by everyone"
    ON playnow.game_participants FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Authenticated users can join games" ON playnow.game_participants;
CREATE POLICY "Authenticated users can join games"
    ON playnow.game_participants FOR INSERT
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can leave games" ON playnow.game_participants;
CREATE POLICY "Users can leave games"
    ON playnow.game_participants FOR DELETE
    USING (auth.uid() = user_id);

-- Join requests policies
DROP POLICY IF EXISTS "Users can view join requests for their games" ON playnow.game_join_requests;
CREATE POLICY "Users can view join requests for their games"
    ON playnow.game_join_requests FOR SELECT
    USING (
        auth.uid() = user_id OR
        auth.uid() IN (SELECT created_by FROM playnow.games WHERE id = game_id)
    );

DROP POLICY IF EXISTS "Users can create join requests" ON playnow.game_join_requests;
CREATE POLICY "Users can create join requests"
    ON playnow.game_join_requests FOR INSERT
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Game creators can update join requests" ON playnow.game_join_requests;
CREATE POLICY "Game creators can update join requests"
    ON playnow.game_join_requests FOR UPDATE
    USING (auth.uid() IN (SELECT created_by FROM playnow.games WHERE id = game_id));

-- Notifications policies
DROP POLICY IF EXISTS "Users can view their own notifications" ON playnow.notifications;
CREATE POLICY "Users can view their own notifications"
    ON playnow.notifications FOR SELECT
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "System can create notifications" ON playnow.notifications;
CREATE POLICY "System can create notifications"
    ON playnow.notifications FOR INSERT
    WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update their own notifications" ON playnow.notifications;
CREATE POLICY "Users can update their own notifications"
    ON playnow.notifications FOR UPDATE
    USING (auth.uid() = user_id);

-- Game completions policies
DROP POLICY IF EXISTS "Users can view completions for their games" ON playnow.game_completions;
CREATE POLICY "Users can view completions for their games"
    ON playnow.game_completions FOR SELECT
    USING (
        auth.uid() = user_id OR
        auth.uid() IN (SELECT created_by FROM playnow.games WHERE id = game_id)
    );

DROP POLICY IF EXISTS "Users can create completions" ON playnow.game_completions;
CREATE POLICY "Users can create completions"
    ON playnow.game_completions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Player ratings policies
DROP POLICY IF EXISTS "Users can view ratings" ON playnow.player_ratings;
CREATE POLICY "Users can view ratings"
    ON playnow.player_ratings FOR SELECT
    USING (auth.uid() = rater_user_id OR auth.uid() = rated_user_id);

DROP POLICY IF EXISTS "Users can create ratings" ON playnow.player_ratings;
CREATE POLICY "Users can create ratings"
    ON playnow.player_ratings FOR INSERT
    WITH CHECK (auth.uid() = rater_user_id);

-- User offers policies
DROP POLICY IF EXISTS "Users can view their own offers" ON playnow.user_offers;
CREATE POLICY "Users can view their own offers"
    ON playnow.user_offers FOR SELECT
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "System can create offers" ON playnow.user_offers;
CREATE POLICY "System can create offers"
    ON playnow.user_offers FOR INSERT
    WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update their own offers" ON playnow.user_offers;
CREATE POLICY "Users can update their own offers"
    ON playnow.user_offers FOR UPDATE
    USING (auth.uid() = user_id);

-- Referrals policies
DROP POLICY IF EXISTS "Users can view their referrals" ON playnow.referrals;
CREATE POLICY "Users can view their referrals"
    ON playnow.referrals FOR SELECT
    USING (auth.uid() = referrer_user_id OR auth.uid() = referred_user_id);

DROP POLICY IF EXISTS "System can manage referrals" ON playnow.referrals;
CREATE POLICY "System can manage referrals"
    ON playnow.referrals FOR ALL
    USING (true)
    WITH CHECK (true);

-- ========================================
-- DONE!
-- ========================================
SELECT 'PlayNow schema setup complete!' as status;
