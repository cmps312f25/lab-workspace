import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repo_providers.dart';
import '../../../library_items/presentation/providers/repo_providers.dart' as library_providers;
import '../../../members/presentation/providers/repo_providers.dart' as member_providers;
import '../../../library_items/domain/contracts/library_repository.dart';
import '../../../members/domain/contracts/member_repository.dart';
import '../../domain/contracts/transaction_repository.dart';
import '../../domain/entities/transaction.dart';

/// Filter options for transactions
enum TransactionFilter {
  all,
  active,
  overdue,
  completed,
}

/// State class to hold transactions data
class TransactionsState {
  final List<Transaction> transactions;
  final TransactionFilter filter;
  final String searchQuery;

  TransactionsState({
    required this.transactions,
    this.filter = TransactionFilter.all,
    this.searchQuery = '',
  });

  TransactionsState copyWith({
    List<Transaction>? transactions,
    TransactionFilter? filter,
    String? searchQuery,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Get filtered transactions based on current filter
  List<Transaction> get filteredTransactions {
    List<Transaction> filtered = transactions;

    // Apply filter
    switch (filter) {
      case TransactionFilter.active:
        filtered = filtered.where((t) => !t.isReturned).toList();
        break;
      case TransactionFilter.overdue:
        filtered = filtered.where((t) => t.isOverdue()).toList();
        break;
      case TransactionFilter.completed:
        filtered = filtered.where((t) => t.isReturned).toList();
        break;
      case TransactionFilter.all:
        break;
    }

    // Apply search query if exists
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
        t.memberId.toLowerCase().contains(searchQuery.toLowerCase()) ||
        t.bookId.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }
}

/// Notifier for managing transactions state
class TransactionsNotifier extends AsyncNotifier<TransactionsState> {
  late final TransactionRepository _transactionRepo;
  late final LibraryRepository _libraryRepo;
  late final MemberRepository _memberRepo;
  StreamSubscription<List<Transaction>>? _subscription;

  @override
  Future<TransactionsState> build() async {
    // Get repositories from providers
    _transactionRepo = await ref.read(transactionRepoProvider.future);
    _libraryRepo = await ref.read(library_providers.libraryRepoProvider.future);
    _memberRepo = await ref.read(member_providers.memberRepoProvider.future);

    // Subscribe to transactions stream for reactive updates
    _subscription = _transactionRepo.watchAllTransactions().listen((transactions) {
      state = AsyncValue.data(
        TransactionsState(
          transactions: transactions,
          filter: state.value?.filter ?? TransactionFilter.all,
          searchQuery: state.value?.searchQuery ?? '',
        ),
      );
    });

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Return initial empty state
    return TransactionsState(transactions: []);
  }

  /// Set filter
  Future<void> setFilter(TransactionFilter filter) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(filter: filter));
  }

  /// Search transactions
  Future<void> search(String query) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(searchQuery: query));
  }

  /// Borrow a book
  Future<void> borrowBook(String memberId, String bookId) async {
    try {
      // Get member and book
      final member = await _memberRepo.getMember(memberId);
      final book = await _libraryRepo.getItem(bookId);

      // Check if book is available
      if (!book.isAvailable) {
        throw Exception('Book is not available for borrowing');
      }

      // Generate new transaction ID
      final transactions = await _transactionRepo.getAllTransactions();
      final newId = 'T${(transactions.length + 1).toString().padLeft(3, '0')}';

      // Calculate due date based on member type
      final borrowPeriod = member.getBorrowPeriod();
      final dueDate = DateTime.now().add(Duration(days: borrowPeriod));

      // Create transaction
      final transaction = Transaction(
        id: newId,
        memberId: memberId,
        bookId: bookId,
        borrowDate: DateTime.now(),
        dueDate: dueDate,
        isReturned: false,
      );

      await _transactionRepo.addTransaction(transaction);

      // Update book availability
      await _libraryRepo.updateBookAvailability(bookId, false);

      // Refresh transactions list
      await refresh();
    } catch (e) {
      rethrow;
    }
  }

  /// Return a book
  Future<double> returnBook(String transactionId) async {
    try {
      // Get transaction
      final transaction = await _transactionRepo.getTransaction(transactionId);

      if (transaction.isReturned) {
        throw Exception('Book has already been returned');
      }

      // Process return
      transaction.processReturn();

      // Calculate late fee
      final lateFee = transaction.calculateLateFee();

      // Update transaction
      await _transactionRepo.updateTransaction(transaction);

      // Update book availability
      await _libraryRepo.updateBookAvailability(transaction.bookId, true);

      // Refresh transactions list
      await refresh();

      return lateFee;
    } catch (e) {
      rethrow;
    }
  }

  /// Get transaction by ID
  Future<Transaction?> getTransaction(String transactionId) async {
    try {
      return await _transactionRepo.getTransaction(transactionId);
    } catch (e) {
      return null;
    }
  }

  /// Get active transactions count
  int getActiveCount() {
    final currentState = state.value;
    if (currentState == null) return 0;
    return currentState.transactions.where((t) => !t.isReturned).length;
  }

  /// Get overdue transactions count
  int getOverdueCount() {
    final currentState = state.value;
    if (currentState == null) return 0;
    return currentState.transactions.where((t) => t.isOverdue()).length;
  }

  /// Refresh transactions list
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final transactions = await _transactionRepo.getAllTransactions();
      final currentState = state.value;

      return TransactionsState(
        transactions: transactions,
        filter: currentState?.filter ?? TransactionFilter.all,
        searchQuery: currentState?.searchQuery ?? '',
      );
    });
  }
}

/// Provider for transactions notifier
final transactionsProvider = AsyncNotifierProvider<TransactionsNotifier, TransactionsState>(
  () => TransactionsNotifier(),
);
