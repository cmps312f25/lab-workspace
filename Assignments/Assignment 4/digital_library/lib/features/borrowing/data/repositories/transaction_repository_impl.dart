import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../../domain/contracts/transaction_repository.dart';
import '../../domain/entities/transaction.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final Dio _dio;

  // In-memory storage - loaded once from JSON and then modified in memory
  List<Transaction>? _cachedTransactions;

  TransactionRepositoryImpl(this._dio);

  Future<List<Transaction>> _loadTransactionsFromJson() async {
    // Return cached data if already loaded
    if (_cachedTransactions != null) {
      return _cachedTransactions!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/transactions.json');
      final List<dynamic> data = json.decode(jsonString) as List;
      _cachedTransactions = data.map((json) => Transaction.fromJson(json)).toList();
      return _cachedTransactions!;
    } catch (e) {
      throw Exception('Failed to load transactions from JSON: $e');
    }
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    try {
      return await _loadTransactionsFromJson();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<Transaction> getTransaction(String id) async {
    try {
      final transactions = await _loadTransactionsFromJson();
      final transaction = transactions.firstWhere(
        (transaction) => transaction.id == id,
        orElse: () => throw Exception('Transaction with ID $id not found'),
      );
      return transaction;
    } catch (e) {
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  @override
  Future<List<Transaction>> getTransactionsByMember(String memberId) async {
    try {
      final transactions = await _loadTransactionsFromJson();

      return transactions.where((t) => t.memberId == memberId).toList();
    } catch (e) {
      throw Exception('Failed to fetch member transactions: $e');
    }
  }

  @override
  Future<List<Transaction>> getTransactionsByBook(String bookId) async {
    try {
      final transactions = await _loadTransactionsFromJson();

      return transactions.where((t) => t.bookId == bookId).toList();
    } catch (e) {
      throw Exception('Failed to fetch book transactions: $e');
    }
  }

  @override
  Future<List<Transaction>> getActiveTransactions() async {
    try {
      final transactions = await _loadTransactionsFromJson();

      return transactions.where((t) => !t.isReturned).toList();
    } catch (e) {
      throw Exception('Failed to fetch active transactions: $e');
    }
  }

  @override
  Future<List<Transaction>> getOverdueTransactions() async {
    try {
      final transactions = await _loadTransactionsFromJson();

      final now = DateTime.now();
      return transactions.where((t) {
        if (t.isReturned) return false;
        return t.dueDate.isBefore(now);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch overdue transactions: $e');
    }
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Transaction>> watchAllTransactions() async* {
    yield await getAllTransactions();
  }

  @override
  Stream<Transaction?> watchTransaction(String id) async* {
    try {
      yield await getTransaction(id);
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

  // ==================== CRUD operations (In-Memory) ====================

  @override
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final transactions = await _loadTransactionsFromJson();
      transactions.add(transaction);
      _cachedTransactions = transactions;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final transactions = await _loadTransactionsFromJson();
      final index = transactions.indexWhere((t) => t.id == transaction.id);

      if (index == -1) {
        throw Exception('Transaction with ID ${transaction.id} not found');
      }

      transactions[index] = transaction;
      _cachedTransactions = transactions;
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final transactions = await _loadTransactionsFromJson();
      final initialLength = transactions.length;
      transactions.removeWhere((t) => t.id == id);

      if (transactions.length == initialLength) {
        throw Exception('Transaction with ID $id not found');
      }

      _cachedTransactions = transactions;
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
