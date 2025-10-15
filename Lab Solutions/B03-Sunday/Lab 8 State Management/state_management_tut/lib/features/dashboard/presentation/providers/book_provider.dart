import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/data/repository/book_repo_json.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class BookNotifier extends AsyncNotifier<List<Book>> {
  final bookRepo = BookRepoJson();

  @override
  Future<List<Book>> build() async {
    final List<Book> books = await bookRepo.getBooks();
    return books;
  }

  void addBook(Book book) {
    // state.add(book);
  }

  void updateSelectedBook(Book book) {
    final current = state.value ?? [];
    // find the book and update it
    final index = current.indexWhere((b) => b.id == book.id);
    current[index] = book;
    state = AsyncData(current);
  }
}

// create your provider
final bookNotifierProvider = AsyncNotifierProvider<BookNotifier, List<Book>>(
  () => BookNotifier(),
);
