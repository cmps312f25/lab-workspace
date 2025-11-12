import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:book_management_app/features/dashboard/domain/contracts/book_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/book.dart';
import 'package:dio/dio.dart';

/// Book Repository implementation
/// Currently reads from JSON file - you'll switch to API calls
class BookRepoApi implements BookRepository {
  final Dio _dio;
  static const String _baseUrl =
      'https://cmps312-books-api.vercel.app/api/books';

  BookRepoApi(this._dio);

  // In-memory storage for JSON-based implementation
  List<Book> _books = [];
  int _nextId = 1;

  /// Load books from JSON file
  Future<void> _loadBooks() async {
    if (_books.isEmpty) {
      final String jsonString = await rootBundle.loadString(
        'assets/data/books.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      _books = jsonList.map((json) => Book.fromJson(json)).toList();
      _nextId = _books.isEmpty
          ? 1
          : _books.map((b) => b.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  Future<List<Book>> getBooks() async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadBooks();
    return _books;

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<Book?> getBookById(int id) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadBooks();
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<List<Book>> getBooksByCategory(int categoryId) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadBooks();
    return _books.where((book) => book.categoryId == categoryId).toList();

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<void> addBook(Book book) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadBooks();
    final newBook = Book(
      id: _nextId++,
      title: book.title,
      author: book.author,
      year: book.year,
      categoryId: book.categoryId,
    );
    _books.add(newBook);

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<void> updateBook(Book book) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadBooks();
    if (book.id == null) {
      throw Exception('Book ID is required for update');
    }

    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _books[index] = book;
    }

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<void> deleteBook(Book book) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadBooks();
    if (book.id == null) {
      throw Exception('Book ID is required for deletion');
    }

    _books.removeWhere((b) => b.id == book.id);

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }
}
