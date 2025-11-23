import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/contracts/transaction_repository.dart';
import '../../domain/entities/transaction.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  List<Transaction>? _transactions;

  /// Load transactions from JSON file
  Future<List<Transaction>> _loadTransactions() async {
    if (_transactions != null) return _transactions!;

    try {
      final String transactionsJson =
          await rootBundle.loadString('assets/data/transactions.json');
      final List<dynamic> transactionsData = json.decode(transactionsJson);

      _transactions = transactionsData
          .map((transactionJson) => Transaction.fromJson(transactionJson))
          .toList();

      return _transactions!;
    } catch (e) {
      // If file doesn't exist, start with empty list
      _transactions = [];
      return _transactions!;
    }
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return await _loadTransactions();
  }

  @override
  Future<Transaction> getTransaction(String transactionId) async {
    final transactions = await _loadTransactions();
    try {
      return transactions.firstWhere((t) => t.id == transactionId);
    } catch (e) {
      throw Exception('Transaction with ID $transactionId not found');
    }
  }

  @override
  Future<List<Transaction>> getTransactionsByMember(String memberId) async {
    final transactions = await _loadTransactions();
    return transactions.where((t) => t.memberId == memberId).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByBook(String bookId) async {
    final transactions = await _loadTransactions();
    return transactions.where((t) => t.bookId == bookId).toList();
  }

  @override
  Future<List<Transaction>> getActiveTransactions() async {
    final transactions = await _loadTransactions();
    return transactions.where((t) => !t.isReturned).toList();
  }

  @override
  Future<List<Transaction>> getOverdueTransactions() async {
    final transactions = await _loadTransactions();
    return transactions.where((t) => t.isOverdue()).toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final transactions = await _loadTransactions();

    // Validate unique ID
    if (transactions.any((t) => t.id == transaction.id)) {
      throw Exception('Transaction with ID ${transaction.id} already exists');
    }

    _transactions!.add(transaction);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final transactions = await _loadTransactions();
    final index = transactions.indexWhere((t) => t.id == transaction.id);

    if (index == -1) {
      throw Exception('Transaction with ID ${transaction.id} not found');
    }

    _transactions![index] = transaction;
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    final transactions = await _loadTransactions();
    final index = transactions.indexWhere((t) => t.id == transactionId);

    if (index == -1) {
      throw Exception('Transaction with ID $transactionId not found');
    }

    _transactions!.removeAt(index);
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Transaction>> watchAllTransactions() async* {
    yield await getAllTransactions();
  }

  @override
  Stream<Transaction?> watchTransaction(String transactionId) async* {
    try {
      yield await getTransaction(transactionId);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Transaction>> watchTransactionsByMember(String memberId) async* {
    yield await getTransactionsByMember(memberId);
  }

  @override
  Stream<List<Transaction>> watchTransactionsByBook(String bookId) async* {
    yield await getTransactionsByBook(bookId);
  }

  @override
  Stream<List<Transaction>> watchActiveTransactions() async* {
    yield await getActiveTransactions();
  }

  @override
  Stream<List<Transaction>> watchOverdueTransactions() async* {
    yield await getOverdueTransactions();
  }

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    _transactions = null;
  }
}
