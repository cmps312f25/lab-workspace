import '../../../borrowing/domain/entities/borrowed_item.dart';
import '../../../library_items/domain/entities/library_item.dart';

abstract class Member {
  final String memberId;
  final String name;
  final String email;
  final DateTime joinDate;
  final List<BorrowedItem> borrowedItems;
  final int maxBorrowLimit;
  final int borrowPeriod; // in days
  final String? profileImageUrl;

  Member({
    required this.memberId,
    required this.name,
    required this.email,
    required this.joinDate,
    required this.maxBorrowLimit,
    required this.borrowPeriod,
    this.profileImageUrl,
    List<BorrowedItem>? borrowedItems,
  }) : borrowedItems = borrowedItems ?? [];

  /// Abstract method to get member type
  String getMemberType();

  /// Validates borrowing eligibility
  /// Checks availability, limits, and restrictions
  bool canBorrowItem(LibraryItem item) {
    // Check if item is available
    if (!item.isAvailable) return false;

    // Check current borrow limit
    final currentBorrowed =
        borrowedItems.where((bi) => !bi.isReturned).length;
    if (currentBorrowed >= maxBorrowLimit) return false;

    return true;
  }

  /// Returns all borrowed items (current and past)
  List<BorrowedItem> getBorrowingHistory() => borrowedItems;

  /// Returns currently overdue items
  List<BorrowedItem> getOverdueItems() =>
      borrowedItems.where((item) => item.isOverdue()).toList();

  /// Returns formatted summary with statistics
  String getMembershipSummary() {
    final currentBorrowed =
        borrowedItems.where((item) => !item.isReturned).length;
    final totalBorrowed = borrowedItems.length;
    final overdueCount = getOverdueItems().length;

    return '''
Member: $name ($getMemberType())
Member ID: $memberId
Email: $email
Join Date: ${joinDate.toString().split(' ')[0]}
Current Borrowed: $currentBorrowed / $maxBorrowLimit
Total Borrowed: $totalBorrowed
Overdue Items: $overdueCount
Borrow Period: $borrowPeriod days
    '''.trim();
  }

  @override
  String toString() =>
      'Member(id: $memberId, name: $name, type: ${getMemberType()})';
}
