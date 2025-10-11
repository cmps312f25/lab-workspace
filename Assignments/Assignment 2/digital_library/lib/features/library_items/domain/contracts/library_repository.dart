import '../entities/library_item.dart';

abstract class LibraryRepository {
  /// Get all library items
  Future<List<LibraryItem>> getAllItems();

  /// Get a specific item by ID
  /// Throws exception if not found
  Future<LibraryItem> getItem(String id);

  /// Search items by query
  /// Searches title, authors, description
  Future<List<LibraryItem>> searchItems(String query);

  /// Get items by category
  Future<List<LibraryItem>> getItemsByCategory(String category);

  /// Get only available items
  Future<List<LibraryItem>> getAvailableItems();

  /// Get items by author ID
  Future<List<LibraryItem>> getItemsByAuthor(String authorId);
}
