abstract class BookRepo {
  Future<List<String>> fetchBooks();
  Future<String> fetchBookDetails(String title);
  Future<List<String>> searchBooks(String query);
}
