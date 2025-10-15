import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manage_tut/features/dashboard/data/repositories/book_repo_json_imp.dart';
import 'package:state_manage_tut/features/dashboard/domain/entities/book.dart';

class BookNotifier extends AsyncNotifier<List<Book>> {
  final repo = BookRepositoryJsonImpl();
  @override
  FutureOr<List<Book>> build() async {
    final books = await repo.getBooks();
    return books;
  }

  Future<void> addBook(Book book) async {
    // call the repo to add the book
    // get the updated list of books
    // update the state
    final updatedBooks = [...state.value ?? [], book];
    state = AsyncData(updatedBooks);

    // state = state.whenData((books) => [...books, book]); //
  }
}

// create the provider

final bookNotifierProvider = AsyncNotifierProvider<BookNotifier, List<Book>>(
  () => BookNotifier(),
);
