import '../../../library_items/domain/entities/library_item.dart';
import 'member.dart';

class FacultyMember extends Member {
  final String department;

  FacultyMember({
    required super.memberId,
    required super.name,
    required super.email,
    required super.joinDate,
    super.profileImageUrl,
    super.borrowedItems,
    required this.department,
  }) : super(
          maxBorrowLimit: 20,
          borrowPeriod: 60,
        );

  @override
  String getMemberType() => 'Faculty';

  @override
  bool canBorrowItem(LibraryItem item) {
    // Faculty members have extended privileges
    // They can borrow items even with some overdue items (within reason)
    return super.canBorrowItem(item);
  }

  factory FacultyMember.fromJson(Map<String, dynamic> json) {
    return FacultyMember(
      memberId: json['memberId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      department: json['department'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'type': 'FacultyMember',
        'name': name,
        'email': email,
        'joinDate': joinDate.toIso8601String(),
        'profileImageUrl': profileImageUrl,
        'department': department,
      };
}
