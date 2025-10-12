import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/book_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class BookRepoJson implements BookRepository {
  @override
  Future<List<Book>> getBooks() async {
    final content = await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> booksMap = jsonDecode(content);
    final List<Book> books = booksMap
        .map((book) => Book.fromJson(book))
        .toList();
    return books;
  }

  @override
  Future<void> addBook(Book book) {
    // TODO: implement addBook
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBook(int id) {
    // TODO: implement deleteBook
    throw UnimplementedError();
  }

  @override
  Future<Book> getBookById(int id) {
    // TODO: implement getBookById
    throw UnimplementedError();
  }

  @override
  Future<void> updateBook(Book book) {
    // TODO: implement updateBook
    throw UnimplementedError();
  }
}
