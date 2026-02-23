-- session_audit table
create table if not exists public.session_audit (
  id uuid primary key,
  session_id uuid,
  appointment_id uuid,
  action text,
  details text,
  created_at timestamptz default now()
);

-- enable RLS
alter table public.session_audit enable row level security;

-- Admin: all access
create policy "session_audit_admin_all"
on public.session_audit
for all
using (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
))
with check (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
));

-- Therapist: select only own appointments
create policy "session_audit_therapist_select"
on public.session_audit
for select
using (appointment_id in (
  select id from public.appointments
  where therapist_id in (select id from public.therapists where user_id = auth.uid())
));

-- Therapist: insert only for own appointments
create policy "session_audit_therapist_insert"
on public.session_audit
for insert
with check (appointment_id in (
  select id from public.appointments
  where therapist_id in (select id from public.therapists where user_id = auth.uid())
));

-- indexes
create index if not exists idx_session_audit_appointment_id
on public.session_audit (appointment_id);

create index if not exists idx_session_audit_created_at
on public.session_audit (created_at);
