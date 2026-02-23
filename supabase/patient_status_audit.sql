-- Patients: add status classification
alter table public.patients
  add column if not exists status text default 'active';

update public.patients
set status = 'active'
where status is null or status = '';

alter table public.patients
  alter column status set default 'active';

-- Optional safety check for allowed values
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'patients_status_check'
  ) then
    alter table public.patients
      add constraint patients_status_check
      check (status in ('active', 'completed', 'suspended'));
  end if;
end $$;

-- Patient audit table
create table if not exists public.patient_audit (
  id uuid primary key,
  patient_id uuid references public.patients(id) on delete cascade,
  action text not null,
  changed_by uuid,
  details jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_patient_audit_patient_id
  on public.patient_audit (patient_id);

create index if not exists idx_patient_audit_created_at
  on public.patient_audit (created_at);

alter table public.patient_audit enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'patient_audit'
      and policyname = 'patient_audit_admin_all'
  ) then
    create policy "patient_audit_admin_all"
    on public.patient_audit
    for all
    using (is_current_user_primary())
    with check (is_current_user_primary());
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'patient_audit'
      and policyname = 'patient_audit_therapist_select'
  ) then
    create policy "patient_audit_therapist_select"
    on public.patient_audit
    for select
    using (
      patient_id in (
        select p.id
        from public.patients p
        where p.therapist_id in (
          select t.id from public.therapists t where t.user_id = auth.uid()
        )
      )
    );
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'patient_audit'
      and policyname = 'patient_audit_therapist_insert'
  ) then
    create policy "patient_audit_therapist_insert"
    on public.patient_audit
    for insert
    with check (
      patient_id in (
        select p.id
        from public.patients p
        where p.therapist_id in (
          select t.id from public.therapists t where t.user_id = auth.uid()
        )
      )
    );
  end if;
end $$;
