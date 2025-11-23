import '../entities/transaction.dart';

abstract class TransactionRepository {
  // ==================== Future-based methods (for JSON repos) ====================

  /// Get all transactions (one-time fetch)
  Future<List<Transaction>> getAllTransactions();

  /// Get a specific transaction by ID (one-time fetch)
  Future<Transaction> getTransaction(String transactionId);

  /// Get all transactions for a member (one-time fetch)
  Future<List<Transaction>> getTransactionsByMember(String memberId);

  /// Get all transactions for a book (one-time fetch)
  Future<List<Transaction>> getTransactionsByBook(String bookId);

  /// Get active (not returned) transactions (one-time fetch)
  Future<List<Transaction>> getActiveTransactions();

  /// Get overdue transactions (one-time fetch)
  Future<List<Transaction>> getOverdueTransactions();

  // ==================== Stream-based methods (for DB repos) ====================

  /// Watch all transactions (reactive - auto-updates UI)
  Stream<List<Transaction>> watchAllTransactions();

  /// Watch a specific transaction by ID (reactive - auto-updates UI)
  Stream<Transaction?> watchTransaction(String transactionId);

  /// Watch transactions for a specific member (reactive - auto-updates UI)
  Stream<List<Transaction>> watchTransactionsByMember(String memberId);

  /// Watch transactions for a specific book (reactive - auto-updates UI)
  Stream<List<Transaction>> watchTransactionsByBook(String bookId);

  /// Watch active (not returned) transactions (reactive - auto-updates UI)
  Stream<List<Transaction>> watchActiveTransactions();

  /// Watch overdue transactions (reactive - auto-updates UI)
  Stream<List<Transaction>> watchOverdueTransactions();

  // ==================== CRUD operations ====================

  /// Add a new transaction (borrow)
  Future<void> addTransaction(Transaction transaction);

  /// Update an existing transaction
  Future<void> updateTransaction(Transaction transaction);

  /// Delete a transaction
  Future<void> deleteTransaction(String transactionId);
}
