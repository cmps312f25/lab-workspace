import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:state_managment_tutorial/features/home/domain/contract/book_repo.dart';
import 'package:state_managment_tutorial/features/home/domain/entities/book.dart';

class BookRepoJson implements BookRepo {
  @override
  Future<List<Book>> fetchBooks() async {
    final booksData = await rootBundle.loadString('assets/data/books.json');
    final booksMap = await jsonDecode(booksData);
    final booksList = booksMap.map((book) => Book.fromJson(book)).toList();

    // final booksMap = await jsonDecode(booksData) as List<Book>;
    return booksList;
  }

  @override
  Future<String> fetchBookDetails(String title) {
    // TODO: implement fetchBookDetails
    throw UnimplementedError();
  }

  @override
  Future<List<String>> searchBooks(String query) {
    // TODO: implement searchBooks
    throw UnimplementedError();
  }
}
