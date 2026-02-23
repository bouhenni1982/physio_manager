-- session_audit migration: details to jsonb
alter table public.session_audit
  alter column details type jsonb
  using case
    when details is null then null
    else details::jsonb
  end;

-- indexes
create index if not exists idx_session_audit_session_id
on public.session_audit (session_id);

create index if not exists idx_session_audit_action
on public.session_audit (action);
