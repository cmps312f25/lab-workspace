import '../../../library_items/domain/entities/library_item.dart';

class BorrowedItem {
  final LibraryItem item;
  final DateTime borrowDate;
  DateTime dueDate;
  DateTime? returnDate;
  bool isReturned;

  BorrowedItem({
    required this.item,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.isReturned = false,
  });

  /// Checks if past due date and not returned
  bool isOverdue() {
    if (isReturned) return false;
    return DateTime.now().isAfter(dueDate);
  }

  /// Calculates overdue days, returns 0 if not overdue
  int getDaysOverdue() {
    if (!isOverdue()) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  /// Computes fee based on overdue days
  /// QR 2 per day late fee
  double calculateLateFee() {
    final daysOverdue = getDaysOverdue();
    return daysOverdue * 2.0;
  }

  /// Extends due date if allowed
  void extendDueDate(int additionalDays) {
    if (isReturned) {
      throw StateError('Cannot extend due date for returned item');
    }
    dueDate = dueDate.add(Duration(days: additionalDays));
  }

  /// Marks as returned with current timestamp
  void processReturn() {
    if (isReturned) {
      throw StateError('Item already returned');
    }
    returnDate = DateTime.now();
    isReturned = true;
  }

  @override
  String toString() {
    return 'BorrowedItem(item: ${item.title}, borrowDate: $borrowDate, dueDate: $dueDate, isReturned: $isReturned, overdue: ${isOverdue()})';
  }
}
