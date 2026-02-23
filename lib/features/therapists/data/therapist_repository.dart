import '../domain/therapist.dart';

abstract class TherapistRepository {
  Future<List<Therapist>> getAll();
  Future<Therapist> create(Therapist therapist);
  Future<void> update(Therapist therapist);
  Future<void> setAdmin(String therapistId, bool isAdmin);
  Future<void> transferPrimary(String therapistId);
  Future<void> delete(String id);
}
