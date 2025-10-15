// "id": 1,
//     "title": "The Great Gatsby",
//     "author": "F. Scott Fitzgerald",
//     "year": 1925
class Book {
  final int id;
  final String title;
  final String author;
  final int year;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'author': author, 'year': year};
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, year: $year}';
  }

  // add copyWith, ==, hashCode if needed
  Book copyWith({int? id, String? title, String? author, int? year}) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
    );
  }
}
