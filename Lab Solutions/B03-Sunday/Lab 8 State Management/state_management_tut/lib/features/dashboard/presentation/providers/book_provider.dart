import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/data/repository/book_repo_json.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class BookNotifier extends Notifier<List<Book>> {
  final bookRepo = BookRepoJson();

  @override
  List<Book> build() {
    initializeState();
    return [];
  }

  Future<void> initializeState() async {
    final List<Book> books = await bookRepo.getBooks();
    state = books;
  }

  void addBook(Book book) {
    // state.add(book);
    state = [...state, book];
  }
}

// create your provider
final bookNotifierProvider = NotifierProvider<BookNotifier, List<Book>>(
  () => BookNotifier(),
);
