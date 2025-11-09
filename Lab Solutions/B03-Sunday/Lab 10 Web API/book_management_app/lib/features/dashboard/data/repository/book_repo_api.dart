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

  @override
  Future<List<Book>> getBooks() async {
    final response = await _dio.get(_baseUrl);
    // check if we have good response
    if (response.statusCode != 200) {
      throw ("Error happened");
    }

    final List<dynamic> booksMap = response.data;

    final books = booksMap.map((json) => Book.fromJson(json)).toList();

    return books;
  }

  @override
  Future<Book?> getBookById(int id) async {
    final response = await _dio.get('$_baseUrl/$id');

    if (response.statusCode != 200) {
      throw ("Error happened");
    }

    return Book.fromJson(response.data);
  }

  @override
  Future<List<Book>> getBooksByCategory(int categoryId) async {
    final response = await _dio.get('$_baseUrl?categoryId=$categoryId');
    // check if we have good response
    if (response.statusCode != 200) {
      throw ("Error happened");
    }

    final List<dynamic> booksMap = response.data;

    final books = booksMap.map((json) => Book.fromJson(json)).toList();

    return books;
  }

  @override
  Future<void> addBook(Book book) async {
    final response = await _dio.post(_baseUrl, data: book.toJson());
    // check if we have good response
    if (response.statusCode != 201) {
      throw ("Error happened");
    }
  }

  @override
  Future<void> updateBook(Book book) async {
    final response = await _dio.put(
      '$_baseUrl/${book.id}',
      data: book.toJson(),
    );

    if (response.statusCode != 200) {
      throw ("Error happened");
    }
  }

  @override
  Future<void> deleteBook(Book book) async {
    final response = await _dio.delete('$_baseUrl/${book.id}');

    if (response.statusCode != 200) {
      // handle error appropriately with better message
      throw ("Error happened");
    }
  }
}
