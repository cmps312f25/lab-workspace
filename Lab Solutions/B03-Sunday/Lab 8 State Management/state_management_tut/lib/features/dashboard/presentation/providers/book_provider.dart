import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/data/repository/book_repo_json.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class DashBoardData {
  List<Book> books;
  Book? selectedBook;
  DashBoardData({required this.books, this.selectedBook});
}

class BookNotifier extends Notifier<DashBoardData> {
  final bookRepo = BookRepoJson();

  @override
  DashBoardData build() {
    initializeState();
    return DashBoardData(books: []);
  }

  Future<void> initializeState() async {
    final List<Book> books = await bookRepo.getBooks();
    state = DashBoardData(books: books, selectedBook: state.selectedBook);
  }

  void addBook(Book book) {
    // state.add(book);
    state = DashBoardData(
      books: [...state.books, book],
      selectedBook: state.selectedBook,
    );
  }

  void updateSelectedBook(Book book) {
    state = DashBoardData(books: state.books, selectedBook: book);
  }
}

// create your provider
final bookNotifierProvider = NotifierProvider<BookNotifier, DashBoardData>(
  () => BookNotifier(),
);
