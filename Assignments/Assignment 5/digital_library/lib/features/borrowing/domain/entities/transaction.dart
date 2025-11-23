class Transaction {
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

  /// Computes fee based on overdue days - QR 2 per day late fee
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

  /// Creates a Transaction from JSON (supports both camelCase and snake_case)
  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Parse dates from various formats
    final borrowDateStr = json['borrowDate'] ?? json['borrow_date'];
    final dueDateStr = json['dueDate'] ?? json['due_date'];
    final returnDateStr = json['returnDate'] ?? json['return_date'];

    return Transaction(
      id: json['id'] as String,
      memberId: json['memberId'] ?? json['member_id'] as String,
      bookId: json['bookId'] ?? json['book_id'] as String,
      borrowDate: DateTime.parse(borrowDateStr as String),
      dueDate: DateTime.parse(dueDateStr as String),
      returnDate: returnDateStr != null
          ? DateTime.parse(returnDateStr as String)
          : null,
      isReturned: json['isReturned'] ?? json['is_returned'] as bool? ?? false,
    );
  }

  /// Converts Transaction to JSON (snake_case for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'book_id': bookId,
      'borrow_date': borrowDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'return_date': returnDate?.toIso8601String(),
      'is_returned': isReturned,
    };
  }

  @override
  String toString() {
    return 'Transaction(id: $id, memberId: $memberId, bookId: $bookId, borrowDate: $borrowDate, dueDate: $dueDate, isReturned: $isReturned, overdue: ${isOverdue()})';
  }
}
