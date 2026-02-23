class Therapist {
  final String id;
  final String userId;
  final String fullName;
  final String? phone;
  final bool isPrimary;

  const Therapist({
    required this.id,
    required this.userId,
    required this.fullName,
    this.phone,
    required this.isPrimary,
  });
}
