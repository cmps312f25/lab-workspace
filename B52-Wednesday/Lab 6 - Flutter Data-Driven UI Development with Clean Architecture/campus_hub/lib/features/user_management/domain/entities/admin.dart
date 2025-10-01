import 'user.dart';
import '../../../../core/domain/enums/user_role.dart';

class Admin extends User {
  final List<String> permissions;

  const Admin({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.createdAt,
    required this.permissions,
  }) : super(role: UserRole.admin);

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      permissions: List<String>.from(json['permissions'] as List? ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.value,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'permissions': permissions,
    };
  }

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  @override
  String toString() =>
      'Admin(id: $id, name: $name, permissions: ${permissions.length})';
}
