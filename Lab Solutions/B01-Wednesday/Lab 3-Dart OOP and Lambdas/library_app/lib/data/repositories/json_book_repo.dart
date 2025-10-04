import 'dart:convert';
import 'dart:io';

import 'package:library_app/domain/contract/book_repo.dart';
import 'package:library_app/domain/entities/book.dart';

class JsonBookRepo implements BookRepo {
  List<Book> _books = [];

  JsonBookRepo() {
    initBooks();
  }

  // read from the json file
  void initBooks() {
    String fileName = "assets/data/books.json";
    File file = File(fileName);
    String contentOfFile = file.readAsStringSync();

    // you need to convert this into Map<String , dynamic>
    List<dynamic> jsonBooks = jsonDecode(contentOfFile);
    _books = jsonBooks.map((json) => Book.fromJson(json)).toList();
  }

  // write back to the json file
  void writeToJsonFile() {
    String fileName = "assets/data/books.json";
    File file = File(fileName);

    var jsonBooks = _books.map((book) => book.toJson());
    String contentOfFile = jsonEncode(jsonBooks);
    file.writeAsStringSync(contentOfFile);
  }

  @override
  void addBook(Book book) => _books.add(book);

  @override
  void deleteBook(String name) {
    // TODO: implement deleteBook
    // do it yourself
  }

  @override
  Book getBookByTitle(String name) =>
      _books.firstWhere((book) => book.name == name);

  @override
  List<Book> getBooks() => _books;

  @override
  void updateBook(String name, Book updatedBook) {
    // TODO: implement updateBook
  }
}
