-- replace session audit function to store details as jsonb
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

-- replace triggers
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
