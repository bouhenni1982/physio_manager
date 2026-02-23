-- Run order:
-- 1) schema.sql
-- 2) triggers.sql
-- 3) session_audit_migration.sql
-- 4) admin_role_functions.sql

\i supabase/schema.sql
\i supabase/triggers.sql
\i supabase/session_audit_migration.sql
\i supabase/admin_role_functions.sql
