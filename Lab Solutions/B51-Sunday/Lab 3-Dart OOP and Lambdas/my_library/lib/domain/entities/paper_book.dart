import 'package:my_library/domain/entities/book.dart';

class PaperBook extends Book {
  String publisher;
  String isbn;

  PaperBook({
    required super.name,
    required super.author,
    required super.yearOfPublication,
    required this.publisher,
    required this.isbn,
  });

  @override
  String toString() {
    return """
              ${super.toString()}
              publisher : $publisher
              isbn : $isbn
          """;
  }
}
