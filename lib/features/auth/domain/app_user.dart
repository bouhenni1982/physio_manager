class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.createdAt,
  });
}
