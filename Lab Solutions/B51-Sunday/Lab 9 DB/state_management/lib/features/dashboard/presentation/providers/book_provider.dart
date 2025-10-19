import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/book_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/repo_providers.dart';

class DashBoardData {
  List<Book> books;
  DashBoardData({required this.books});
}

class BookNotifier extends AsyncNotifier<DashBoardData> {
  late final BookRepository bookRepo;

  @override
  Future<DashBoardData> build() async {
    bookRepo = await ref.read(bookRepoProvider.future);
    bookRepo.getBooks().listen((books) {
      state = AsyncData(DashBoardData(books: books));
    });

    return DashBoardData(books: []);
  }

  /// Gets books by category ID
  Future<List<Book?>> getBooksByCategory(int categoryId) async {
    return await bookRepo.getBooksByCategory(categoryId);
  }

  /// Adds a new book to the repository and updates state
  Future<void> addBook(Book book) async {
    try {
      await bookRepo.addBook(book);
    } catch (e) {
      rethrow;
    }
  }

  /// Updates an existing book in the repository and updates state
  Future<void> updateBook(Book book) async {
    try {
      await bookRepo.updateBook(book);
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes a book from the repository and updates state
  Future<void> deleteBook(Book book) async {
    try {
      await bookRepo.deleteBook(book);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets a book by its ID
  Future<Book?> getBookById(int id) async {
    return await bookRepo.getBookById(id);
  }
}

// create your provider
final bookNotifierProvider = AsyncNotifierProvider<BookNotifier, DashBoardData>(
  () => BookNotifier(),
);
