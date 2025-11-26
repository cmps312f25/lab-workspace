/// User entity representing an authenticated user in the chat app.
/// This maps to the `profiles` table in Supabase.
class AppUser {
  final String id; // UUID from Supabase Auth
  final String email;
  final String? displayName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.createdAt,
    this.updatedAt,
  });

  /// Create AppUser from JSON (Supabase response)
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert AppUser to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
    };
  }

  /// Create a copy with updated fields
  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'AppUser(id: $id, email: $email, displayName: $displayName)';
  }
}
