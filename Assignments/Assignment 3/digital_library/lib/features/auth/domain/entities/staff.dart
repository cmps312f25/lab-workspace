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

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      staffId: json['staffId'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'username': username,
      'password': password,
      'fullName': fullName,
      'role': role,
    };
  }
}
