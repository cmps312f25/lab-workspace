import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:state_manage_tut/features/dashboard/domain/contract/book_repo.dart';
import 'package:state_manage_tut/features/dashboard/domain/entities/book.dart';

class BookRepositoryJsonImpl implements BookRepository {
  @override
  Future<List<Book>> getBooks() async {
    final data = await rootBundle.loadString("assets/data/books.json");
    
    final List<dynamic> jsonBooksMap = jsonDecode(data);
    final List<Book> books = jsonBooksMap
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
  Future<void> deleteBook(String id) {
    // TODO: implement deleteBook
    throw UnimplementedError();
  }

  @override
  Future<Book?> getBookById(String id) {
    // TODO: implement getBookById
    throw UnimplementedError();
  }

  @override
  Future<void> updateBook(Book book) {
    // TODO: implement updateBook
    throw UnimplementedError();
  }
}
