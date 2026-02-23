import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/role.dart';
import '../data/auth_repository_impl.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});

final currentUserRoleProvider = FutureProvider<String>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return UserRole.therapist.value;
  try {
    final row = await Supabase.instance.client
        .from('therapists')
        .select('is_primary')
        .eq('user_id', user.id)
        .maybeSingle();
    final isAdmin = row?['is_primary'] == true;
    return isAdmin ? UserRole.admin.value : UserRole.therapist.value;
  } catch (_) {
    return UserRole.therapist.value;
  }
});
