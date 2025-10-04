import 'package:my_library/domain/entities/book.dart';
import 'package:my_library/domain/mixins/rateable.dart';

class Audiobook extends Book with Rateable {
  int size;
  int length;
  String artistName;

  Audiobook({
    required super.name,
    required super.author,
    required super.yearOfPublication,
    required this.size,
    required this.length,
    required this.artistName,
  });

  factory Audiobook.fromJson(Map<String, dynamic> json) {
    return Audiobook(
      name: json["name"],
      author: json["author"],
      yearOfPublication: json["yearOfPublication"],
      size: json["size"],
      length: json["length"],
      artistName: json["artistName"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "author": author,
      "yearOfPublication": yearOfPublication,
      "size": size,
      "length": length,
      "artistName": artistName,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return """
          ${super.toString()}
          size : $size
          length : $length
          artistName : $artistName
      """;
  }
}
