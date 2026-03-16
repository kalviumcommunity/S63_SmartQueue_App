-- Tasks table for SmartQueue vendor dashboard
-- Run in Supabase: Dashboard > SQL Editor > New query

CREATE TABLE IF NOT EXISTS public.tasks (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Queued',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all for tasks" ON public.tasks;
CREATE POLICY "Allow all for tasks"
  ON public.tasks FOR ALL
  USING (true)
  WITH CHECK (true);
