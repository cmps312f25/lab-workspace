import 'package:my_library/domain/entities/book.dart';

abstract class BookRepo {
  List<Book> getBooks();
  void addBook(Book book);
  void updateBook(Book book);
  void deleteBook(String name);
}
