class Book {
  String name;
  String author;
  int yearOfPublication;

  Book({
    required this.name,
    required this.author,
    required this.yearOfPublication,
  });

  // java version

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json["name"],
      author: json["author"],
      yearOfPublication: json["yearOfPublication"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "author": author,
      "yearOfPublication": yearOfPublication,
    };
  }

  // member methods
  @override
  String toString() {
    return " Book title : $name Author :$author Year of Publication  : $yearOfPublication";
  }
}
