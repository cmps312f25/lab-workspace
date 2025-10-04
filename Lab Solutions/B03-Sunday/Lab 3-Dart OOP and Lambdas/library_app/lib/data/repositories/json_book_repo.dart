import 'dart:convert';
import 'dart:io';

import 'package:library_app/domain/contract/book_repo.dart';
import 'package:library_app/domain/entities/book.dart';

class JsonBookRepo implements BookRepo {
  List<Book> _books = [];

  // initialize the books
  JsonBookRepo() {
    initBooksFromJson();
  }
  void initBooksFromJson() {
    // open the file
    File file = File("assets/data/books.json");
    String content = file.readAsStringSync();

    // convert this content into object
    List<dynamic> jsonBooks = jsonDecode(content);
    _books = jsonBooks.map((bookJson) => Book.fromJSON(bookJson)).toList();
  }

  void writeBooksToJson() {
    List<dynamic> jsonBooks = _books.map((book) => book.toJSON()).toList();
    String content = jsonEncode(jsonBooks);
    // open the file
    File file = File("assets/data/books.json");
    file.writeAsStringSync(content);
  }

  @override
  List<Book> getBooks() {
    return _books;
  }

  @override
  void addBook(Book book) {
    _books.add(book);
  }

  @override
  void updateBook(Book book) {
    // You should also
  }

  @override
  void deleteBook(String name) {
    //  You should solve it
  }
}
