import 'package:my_library/core/utils/extentions.dart';
import 'package:my_library/data/repositories/json_book_repo.dart';
import 'package:my_library/domain/entities/book.dart';

void main(List<String> arguments) {
  JsonBookRepo repo = JsonBookRepo();

  List<Book> books = repo.getBooks();

  books.display;

  var newBook = books.first;
  repo.addBook(newBook);
  repo.writeBooksToJSON();

  print(books);
}
