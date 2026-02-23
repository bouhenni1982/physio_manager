import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_db_provider.dart';
import '../data/patient_details_service.dart';
import '../data/patient_repository.dart';
import '../data/patient_repository_impl.dart';
import '../domain/patient.dart';

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return SupabasePatientRepository();
});

final patientsProvider = FutureProvider<List<Patient>>((ref) {
  final repo = ref.watch(patientRepositoryProvider);
  return repo.getAll();
});

final patientDetailsServiceProvider = Provider<PatientDetailsService>((ref) {
  final db = ref.watch(localDbProvider);
  return PatientDetailsService(db);
});

final patientDetailsProvider = FutureProvider.family<PatientDetailsData?, String>((ref, patientId) {
  final service = ref.watch(patientDetailsServiceProvider);
  return service.load(patientId);
});
