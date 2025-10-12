import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:state_managment_tutorial/features/home/domain/contract/book_repo.dart';
import 'package:state_managment_tutorial/features/home/domain/entities/book.dart';

class BookRepoJson implements BookRepo {
  @override
  Future<List<Book>> fetchBooks() async {
    String booksContent = await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> jsonData = jsonDecode(booksContent);
    List<Book> booksList = jsonData.map((json) => Book.fromJson(json)).toList();
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
