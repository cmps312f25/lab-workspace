import 'dart:convert';

import 'package:library_app/domain/contracts/book_repo.dart';
import 'package:library_app/domain/entities/book.dart';
import 'dart:io';

class JsonBookRepo implements BookRepo {
  List<Book> _books = [];

  JsonBookRepo() {
    init();
  }

  //load the books from the json file
  void init() {
    String fileLocation = 'assets/data/books.json';
    File file = File(fileLocation);
    String content = file.readAsStringSync();
    List<dynamic> jsonBooks = jsonDecode(content);

    _books = jsonBooks.map((json) => Book.fromJson(json)).toList();
  }

  void writeToJsonFile() {
    // to save this _books into the json file
    List<dynamic> jsonBooks = _books.map((book) => book.toJson()).toList();
    String content = jsonEncode(jsonBooks);

    String fileLocation = 'assets/data/books.json';
    File file = File(fileLocation);
    file.writeAsStringSync(content);
  }

  @override
  void addBook(Book book) => _books.add(book);

  @override
  List<Book> getBooks() => _books;

  @override
  Book getBook(String name) => _books.firstWhere((b) => b.name == name);

  @override
  String deleteBook(String name) {
    var index = _books.indexWhere((b) => b.name == name);
    if (index == -1) return "Book does not exist";
    _books.removeAt(index);
    return "Book deleted successfully";
  }

  @override
  void updateBook(Book book) {
    var index = _books.indexWhere((b) => b.name == book.name);
    if (index != -1) {
      _books[index] = book;
    }
  }
}
