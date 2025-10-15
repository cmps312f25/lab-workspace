import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

abstract class BookRepo {
  Future<List<Book>> getBooks();
  Future<void> addBook(Book book);
  Future<void> deleteBook(Book book);
  Future<void> updateBook(Book book);
}
