-- Enforce max one non-canceled appointment per patient per day.
-- Run this once in Supabase SQL editor.

create unique index if not exists ux_appointments_patient_day_active
on public.appointments (
  patient_id,
  ((scheduled_at at time zone 'UTC')::date)
)
where status <> 'canceled';

