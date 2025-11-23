import '../entities/book.dart';

abstract class LibraryRepository {
  // ==================== Future-based methods (for JSON repos) ====================

  /// Get all books (one-time fetch)
  Future<List<Book>> getAllItems();

  /// Get a specific book by ID (one-time fetch)
  /// Throws exception if not found
  Future<Book> getItem(String id);

  /// Search books by query (one-time fetch)
  /// Searches title and description
  Future<List<Book>> searchItems(String query);

  /// Get books by category (one-time fetch)
  Future<List<Book>> getItemsByCategory(String category);

  /// Get only available books (one-time fetch)
  Future<List<Book>> getAvailableItems();

  /// Get books by author ID (one-time fetch)
  Future<List<Book>> getItemsByAuthor(String authorId);

  // ==================== Stream-based methods (for DB repos) ====================

  /// Watch all books (reactive - auto-updates UI)
  Stream<List<Book>> watchAllItems();

  /// Watch a specific book by ID (reactive - auto-updates UI)
  Stream<Book?> watchItem(String id);

  /// Watch books filtered by search query (reactive - auto-updates UI)
  Stream<List<Book>> watchSearchResults(String query);

  /// Watch books by category (reactive - auto-updates UI)
  Stream<List<Book>> watchItemsByCategory(String category);

  /// Watch only available books (reactive - auto-updates UI)
  Stream<List<Book>> watchAvailableItems();

  /// Watch books by author ID (reactive - auto-updates UI)
  Stream<List<Book>> watchItemsByAuthor(String authorId);

  // ==================== CRUD operations ====================

  /// Add a new book
  Future<void> addItem(Book book);

  /// Update an existing book
  Future<void> updateItem(Book book);

  /// Delete a book
  Future<void> deleteItem(String id);

  /// Update book availability
  Future<void> updateBookAvailability(String bookId, bool isAvailable);
}
