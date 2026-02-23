-- Admin role consistency helpers
-- Run after core schema/policies.

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

create or replace function public.is_current_user_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.is_current_user_primary();
$$;

create or replace function public.upsert_current_therapist(p_full_name text default null)
returns table(therapist_id uuid, is_primary boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid;
  v_existing public.therapists%rowtype;
  v_is_first boolean;
begin
  v_uid := auth.uid();
  if v_uid is null then
    raise exception 'not_authenticated';
  end if;

  select *
  into v_existing
  from public.therapists t
  where t.user_id = v_uid
  limit 1;

  if found then
    if p_full_name is not null and length(trim(p_full_name)) > 0 then
      update public.therapists
      set full_name = p_full_name,
          updated_at = now()
      where id = v_existing.id;
    end if;

    return query
    select v_existing.id, v_existing.is_primary;
    return;
  end if;

  v_is_first := not exists (select 1 from public.therapists where is_primary = true);

  insert into public.therapists (id, user_id, full_name, is_primary, created_at, updated_at)
  values (
    v_uid,
    v_uid,
    coalesce(nullif(trim(p_full_name), ''), 'Therapist'),
    v_is_first,
    now(),
    now()
  );

  return query
  select v_uid, v_is_first;
end;
$$;

create or replace function public.enforce_max_two_admins()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count int;
begin
  if new.is_primary = true then
    select count(*) into v_count
    from public.therapists t
    where t.is_primary = true
      and (tg_op = 'INSERT' or t.id <> new.id);

    if v_count >= 2 then
      raise exception 'max_two_admins_allowed';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_therapists_max_two_admins on public.therapists;
create trigger trg_therapists_max_two_admins
before insert or update on public.therapists
for each row execute function public.enforce_max_two_admins();

create or replace function public.set_therapist_admin(
  p_target_therapist_id uuid,
  p_make_admin boolean
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid;
  v_is_admin boolean;
  v_current_admins int;
begin
  v_uid := auth.uid();
  if v_uid is null then
    raise exception 'not_authenticated';
  end if;

  select public.is_current_user_admin() into v_is_admin;
  if not v_is_admin then
    raise exception 'forbidden_only_admin';
  end if;

  if p_make_admin then
    select count(*) into v_current_admins from public.therapists where is_primary = true;
    if v_current_admins >= 2 then
      raise exception 'max_two_admins_allowed';
    end if;
  else
    select count(*) into v_current_admins from public.therapists where is_primary = true;
    if v_current_admins <= 1 then
      raise exception 'at_least_one_admin_required';
    end if;
  end if;

  update public.therapists
  set is_primary = p_make_admin,
      updated_at = now()
  where id = p_target_therapist_id;
end;
$$;

create or replace function public.transfer_primary_therapist(p_target_therapist_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid;
  v_is_admin boolean;
  v_target_exists boolean;
begin
  v_uid := auth.uid();
  if v_uid is null then
    raise exception 'not_authenticated';
  end if;

  select exists (
    select 1
    from public.therapists t
    where t.user_id = v_uid and t.is_primary = true
  )
  into v_is_admin;

  if not v_is_admin then
    raise exception 'forbidden_only_primary_can_transfer';
  end if;

  select exists (
    select 1
    from public.therapists t
    where t.id = p_target_therapist_id
  )
  into v_target_exists;

  if not v_target_exists then
    raise exception 'target_therapist_not_found';
  end if;

  -- Legacy behavior keeps one primary admin only.
  update public.therapists
  set is_primary = (id = p_target_therapist_id), updated_at = now();
end;
$$;

revoke all on function public.upsert_current_therapist(text) from public;
revoke all on function public.transfer_primary_therapist(uuid) from public;
revoke all on function public.is_current_user_primary() from public;
revoke all on function public.is_current_user_admin() from public;
revoke all on function public.set_therapist_admin(uuid, boolean) from public;
grant execute on function public.upsert_current_therapist(text) to authenticated;
grant execute on function public.transfer_primary_therapist(uuid) to authenticated;
grant execute on function public.is_current_user_primary() to authenticated;
grant execute on function public.is_current_user_admin() to authenticated;
grant execute on function public.set_therapist_admin(uuid, boolean) to authenticated;

drop policy if exists "therapists_admin_all" on public.therapists;
create policy "therapists_admin_all"
on public.therapists
for all
using (public.is_current_user_primary())
with check (public.is_current_user_primary());

-- Harden self policies: non-admin therapists cannot self-promote.
drop policy if exists "therapists_self_insert" on public.therapists;
create policy "therapists_self_insert"
on public.therapists
for insert
with check (user_id = auth.uid() and coalesce(is_primary, false) = false);

drop policy if exists "therapists_self_update" on public.therapists;
create policy "therapists_self_update"
on public.therapists
for update
using (user_id = auth.uid())
with check (user_id = auth.uid() and coalesce(is_primary, false) = false);
