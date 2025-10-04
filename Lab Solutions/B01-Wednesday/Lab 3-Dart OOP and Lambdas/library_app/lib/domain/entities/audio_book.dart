import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/domain/mixin/rateable.dart';

class AudioBook extends Book with Rateable {
  int size;
  int length;
  String artistName;

  AudioBook({
    required super.name,
    required super.author,
    required super.yearOfPublication,
    required this.size,
    required this.length,
    required this.artistName,
  });

  @override
  String toString() {
    return """
          ${super.toString()}
          Size : $size
          Length : $length
          ArtistName : $artistName
      """;
  }
}
