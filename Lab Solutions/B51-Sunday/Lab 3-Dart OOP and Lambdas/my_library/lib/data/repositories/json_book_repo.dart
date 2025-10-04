import 'dart:convert';
import 'dart:io';

import 'package:my_library/domain/contracts/book_repo.dart';
import 'package:my_library/domain/entities/book.dart';

class JsonBookRepo implements BookRepo {
  List<Book> books = [];

  JsonBookRepo() {
    readBooksFromJSON();
  }

  // method that will read from the json

  // read the books from the json files
  void readBooksFromJSON() {
    String fileName = 'assets/data/books.json';
    File file = File(fileName);
    String content = file.readAsStringSync();

    // convert the list
    List<dynamic> jsonBooks = jsonDecode(content);
    books = jsonBooks.map((json) => Book.fromJson(json)).toList();
  }

  void writeBooksToJSON() {
    String fileName = 'assets/data/books.json';
    File file = File(fileName);

    // convert the list
    List<dynamic> jsonBooks = books.map((book) => book.toJson()).toList();
    String content = jsonEncode(jsonBooks);
    file.writeAsStringSync(content);
  }

  @override
  List<Book> getBooks() {
    return books;
  }

  @override
  void addBook(Book book) {
    books.add(book);
  }

  @override
  void deleteBook(String name) {
    // challenge
  }

  @override
  void updateBook(Book book) {
    // challenge
  }
}
