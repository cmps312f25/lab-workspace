import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repo_providers.dart';
import '../../domain/contracts/library_repository.dart';
import '../../domain/entities/book.dart';

/// State class to hold library items (books) data
class LibraryItemsState {
  final List<Book> items;
  final String searchQuery;

  LibraryItemsState({
    required this.items,
    this.searchQuery = '',
  });

  LibraryItemsState copyWith({
    List<Book>? items,
    String? searchQuery,
  }) {
    return LibraryItemsState(
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Notifier for managing library items state
class LibraryItemsNotifier extends AsyncNotifier<LibraryItemsState> {
  late final LibraryRepository _libraryRepo;
  StreamSubscription<List<Book>>? _subscription;

  @override
  Future<LibraryItemsState> build() async {
    // Get the repository from the provider
    _libraryRepo = await ref.read(libraryRepoProvider.future);

    // Subscribe to library items stream for reactive updates
    _subscription = _libraryRepo.watchAllItems().listen((items) {
      state = AsyncValue.data(
        LibraryItemsState(
          items: items,
          searchQuery: state.value?.searchQuery ?? '',
        ),
      );
    });

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Return initial empty state
    return LibraryItemsState(items: []);
  }

  /// Search library items by query
  Future<void> searchItems(String query) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final items = query.isEmpty
          ? await _libraryRepo.getAllItems()
          : await _libraryRepo.searchItems(query);

      return LibraryItemsState(
        items: items,
        searchQuery: query,
      );
    });
  }

  /// Get a specific book by ID
  Future<Book?> getItem(String id) async {
    try {
      return await _libraryRepo.getItem(id);
    } catch (e) {
      return null;
    }
  }

  /// Get items by category
  Future<void> filterByCategory(String category) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final items = await _libraryRepo.getItemsByCategory(category);
      return LibraryItemsState(items: items);
    });
  }

  /// Get available items
  Future<void> getAvailableItems() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final items = await _libraryRepo.getAvailableItems();
      return LibraryItemsState(items: items);
    });
  }

  /// Refresh library items
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final items = await _libraryRepo.getAllItems();
      return LibraryItemsState(items: items);
    });
  }
}

/// Provider for library items notifier
final libraryItemsProvider = AsyncNotifierProvider<LibraryItemsNotifier, LibraryItemsState>(
  () => LibraryItemsNotifier(),
);
