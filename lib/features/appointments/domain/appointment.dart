class Appointment {
  final String id;
  final String patientId;
  final String therapistId;
  final DateTime scheduledAt;
  final String status;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.therapistId,
    required this.scheduledAt,
    required this.status,
  });
}
