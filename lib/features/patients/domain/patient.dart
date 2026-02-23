class Patient {
  final String id;
  final String fullName;
  final int? age;
  final String gender;
  final String? diagnosis;
  final String? medicalHistory;
  final int? suggestedSessions;
  final String therapistId;
  final String? doctorName;
  final String? phone;
  final String? prescriptionImagePath;
  final String status;

  const Patient({
    required this.id,
    required this.fullName,
    this.age,
    required this.gender,
    this.diagnosis,
    this.medicalHistory,
    this.suggestedSessions,
    required this.therapistId,
    this.doctorName,
    this.phone,
    this.prescriptionImagePath,
    this.status = 'active',
  });
}
