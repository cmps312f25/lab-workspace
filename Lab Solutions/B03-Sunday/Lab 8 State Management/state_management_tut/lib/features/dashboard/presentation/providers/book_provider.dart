import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/data/repository/book_repo_json.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class BookNotifier extends Notifier<List<Book>> {
  @override
  build() => BookRepoJson().getBooks();

  void add(Book book) => state = [...state, book];
  void remove(int id) => state = state.where((book) => book.id != id).toList();
  void update(Book book) =>
      state = state.map((b) => b.id == book.id ? book : b).toList();
}

final bookProvider = NotifierProvider<BookNotifier, List<Book>>(
  () => BookNotifier()
);
