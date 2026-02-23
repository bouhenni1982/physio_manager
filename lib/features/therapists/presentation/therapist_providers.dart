import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_invite_service.dart';
import '../data/therapist_repository.dart';
import '../data/therapist_repository_impl.dart';
import '../domain/therapist.dart';

final therapistRepositoryProvider = Provider<TherapistRepository>((ref) {
  return SupabaseTherapistRepository();
});

final therapistsProvider = FutureProvider<List<Therapist>>((ref) {
  final repo = ref.watch(therapistRepositoryProvider);
  return repo.getAll();
});

final adminInviteServiceProvider = Provider<AdminInviteService>((ref) {
  return AdminInviteService();
});
