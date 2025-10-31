-- Drop table if exists
DROP TABLE IF EXISTS public.support_tickets CASCADE;

-- Create support_tickets table in public schema
CREATE TABLE public.support_tickets (
  ticket_id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  subject text NOT NULL,
  description text NOT NULL,
  category text NOT NULL DEFAULT 'other',
  status text NOT NULL DEFAULT 'open',
  priority text NOT NULL DEFAULT 'medium',
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  resolved_at timestamp with time zone,
  CONSTRAINT support_tickets_pkey PRIMARY KEY (ticket_id),
  CONSTRAINT support_tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE,
  CONSTRAINT support_tickets_category_check CHECK (category IN ('bug', 'feature_request', 'help', 'other')),
  CONSTRAINT support_tickets_status_check CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
  CONSTRAINT support_tickets_priority_check CHECK (priority IN ('low', 'medium', 'high'))
);

-- Create indexes for faster queries
CREATE INDEX idx_support_tickets_user_id ON public.support_tickets(user_id);
CREATE INDEX idx_support_tickets_status ON public.support_tickets(status);
CREATE INDEX idx_support_tickets_created_at ON public.support_tickets(created_at DESC);

-- Create a trigger to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_support_tickets_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_support_tickets_updated_at
  BEFORE UPDATE ON public.support_tickets
  FOR EACH ROW
  EXECUTE FUNCTION update_support_tickets_updated_at();

-- Disable RLS (since app uses Firebase Auth)
ALTER TABLE public.support_tickets DISABLE ROW LEVEL SECURITY;
