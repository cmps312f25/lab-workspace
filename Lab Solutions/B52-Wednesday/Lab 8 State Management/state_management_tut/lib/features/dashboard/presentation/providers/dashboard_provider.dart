import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/data/repositories/book_repo_json_imp.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class BookNotifier extends AsyncNotifier<List<Book>> {
  final repo = BookRepoJsonImpl();

  @override
  FutureOr<List<Book>> build() async {
    List<Book> books = await repo.getBooks();
    return books;
  }
}

// you need to create the provider

final dashboardAsyncNotifierProvider =
    AsyncNotifierProvider<BookNotifier, List<Book>>(() => BookNotifier());
