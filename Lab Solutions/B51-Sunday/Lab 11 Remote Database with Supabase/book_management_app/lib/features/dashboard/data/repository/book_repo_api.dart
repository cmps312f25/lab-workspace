import 'package:book_management_app/features/dashboard/domain/contracts/book_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/book.dart';
import 'package:dio/dio.dart';

class BookRepoApi implements BookRepository {
  final Dio _dio;
  static const String _baseUrl =
      'https://cmps312-books-api.vercel.app/api/books';

  BookRepoApi(this._dio);

  @override
  Future<List<Book>> getBooks() async {
    try {
      final response = await _dio.get(_baseUrl);
      final List<dynamic> data = response.data as List;
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }

  @override
  Future<Book?> getBookById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');
      return Book.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Book>> getBooksByCategory(int categoryId) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'categoryId': categoryId},
      );
      final List<dynamic> data = response.data as List;
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch books by category: $e');
    }
  }

  @override
  Future<void> addBook(Book book) async {
    try {
      await _dio.post(_baseUrl, data: book.toJson());
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  @override
  Future<void> updateBook(Book book) async {
    if (book.id == null) {
      throw Exception('Book ID is required for update');
    }

    try {
      await _dio.put('$_baseUrl/${book.id}', data: book.toJson());
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  @override
  Future<void> deleteBook(Book book) async {
    if (book.id == null) {
      throw Exception('Book ID is required for deletion');
    }

    try {
      await _dio.delete('$_baseUrl/${book.id}');
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }
}
