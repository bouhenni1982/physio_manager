-- Add patient phone support for app v1.0.1+3
alter table if exists public.patients
add column if not exists phone text;
