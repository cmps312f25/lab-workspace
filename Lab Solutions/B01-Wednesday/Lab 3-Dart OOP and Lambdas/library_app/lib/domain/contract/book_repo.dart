import 'package:library_app/domain/entities/book.dart';

// What needs to be done
abstract class BookRepo {
  List<Book> getBooks();
  void addBook(Book book);
  void updateBook(String name, Book updatedBook);
  void deleteBook(String name);
  Book getBookByTitle(String name);
}
