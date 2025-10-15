import 'package:state_manage_tut/features/dashboard/domain/entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks();
  Future<Book?> getBookById(String id);
  Future<void> addBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(String id);
}
