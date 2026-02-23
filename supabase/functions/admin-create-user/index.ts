// Supabase Edge Function template: admin-create-user
// Deploy as: supabase functions deploy admin-create-user --no-verify-jwt=false
// Then grant only authenticated requests (default), and keep SERVICE_ROLE key only in function secrets.

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// Embedded defaults requested by user.
const supabaseUrl =
  Deno.env.get('SUPABASE_URL') ?? 'https://jxksxewurykyjswbbcwa.supabase.co';
const anonKey =
  Deno.env.get('SUPABASE_ANON_KEY') ??
  'sb_publishable_rKQiaGRXChraEkAv_fCDdg_cJTsrYJh';
const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

Deno.serve(async (req) => {
  try {
    if (!serviceRoleKey) {
      return new Response('missing_service_role_key_secret', { status: 500 });
    }
    const authHeader = req.headers.get('Authorization') ?? '';
    if (!authHeader.startsWith('Bearer ')) {
      return new Response('missing_auth', { status: 401 });
    }

    // Client scoped to caller (used to verify caller + role).
    const callerClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: userData, error: userError } = await callerClient.auth.getUser();
    if (userError || !userData.user) {
      return new Response('unauthorized', { status: 401 });
    }

    // Verify caller is admin from therapists table.
    const { data: roleRow, error: roleError } = await callerClient
      .from('therapists')
      .select('is_primary')
      .eq('user_id', userData.user.id)
      .maybeSingle();
    if (roleError || roleRow?.is_primary !== true) {
      return new Response('forbidden_only_admin', { status: 403 });
    }

    const body = await req.json();
    const fullName = String(body.full_name ?? '').trim();
    const email = String(body.email ?? '').trim().toLowerCase();
    const password = String(body.password ?? '');
    const phone = body.phone ? String(body.phone).trim() : null;

    if (!fullName || !email || password.length < 8) {
      return new Response('invalid_payload', { status: 400 });
    }

    // Admin client (service-role) to create auth user + therapist row.
    const adminClient = createClient(supabaseUrl, serviceRoleKey);

    const { data: created, error: createError } = await adminClient.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { full_name: fullName },
    });
    if (createError || !created.user) {
      return new Response(createError?.message ?? 'create_user_failed', { status: 400 });
    }

    const { error: insertError } = await adminClient.from('therapists').upsert({
      id: created.user.id,
      user_id: created.user.id,
      full_name: fullName,
      phone,
      is_primary: false,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }, { onConflict: 'user_id' });

    if (insertError) {
      return new Response(insertError.message, { status: 400 });
    }

    return Response.json({ ok: true, user_id: created.user.id }, { status: 200 });
  } catch (e) {
    return new Response(String(e), { status: 500 });
  }
});
