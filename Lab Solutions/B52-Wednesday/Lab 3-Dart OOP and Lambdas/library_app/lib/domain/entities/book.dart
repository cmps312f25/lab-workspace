// entity, model
class Book {
  String name;
  String author;
  int yearOfPublication;

  Book({
    required this.name,
    required this.author,
    required this.yearOfPublication,
  });

  // overload a [constructor]
  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      name: map["name"],
      author: map["author"],
      yearOfPublication: map["yearOfPublication"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "author": author,
      "yearOfPublication": yearOfPublication,
    };
  }

  // helper method

  // toString
  @override
  String toString() {
    return """
      Name : $name
      Author : $author 
      Year Of Publication : $yearOfPublication
  """;
  }
}

// void main() {
//   Book b = Book(name: "name", author: "author", yearOfPublication: 11);

//   print(b.toString());
//   print(b.toJson());
// }

//   Map<String, dynamic> map = {
//     "name": "To Kill a Mockingbird",
//     "author": "Harper Lee",
//     "yearOfPublication": 1960,
//   };

//   Book b2 = Book(
//     name: map["name"],
//     author: map["author"],
//     yearOfPublication: map["yearOfPublication"],
//   );

//   print(b2.name);
// }
