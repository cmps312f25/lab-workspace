/// Flat entity - no borrowedItems list, that's in transactions table
class Member {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String memberType; // 'student' or 'faculty'
  final DateTime memberSince;
  final String? profileImageUrl;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.memberType,
    required this.memberSince,
    this.profileImageUrl,
  });

  /// Returns member type
  String getMemberType() => memberType;

  /// Get max borrow limit based on member type
  int getMaxBorrowLimit() => memberType == 'student' ? 5 : 10;

  /// Get borrow period in days based on member type
  int getBorrowPeriod() => memberType == 'student' ? 14 : 30;

  /// Create Member from JSON (supports both camelCase and snake_case)
  factory Member.fromJson(Map<String, dynamic> json) {
    // Parse memberSince from various formats
    final memberSinceStr = json['memberSince'] ?? json['member_since'] ?? json['joinDate'];

    return Member(
      id: json['id'] ?? json['memberId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] ?? '',
      memberType: json['memberType'] ?? json['member_type'] ?? 'student',
      memberSince: DateTime.parse(memberSinceStr as String),
      profileImageUrl: json['profileImageUrl'] ?? json['profile_image_url'] as String?,
    );
  }

  /// Convert Member to JSON (snake_case for Supabase)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'member_type': memberType,
        'member_since': memberSince.toIso8601String(),
        'profile_image_url': profileImageUrl,
      };

  Member copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? memberType,
    DateTime? memberSince,
    String? profileImageUrl,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      memberType: memberType ?? this.memberType,
      memberSince: memberSince ?? this.memberSince,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  String toString() => 'Member(id: $id, name: $name, type: $memberType)';
}
