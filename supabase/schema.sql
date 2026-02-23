-- core tables
create table if not exists public.therapists (
  id uuid primary key,
  user_id uuid unique not null,
  full_name text not null,
  phone text,
  is_primary boolean default false,
  work_days jsonb,
  work_hours jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.patients (
  id uuid primary key,
  full_name text not null,
  age int,
  gender text,
  diagnosis text,
  suggested_sessions int,
  therapist_id uuid references public.therapists(id),
  doctor_name text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.appointments (
  id uuid primary key,
  patient_id uuid references public.patients(id),
  therapist_id uuid references public.therapists(id),
  scheduled_at timestamptz,
  status text,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.sessions (
  id uuid primary key,
  appointment_id uuid unique references public.appointments(id),
  attendance boolean,
  done_at timestamptz,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.autocomplete_values (
  id uuid primary key,
  type text,
  value text,
  use_count int default 0,
  last_used_at timestamptz
);

create table if not exists public.session_audit (
  id uuid primary key,
  session_id uuid,
  appointment_id uuid,
  action text,
  details jsonb,
  created_at timestamptz default now()
);

-- enable RLS
alter table public.therapists enable row level security;
alter table public.patients enable row level security;
alter table public.appointments enable row level security;
alter table public.sessions enable row level security;
alter table public.autocomplete_values enable row level security;
alter table public.session_audit enable row level security;

create or replace function public.is_current_user_primary()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.therapists t
    where t.user_id = auth.uid()
      and t.is_primary = true
  );
$$;

-- therapists policies
create policy "therapists_admin_all"
on public.therapists
for all
using (public.is_current_user_primary())
with check (public.is_current_user_primary());

create policy "therapists_self_select"
on public.therapists
for select
using (user_id = auth.uid());

create policy "therapists_self_update"
on public.therapists
for update
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy "therapists_self_insert"
on public.therapists
for insert
with check (user_id = auth.uid());

-- patients policies
create policy "patients_admin_all"
on public.patients
for all
using (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
))
with check (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
));

create policy "patients_therapist_select"
on public.patients
for select
using (therapist_id in (
  select id from public.therapists where user_id = auth.uid()
));

create policy "patients_therapist_insert"
on public.patients
for insert
with check (therapist_id in (
  select id from public.therapists where user_id = auth.uid()
));

create policy "patients_therapist_update"
on public.patients
for update
using (therapist_id in (
  select id from public.therapists where user_id = auth.uid()
))
with check (therapist_id in (
  select id from public.therapists where user_id = auth.uid()
));

-- appointments policies
create policy "appointments_admin_all"
on public.appointments
for all
using (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
))
with check (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
));

create policy "appointments_therapist_select"
on public.appointments
for select
using (therapist_id in (
  select id from public.therapists where user_id = auth.uid()
));

create policy "appointments_therapist_insert"
on public.appointments
for insert
with check (therapist_id in (
  select id from public.therapists where user_id = auth.uid()
));

create policy "appointments_therapist_update"
on public.appointments
for update
using (therapist_id in (
  select id from public.therapists where user_id = auth.uid()
))
with check (therapist_id in (
  select id from public.therapists where user_id = auth.uid()
));

-- sessions policies
create policy "sessions_admin_all"
on public.sessions
for all
using (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
))
with check (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
));

create policy "sessions_therapist_select"
on public.sessions
for select
using (appointment_id in (
  select id from public.appointments
  where therapist_id in (select id from public.therapists where user_id = auth.uid())
));

create policy "sessions_therapist_insert"
on public.sessions
for insert
with check (appointment_id in (
  select id from public.appointments
  where therapist_id in (select id from public.therapists where user_id = auth.uid())
));

create policy "sessions_therapist_update"
on public.sessions
for update
using (appointment_id in (
  select id from public.appointments
  where therapist_id in (select id from public.therapists where user_id = auth.uid())
))
with check (appointment_id in (
  select id from public.appointments
  where therapist_id in (select id from public.therapists where user_id = auth.uid())
));

-- autocomplete policies
create policy "autocomplete_admin_all"
on public.autocomplete_values
for all
using (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
))
with check (exists (
  select 1 from public.therapists t
  where t.user_id = auth.uid() and t.is_primary = true
));

create policy "autocomplete_therapist_select"
on public.autocomplete_values
for select
using (auth.uid() is not null);

create policy "autocomplete_therapist_insert"
on public.autocomplete_values
for insert
with check (auth.uid() is not null);

create policy "autocomplete_therapist_update"
on public.autocomplete_values
for update
using (auth.uid() is not null)
with check (auth.uid() is not null);

-- session_audit policies
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

create policy "session_audit_therapist_select"
on public.session_audit
for select
using (appointment_id in (
  select id from public.appointments
  where therapist_id in (select id from public.therapists where user_id = auth.uid())
));

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

create index if not exists idx_session_audit_session_id
on public.session_audit (session_id);

create index if not exists idx_session_audit_action
on public.session_audit (action);
