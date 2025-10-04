import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/domain/mixin/rateable.dart';

class PaperBook extends Book with Rateable {
  String isbn;
  String publisher;

  PaperBook({
    required super.name,
    required super.author,
    required super.yearOfPublication,
    required this.isbn,
    required this.publisher,
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
