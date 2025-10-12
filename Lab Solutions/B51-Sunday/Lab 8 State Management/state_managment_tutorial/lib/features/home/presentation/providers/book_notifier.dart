// flutter pub add flutter_riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_managment_tutorial/features/home/data/repository/book_repo_json.dart';
import 'package:state_managment_tutorial/features/home/domain/entities/book.dart';

class BookNotifier extends Notifier<List<Book>> {
  final bookRepo = BookRepoJson();
  @override
  List<Book> build() {
    return [];
  }

  Future<void> _initializeBooks() async {
    List<Book> books = await bookRepo.fetchBooks();
    state = books;
  }
}

final bookNotifierProvider = NotifierProvider<BookNotifier, List<Book>>(
  () => BookNotifier(),
);
