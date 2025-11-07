-- Payment Attempts Table
-- Tracks all payment attempts for reconciliation and debugging
-- This ensures no payment is lost even if app crashes

CREATE TABLE IF NOT EXISTS playnow.payment_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id UUID NOT NULL REFERENCES playnow.games(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL,

  -- Order details
  razorpay_order_id TEXT,
  razorpay_payment_id TEXT,
  razorpay_signature TEXT,

  -- Payment info
  amount NUMERIC NOT NULL,
  currency TEXT DEFAULT 'INR',
  receipt TEXT,

  -- Status tracking
  status TEXT NOT NULL DEFAULT 'initiated',
  -- Status values: 'initiated', 'processing', 'captured', 'failed', 'verified', 'reconciled'

  -- Error tracking
  error_message TEXT,
  error_code TEXT,

  -- Timestamps
  initiated_at TIMESTAMPTZ DEFAULT NOW(),
  payment_completed_at TIMESTAMPTZ,
  verified_at TIMESTAMPTZ,

  -- Metadata
  user_agent TEXT,
  app_version TEXT,
  metadata JSONB,

  -- Reconciliation
  reconciled BOOLEAN DEFAULT FALSE,
  reconciled_at TIMESTAMPTZ,
  reconciled_by TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_payment_attempts_game_id
ON playnow.payment_attempts(game_id);

CREATE INDEX IF NOT EXISTS idx_payment_attempts_user_id
ON playnow.payment_attempts(user_id);

CREATE INDEX IF NOT EXISTS idx_payment_attempts_order_id
ON playnow.payment_attempts(razorpay_order_id)
WHERE razorpay_order_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_payment_attempts_payment_id
ON playnow.payment_attempts(razorpay_payment_id)
WHERE razorpay_payment_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_payment_attempts_status
ON playnow.payment_attempts(status);

CREATE INDEX IF NOT EXISTS idx_payment_attempts_reconciled
ON playnow.payment_attempts(reconciled)
WHERE reconciled = FALSE;

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION playnow.update_payment_attempt_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_payment_attempt_timestamp_trigger
ON playnow.payment_attempts;

CREATE TRIGGER update_payment_attempt_timestamp_trigger
  BEFORE UPDATE ON playnow.payment_attempts
  FOR EACH ROW
  EXECUTE FUNCTION playnow.update_payment_attempt_timestamp();

-- RLS Policies
ALTER TABLE playnow.payment_attempts ENABLE ROW LEVEL SECURITY;

-- Users can view their own payment attempts
CREATE POLICY "Users can view own payment attempts"
ON playnow.payment_attempts
FOR SELECT
TO authenticated
USING (user_id = auth.uid()::text);

-- Users can create payment attempts for themselves
CREATE POLICY "Users can create own payment attempts"
ON playnow.payment_attempts
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid()::text);

-- Users can update their own payment attempts (for status changes)
CREATE POLICY "Users can update own payment attempts"
ON playnow.payment_attempts
FOR UPDATE
TO authenticated
USING (user_id = auth.uid()::text);

-- Admins can view all payment attempts
CREATE POLICY "Admins can view all payment attempts"
ON playnow.payment_attempts
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE user_id = auth.uid()::text
    AND (adminsetlevel = 'admin' OR adminsetlevel = 'super_admin')
  )
);

-- Admins can update any payment attempt (for reconciliation)
CREATE POLICY "Admins can update all payment attempts"
ON playnow.payment_attempts
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE user_id = auth.uid()::text
    AND (adminsetlevel = 'admin' OR adminsetlevel = 'super_admin')
  )
);

COMMENT ON TABLE playnow.payment_attempts IS 'Tracks all payment attempts for reconciliation and debugging';
COMMENT ON COLUMN playnow.payment_attempts.status IS 'initiated, processing, captured, failed, verified, reconciled';
COMMENT ON COLUMN playnow.payment_attempts.reconciled IS 'Whether this payment has been manually verified and reconciled';
