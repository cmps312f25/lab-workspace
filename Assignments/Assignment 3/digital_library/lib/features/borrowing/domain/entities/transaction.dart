// TODO: Add Floor annotations when implementing database
// @entity
class Transaction {
  // @primaryKey
  final String id;

  final String memberId;
  final String bookId;
  final DateTime borrowDate;
  DateTime dueDate;
  DateTime? returnDate;
  bool isReturned;

  Transaction({
    required this.id,
    required this.memberId,
    required this.bookId,
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

  /// Creates a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      bookId: json['bookId'] as String,
      borrowDate: DateTime.parse(json['borrowDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      returnDate: json['returnDate'] != null
          ? DateTime.parse(json['returnDate'] as String)
          : null,
      isReturned: json['isReturned'] as bool? ?? false,
    );
  }

  /// Converts Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'bookId': bookId,
      'borrowDate': borrowDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'isReturned': isReturned,
    };
  }

  @override
  String toString() {
    return 'Transaction(id: $id, memberId: $memberId, bookId: $bookId, borrowDate: $borrowDate, dueDate: $dueDate, isReturned: $isReturned, overdue: ${isOverdue()})';
  }
}
