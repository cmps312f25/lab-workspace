import 'package:library_app/core/utils/extensions.dart';
import 'package:library_app/data/repositories/json_book_repo.dart';

void main(List<String> arguments) {
  JsonBookRepo repo = JsonBookRepo(); //books are initialized

  var books = repo.getBooks();
  books.display;

  print(10.isDivBy10);
}
