// what the app should do not how it should do it
import 'package:library_app/domain/entities/book.dart';

abstract class BookRepo {
  List<Book> getBooks();
  Book getBook(String name);
  String deleteBook(String name);

  void addBook(Book book);
  void updateBook(Book book);
}
