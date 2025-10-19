import 'package:state_management_tut/core/data/database/daos/book_dao.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/book_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

/// Repository implementation that loads books from a JSON asset file
class BookRepoLocalDB implements BookRepository {
  final BookDao _bookDao;
  BookRepoLocalDB(this._bookDao);

  @override
  Stream<List<Book>> getBooks() => _bookDao.getBooks();

  @override
  Future<void> addBook(Book book) => _bookDao.addBook(book);

  @override
  Future<void> deleteBook(Book book) => _bookDao.deleteBook(book);

  @override
  Future<Book?> getBookById(int id) => _bookDao.getBookById(id);

  @override
  Future<void> updateBook(Book book) => _bookDao.updateBook(book);

  @override
  Future<List<Book?>> getBooksByCategory(int categoryId) =>
      _bookDao.getBooksByCategory(categoryId);
}
