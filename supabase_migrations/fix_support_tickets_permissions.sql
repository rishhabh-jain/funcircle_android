-- Fix permissions for support_tickets table

-- Grant usage on public schema
GRANT USAGE ON SCHEMA public TO anon, authenticated;

-- Grant all permissions on support_tickets table
GRANT ALL ON public.support_tickets TO anon, authenticated;

-- Grant usage on sequence if any (for auto-increment)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;

-- Ensure RLS is disabled (we already did this, but double-check)
ALTER TABLE public.support_tickets DISABLE ROW LEVEL SECURITY;

-- Grant select, insert, update, delete explicitly
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_tickets TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_tickets TO authenticated;
