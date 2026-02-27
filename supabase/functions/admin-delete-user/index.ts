// Supabase Edge Function: admin-delete-user
// Requires SUPABASE_SERVICE_ROLE_KEY secret.
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

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

    const callerClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: userData, error: userError } = await callerClient.auth.getUser();
    if (userError || !userData.user) {
      return new Response('unauthorized', { status: 401 });
    }

    const { data: roleRow, error: roleError } = await callerClient
      .from('therapists')
      .select('is_primary')
      .eq('user_id', userData.user.id)
      .maybeSingle();
    if (roleError || roleRow?.is_primary !== true) {
      return new Response('forbidden_only_admin', { status: 403 });
    }

    const body = await req.json();
    const userId = String(body.user_id ?? '').trim();
    const therapistId = String(body.therapist_id ?? '').trim();
    if (!userId) return new Response('invalid_payload', { status: 400 });

    const adminClient = createClient(supabaseUrl, serviceRoleKey);

    // Resolve target therapist row if present and block deleting primary admin.
    const therapistQuery = therapistId
      ? adminClient.from('therapists').select('id,is_primary').eq('id', therapistId)
      : adminClient.from('therapists').select('id,is_primary').eq('user_id', userId);
    const { data: therapistRows, error: therapistReadError } = await therapistQuery;
    if (therapistReadError) {
      return new Response(therapistReadError.message, { status: 400 });
    }
    const target = (therapistRows ?? [])[0];
    if (target?.is_primary === true) {
      return new Response('cannot_delete_primary_admin', { status: 400 });
    }

    // Delete therapist row first (if any).
    if (target?.id) {
      const { error: therapistDeleteError } = await adminClient
        .from('therapists')
        .delete()
        .eq('id', target.id);
      if (therapistDeleteError) {
        return new Response(therapistDeleteError.message, { status: 400 });
      }
    }

    // delete auth user
    const { error: delError } = await adminClient.auth.admin.deleteUser(userId);
    if (delError) {
      return new Response(delError.message ?? 'delete_user_failed', { status: 400 });
    }

    return Response.json({ ok: true, user_id: userId }, { status: 200 });
  } catch (e) {
    return new Response(String(e), { status: 500 });
  }
});
