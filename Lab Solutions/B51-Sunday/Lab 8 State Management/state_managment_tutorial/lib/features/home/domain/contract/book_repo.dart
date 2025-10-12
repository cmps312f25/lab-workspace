import 'package:state_managment_tutorial/features/home/domain/entities/book.dart';

abstract class BookRepo {
  Future<List<Book>> fetchBooks();
  Future<String> fetchBookDetails(String title);
  Future<List<String>> searchBooks(String query);
}
