import 'package:supabase_flutter/supabase_flutter.dart';

class AdminInviteService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> inviteTherapist({
    required String fullName,
    String? phone,
    required String email,
    required String password,
  }) async {
    final response = await _client.functions.invoke(
      'admin-create-user',
      body: {
        'full_name': fullName.trim(),
        'phone': (phone ?? '').trim().isEmpty ? null : phone!.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );

    // Some versions of supabase_flutter don't expose response.error
    if (response.status != 200) {
      throw Exception(response.data?.toString() ?? 'invite_failed');
    }
  }
}
