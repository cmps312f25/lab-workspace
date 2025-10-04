import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/domain/mixins/rateable.dart';

class PaperBook extends Book with Rateable {
  String publisher;
  int isbn;

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
        isbn : $isbn
        publisher : $publisher
      """;
  }
}
