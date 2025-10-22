import 'package:floor/floor.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

@dao
abstract class BookDao {
  @Query("SELECT * FROM books")
  Stream<List<Book>> observeBooks();

  @insert
  Future<void> addBook(Book book);

  @delete
  Future<void> deleteBook(Book book);

  @Query("SELECT * FROM books WHERE id =:id")
  Future<Book?> getBookById(int id);

  @update
  Future<void> updateBook(Book book);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertBook(Book book);

  @insert
  Future<void> insertBooks(List<Book> books);

  @Query("DELETE FROM books")
  Future<void> deleteAllBooks();

  @Query("SELECT * FROM books WHERE categoryId =:categoryId")
  Future<List<Book?>> getBooksByCategory(int categoryId);
}
