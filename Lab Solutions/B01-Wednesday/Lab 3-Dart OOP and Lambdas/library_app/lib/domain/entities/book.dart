class Book {
  String name;
  String author;
  int yearOfPublication;

  Book({
    required this.name,
    required this.author,
    required this.yearOfPublication,
  });

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

  // helper method that does the reverse
  @override
  String toString() {
    return """
      Name : $name 
      Author : $author
      YearOfPublication :  $yearOfPublication
    """;
  }
}
