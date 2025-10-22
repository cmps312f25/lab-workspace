import 'package:floor/floor.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

abstract class BookDao {
  Stream<List<Book>> getBooks();

  Future<void> addBook(Book book);

  Future<void> deleteBook(Book book);

  Future<Book?> getBookById(int id);

  Future<void> updateBook(Book book);

  Future<void> upsertBook(Book book);

  Future<void> insertBooks(List<Book> books);

  Future<void> deleteAllBooks();

  Future<List<Book?>> getBooksByCategory(int categoryId);
}
