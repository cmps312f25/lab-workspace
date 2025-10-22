import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

abstract class BookRepository {
  Stream<List<Book>> getBooks();
  Future<Book?> getBookById(int id);
  Future<void> addBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(Book book);
  Future<List<Book?>> getBooksByCategory(int categoryId);
}
