import '../../../library_items/domain/entities/library_item.dart';
import '../contracts/payable.dart';
import 'member.dart';

class StudentMember extends Member implements Payable {
  final String studentId;
  double _outstandingFees = 0.0;

  StudentMember({
    required super.memberId,
    required super.name,
    required super.email,
    required super.joinDate,
    super.profileImageUrl,
    super.borrowedItems,
    required this.studentId,
  }) : super(
          maxBorrowLimit: 5,
          borrowPeriod: 14,
        );

  @override
  String getMemberType() => 'Student';

  @override
  bool canBorrowItem(LibraryItem item) {
    // Student-specific restrictions can be added here
    return super.canBorrowItem(item);
  }

  @override
  double calculateFees() {
    // Calculate fees from overdue items
    // QR 2 per day late fee, maximum QR 50 per item
    _outstandingFees = 0.0;
    for (final borrowedItem in getOverdueItems()) {
      final fee = borrowedItem.calculateLateFee();
      _outstandingFees += fee > 50 ? 50 : fee; // Max QR 50 per item
    }
    return _outstandingFees;
  }

  @override
  bool payFees(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Payment amount must be positive');
    }

    final totalFees = calculateFees();
    if (amount < totalFees) {
      // Partial payment
      _outstandingFees -= amount;
      return false; // Not fully paid
    }

    _outstandingFees = 0.0;
    return true; // Fully paid
  }

  factory StudentMember.fromJson(Map<String, dynamic> json) {
    return StudentMember(
      memberId: json['memberId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      studentId: json['studentId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'type': 'StudentMember',
        'name': name,
        'email': email,
        'joinDate': joinDate.toIso8601String(),
        'profileImageUrl': profileImageUrl,
        'studentId': studentId,
      };
}
