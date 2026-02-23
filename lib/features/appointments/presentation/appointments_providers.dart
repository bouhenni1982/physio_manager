import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/appointment_repository.dart';
import '../data/appointment_repository_impl.dart';
import '../domain/appointment.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return SupabaseAppointmentRepository();
});

final appointmentsForDayProvider = FutureProvider.family<List<Appointment>, DateTime>((ref, day) {
  final repo = ref.watch(appointmentRepositoryProvider);
  return repo.getForDay(day);
});

final selectedAppointmentsDayProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
