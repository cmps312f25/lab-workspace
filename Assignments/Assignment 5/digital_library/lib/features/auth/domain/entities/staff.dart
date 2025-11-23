class Staff {
  final String staffId;
  final String username;
  final String password;
  final String fullName;
  final String role;

  Staff({
    required this.staffId,
    required this.username,
    required this.password,
    required this.fullName,
    required this.role,
  });

  /// Create Staff from JSON (supports both camelCase and snake_case)
  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      staffId: json['staffId'] ?? json['staff_id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] ?? json['full_name'] as String,
      role: json['role'] as String,
    );
  }

  /// Convert Staff to JSON (snake_case for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'staff_id': staffId,
      'username': username,
      'password': password,
      'full_name': fullName,
      'role': role,
    };
  }
}
