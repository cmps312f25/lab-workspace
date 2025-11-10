import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/contracts/library_repository.dart';
import '../../domain/entities/book.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  List<Book>? _books;

  /// Load library items from JSON file
  Future<List<Book>> _loadBooks() async {
    if (_books != null) return _books!;

    try {
      // Load library catalog
      final String catalogJson =
          await rootBundle.loadString('assets/data/library_catalog_json.json');
      final List<dynamic> catalogData = json.decode(catalogJson);

      // Create Book entities (only Books are supported)
      _books = catalogData
          .where((itemJson) => itemJson['type'] == 'Book')
          .map((itemJson) => Book.fromJson(itemJson))
          .toList();

      return _books!;
    } catch (e) {
      throw Exception('Failed to load library items: $e');
    }
  }

  @override
  Future<List<Book>> getAllItems() async {
    return await _loadBooks();
  }

  @override
  Future<Book> getItem(String id) async {
    final books = await _loadBooks();
    try {
      return books.firstWhere((book) => book.id == id);
    } catch (e) {
      throw Exception('Book with ID $id not found');
    }
  }

  @override
  Future<List<Book>> searchItems(String query) async {
    final books = await _loadBooks();
    final lowerQuery = query.toLowerCase();

    return books.where((book) {
      // Search in title
      if (book.title.toLowerCase().contains(lowerQuery)) return true;

      // Search in description
      if (book.description != null &&
          book.description!.toLowerCase().contains(lowerQuery)) {
        return true;
      }

      // Note: To search by author name, you need to query AuthorRepository separately
      return false;
    }).toList();
  }

  @override
  Future<List<Book>> getItemsByCategory(String category) async {
    final books = await _loadBooks();
    final lowerCategory = category.toLowerCase();
    return books
        .where((book) => book.category.toLowerCase() == lowerCategory)
        .toList();
  }

  @override
  Future<List<Book>> getAvailableItems() async {
    final books = await _loadBooks();
    return books.where((book) => book.isAvailable).toList();
  }

  @override
  Future<List<Book>> getItemsByAuthor(String authorId) async {
    final books = await _loadBooks();
    return books.where((book) => book.authorId == authorId).toList();
  }

  @override
  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    final books = await _loadBooks();
    final index = books.indexWhere((book) => book.id == bookId);

    if (index == -1) {
      throw Exception('Book with ID $bookId not found');
    }

    // Update the book in the cached list
    _books![index] = books[index].copyWith(isAvailable: isAvailable);
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Book>> watchAllItems() async* {
    yield await getAllItems();
  }

  @override
  Stream<Book?> watchItem(String id) async* {
    try {
      yield await getItem(id);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Book>> watchSearchResults(String query) async* {
    yield await searchItems(query);
  }

  @override
  Stream<List<Book>> watchItemsByCategory(String category) async* {
    yield await getItemsByCategory(category);
  }

  @override
  Stream<List<Book>> watchAvailableItems() async* {
    yield await getAvailableItems();
  }

  @override
  Stream<List<Book>> watchItemsByAuthor(String authorId) async* {
    yield await getItemsByAuthor(authorId);
  }

  // ==================== CRUD operations ====================

  @override
  Future<void> addItem(Book book) async {
    final books = await _loadBooks();
    if (books.any((b) => b.id == book.id)) {
      throw Exception('Book with ID ${book.id} already exists');
    }
    _books!.add(book);
  }

  @override
  Future<void> updateItem(Book book) async {
    final books = await _loadBooks();
    final index = books.indexWhere((b) => b.id == book.id);
    if (index == -1) {
      throw Exception('Book with ID ${book.id} not found');
    }
    _books![index] = book;
  }

  @override
  Future<void> deleteItem(String id) async {
    final books = await _loadBooks();
    final index = books.indexWhere((b) => b.id == id);
    if (index == -1) {
      throw Exception('Book with ID $id not found');
    }
    _books!.removeAt(index);
  }

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    _books = null;
  }
}
