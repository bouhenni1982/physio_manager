enum UserRole { admin, therapist }

extension UserRoleX on UserRole {
  String get value {
    return switch (this) {
      UserRole.admin => 'admin',
      UserRole.therapist => 'therapist',
    };
  }

  static UserRole fromValue(String value) {
    return value == 'admin' ? UserRole.admin : UserRole.therapist;
  }
}
