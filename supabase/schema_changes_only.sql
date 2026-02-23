-- minimal changes only (no table creation)

-- ensure RLS on session_audit
alter table public.session_audit enable row level security;

-- details as jsonb
alter table public.session_audit
  alter column details type jsonb
  using case
    when details is null then null
    else details::jsonb
  end;

-- policies (idempotent: drop if exists then create)
drop policy if exists "session_audit_admin_all" on public.session_audit;
drop policy if exists "session_audit_therapist_select" on public.session_audit;
drop policy if exists "session_audit_therapist_insert" on public.session_audit;

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

-- updated_at trigger
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_therapists_updated_at
before update on public.therapists
for each row execute function public.set_updated_at();

create trigger trg_patients_updated_at
before update on public.patients
for each row execute function public.set_updated_at();

create trigger trg_appointments_updated_at
before update on public.appointments
for each row execute function public.set_updated_at();

create trigger trg_sessions_updated_at
before update on public.sessions
for each row execute function public.set_updated_at();

-- session audit trigger (jsonb details + delete support)
create or replace function public.log_session_audit()
returns trigger as $$
declare
  v_action text;
  v_attendance boolean;
  v_notes_excerpt text;
  v_done_at timestamptz;
  v_session_id uuid;
  v_appointment_id uuid;
begin
  if tg_op = 'DELETE' then
    v_action := 'session_deleted';
    v_attendance := old.attendance;
    v_notes_excerpt := case
      when old.notes is null then null
      else left(old.notes, 50)
    end;
    v_done_at := old.done_at;
    v_session_id := old.id;
    v_appointment_id := old.appointment_id;
  else
    v_action := case when tg_op = 'UPDATE' then 'session_updated' else 'session_created' end;
    v_attendance := new.attendance;
    v_notes_excerpt := case
      when new.notes is null then null
      else left(new.notes, 50)
    end;
    v_done_at := new.done_at;
    v_session_id := new.id;
    v_appointment_id := new.appointment_id;
  end if;

  insert into public.session_audit (
    id,
    session_id,
    appointment_id,
    action,
    details,
    created_at
  ) values (
    gen_random_uuid(),
    v_session_id,
    v_appointment_id,
    v_action,
    jsonb_build_object(
      'attendance', v_attendance,
      'notes_excerpt', v_notes_excerpt,
      'done_at', v_done_at
    ),
    now()
  );
  return coalesce(new, old);
end;
$$ language plpgsql;

-- replace triggers for session audit

drop trigger if exists trg_sessions_audit_ins on public.sessions;
drop trigger if exists trg_sessions_audit_upd on public.sessions;
drop trigger if exists trg_sessions_audit_del on public.sessions;

create trigger trg_sessions_audit_ins
after insert on public.sessions
for each row execute function public.log_session_audit();

create trigger trg_sessions_audit_upd
after update on public.sessions
for each row execute function public.log_session_audit();

create trigger trg_sessions_audit_del
after delete on public.sessions
for each row execute function public.log_session_audit();
