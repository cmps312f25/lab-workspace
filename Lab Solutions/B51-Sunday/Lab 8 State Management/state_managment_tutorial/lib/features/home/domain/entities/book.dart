// {
//     "title": "The Great Gatsby",
//     "author": "F. Scott Fitzgerald",
//     "year": 1925,
//     "genre": "Fiction"
// },
class Book {
  final String title;
  final String author;
  final int year;
  final String genre;

  Book({
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] as String,
      author: json['author'] as String,
      year: json['year'] as int,
      genre: json['genre'] as String,
    );
  }

  @override
  String toString() {
    return 'Book{title: $title, author: $author, year: $year, genre: $genre}';
  }
}
