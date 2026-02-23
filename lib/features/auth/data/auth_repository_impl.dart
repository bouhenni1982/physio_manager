import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/role.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Stream<AppUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      if (session == null) return null;
      return _mapUser(session.user);
    });
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (res.session == null) {
      throw Exception('invalid_credentials');
    }
    await _ensureCurrentTherapistProfile(res.user!);
    return _mapUser(res.user!);
  }

  @override
  Future<AppUser> signUp(String fullName, String email, String password) async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    final user = res.user;
    if (user == null) {
      throw Exception('signup_failed');
    }

    if (res.session == null) {
      // Signup succeeded but account needs email verification before first login.
      throw Exception('signup_requires_email_confirmation');
    }

    await _ensureCurrentTherapistProfile(user, fullNameOverride: fullName);

    return _mapUser(user);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

Future<void> _ensureCurrentTherapistProfile(
  User user, {
  String? fullNameOverride,
}) async {
  final client = Supabase.instance.client;
  final fullName = fullNameOverride ?? (user.userMetadata?['full_name'] as String? ?? '');

  try {
    await client.rpc('upsert_current_therapist', params: {'p_full_name': fullName});
  } catch (_) {
    // Fallback keeps auth flow working when RPC is not yet deployed.
    try {
      final existing = await client
          .from('therapists')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();
      if (existing != null) return;
      await client.from('therapists').insert({
        'id': user.id,
        'user_id': user.id,
        'full_name': fullName,
        'is_primary': false,
      });
    } catch (_) {
      // Profile provisioning should not break auth flow on client side.
    }
  }
}

Future<AppUser> _mapUser(User user) async {
  final fullName = user.userMetadata?['full_name'] as String? ?? '';
  final role = await _loadRoleFromTherapist(user.id);
  return AppUser(
    id: user.id,
    fullName: fullName,
    email: user.email ?? '',
    role: role,
    createdAt: DateTime.parse(user.createdAt),
  );
}

Future<String> _loadRoleFromTherapist(String userId) async {
  try {
    final client = Supabase.instance.client;
    final row = await client
        .from('therapists')
        .select('is_primary')
        .eq('user_id', userId)
        .maybeSingle();
    final isPrimary = row?['is_primary'] == true;
    return isPrimary ? UserRole.admin.value : UserRole.therapist.value;
  } catch (_) {
    return UserRole.therapist.value;
  }
}
