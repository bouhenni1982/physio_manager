import '../domain/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getForDay(DateTime day);
  Future<Appointment> create(Appointment appointment);
  Future<void> update(Appointment appointment);
  Future<void> delete(String id);
}
