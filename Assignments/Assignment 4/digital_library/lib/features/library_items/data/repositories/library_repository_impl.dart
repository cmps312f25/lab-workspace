import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../../domain/contracts/library_repository.dart';
import '../../domain/entities/book.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final Dio _dio;

  // In-memory storage - loaded once from JSON and then modified in memory
  List<Book>? _cachedBooks;

  LibraryRepositoryImpl(this._dio);

  Future<List<Book>> _loadBooksFromJson() async {
    // Return cached data if already loaded
    if (_cachedBooks != null) {
      return _cachedBooks!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/library_catalog_json.json');
      final List<dynamic> data = json.decode(jsonString) as List;
      _cachedBooks = data.map((json) => Book.fromJson(json)).toList();
      return _cachedBooks!;
    } catch (e) {
      throw Exception('Failed to load books from JSON: $e');
    }
  }

  @override
  Future<List<Book>> getAllItems() async {
    try {
      return await _loadBooksFromJson();
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }

  @override
  Future<Book> getItem(String id) async {
    try {
      final books = await _loadBooksFromJson();
      final book = books.firstWhere(
        (book) => book.id == id,
        orElse: () => throw Exception('Book with ID $id not found'),
      );
      return book;
    } catch (e) {
      throw Exception('Failed to fetch book: $e');
    }
  }

  @override
  Future<List<Book>> searchItems(String query) async {
    try {
      final books = await _loadBooksFromJson();

      final lowerQuery = query.toLowerCase();
      return books.where((book) {
        // Search in title
        if (book.title.toLowerCase().contains(lowerQuery)) return true;

        // Search in description
        if (book.description != null &&
            book.description!.toLowerCase().contains(lowerQuery)) {
          return true;
        }

        return false;
      }).toList();
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  @override
  Future<List<Book>> getItemsByCategory(String category) async {
    try {
      final books = await _loadBooksFromJson();

      final lowerCategory = category.toLowerCase();
      return books
          .where((book) => book.category.toLowerCase() == lowerCategory)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch books by category: $e');
    }
  }

  @override
  Future<List<Book>> getAvailableItems() async {
    try {
      final books = await _loadBooksFromJson();

      return books.where((book) => book.isAvailable).toList();
    } catch (e) {
      throw Exception('Failed to fetch available books: $e');
    }
  }

  @override
  Future<List<Book>> getItemsByAuthor(String authorId) async {
    try {
      final books = await _loadBooksFromJson();

      return books.where((book) => book.authorId == authorId).toList();
    } catch (e) {
      throw Exception('Failed to fetch books by author: $e');
    }
  }

  @override
  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    try {
      final books = await _loadBooksFromJson();
      final index = books.indexWhere((b) => b.id == bookId);

      if (index == -1) {
        throw Exception('Book with ID $bookId not found');
      }

      // Update the book's availability
      final book = books[index];
      books[index] = Book(
        id: book.id,
        title: book.title,
        authorId: book.authorId,
        isbn: book.isbn,
        category: book.category,
        publishedYear: book.publishedYear,
        pageCount: book.pageCount,
        publisher: book.publisher,
        isAvailable: isAvailable,
        description: book.description,
        coverImageUrl: book.coverImageUrl,
      );

      _cachedBooks = books;
    } catch (e) {
      throw Exception('Failed to update book availability: $e');
    }
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

  // ==================== CRUD operations (In-Memory) ====================

  @override
  Future<void> addItem(Book book) async {
    try {
      final books = await _loadBooksFromJson();
      books.add(book);
      _cachedBooks = books;
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  @override
  Future<void> updateItem(Book book) async {
    try {
      final books = await _loadBooksFromJson();
      final index = books.indexWhere((b) => b.id == book.id);

      if (index == -1) {
        throw Exception('Book with ID ${book.id} not found');
      }

      books[index] = book;
      _cachedBooks = books;
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      final books = await _loadBooksFromJson();
      final initialLength = books.length;
      books.removeWhere((b) => b.id == id);

      if (books.length == initialLength) {
        throw Exception('Book with ID $id not found');
      }

      _cachedBooks = books;
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }
}
