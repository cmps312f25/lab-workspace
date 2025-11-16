import 'package:book_management_app/features/dashboard/domain/contracts/book_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/book.dart';
import 'package:book_management_app/features/dashboard/presentation/providers/repo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashBoardData {
  List<Book> books;
  DashBoardData({required this.books});
}

class BookNotifier extends AsyncNotifier<DashBoardData> {
  BookRepository get _bookRepo => ref.read(bookRepoProvider);

  @override
  Future<DashBoardData> build() async {
    final initialBooks = await _bookRepo.getBooks();
    return DashBoardData(books: initialBooks);
  }

  Future<void> refreshBooks() async {
    state = const AsyncLoading();
    try {
      final books = await _bookRepo.getBooks();
      state = AsyncData(DashBoardData(books: books));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<List<Book>> getBooksByCategory(int categoryId) async {
    return await _bookRepo.getBooksByCategory(categoryId);
  }

  Future<void> addBook(Book book) async {
    try {
      await _bookRepo.addBook(book);
      await refreshBooks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      await _bookRepo.updateBook(book);
      await refreshBooks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBook(Book book) async {
    try {
      await _bookRepo.deleteBook(book);
      await refreshBooks();
    } catch (e) {
      rethrow;
    }
  }

  Future<Book?> getBookById(int id) async {
    return await _bookRepo.getBookById(id);
  }
}

final bookNotifierProvider = AsyncNotifierProvider<BookNotifier, DashBoardData>(
  () => BookNotifier(),
);
