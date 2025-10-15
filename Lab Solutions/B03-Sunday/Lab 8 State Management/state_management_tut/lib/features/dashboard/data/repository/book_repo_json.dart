import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/book_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

/// Repository implementation that loads books from a JSON asset file
class BookRepoJson implements BookRepository {
  /// Cache to store loaded books for synchronous access
  static List<Book>? _cachedBooks;

  /// Loads books from JSON asset and caches them for synchronous access
  /// Must be called before using getBooks()
  static Future<void> initialize() async {
    if (_cachedBooks == null) {
      // Load JSON content from assets
      final content = await rootBundle.loadString('assets/data/books.json');
      final List<dynamic> booksMap = jsonDecode(content);
      // Convert JSON data to Book objects and cache
      _cachedBooks = booksMap.map((book) => Book.fromJson(book)).toList();
    }
  }

  /// Returns cached books synchronously
  /// Throws StateError if initialize() hasn't been called first
  @override
  List<Book> getBooks() {
    if (_cachedBooks == null) {
      throw StateError(
        'BookRepoJson not initialized. Call BookRepoJson.initialize() first.',
      );
    }
    // Return a copy to prevent external modifications
    return List.from(_cachedBooks!);
  }

  /// Adds a new book to the repository
  @override
  Future<void> addBook(Book book) {
    // TODO: implement addBook
    throw UnimplementedError();
  }

  /// Deletes a book by its ID
  @override
  Future<void> deleteBook(int id) {
    // TODO: implement deleteBook
    throw UnimplementedError();
  }

  /// Retrieves a specific book by its ID
  @override
  Future<Book> getBookById(int id) {
    // TODO: implement getBookById
    throw UnimplementedError();
  }

  /// Updates an existing book
  @override
  Future<void> updateBook(Book book) {
    // TODO: implement updateBook
    throw UnimplementedError();
  }
}
