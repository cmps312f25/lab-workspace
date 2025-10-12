import '../../../../core/domain/enums/user_role.dart';

abstract class User {
  final String id;
  final UserRole role;
  final String name;
  final String email;
  final String password;
  final String? avatarUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
