import '../domain/patient.dart';

abstract class PatientRepository {
  Future<List<Patient>> getAll();
  Future<Patient> create(Patient patient);
  Future<void> update(Patient patient);
  Future<void> delete(String id);
}
