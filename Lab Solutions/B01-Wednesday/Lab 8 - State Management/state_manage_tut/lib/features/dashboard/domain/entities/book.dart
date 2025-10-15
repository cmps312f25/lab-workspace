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
  Map<String, dynamic> toJson() {
    return {'title': title, 'author': author, 'year': year, 'genre': genre};
  }
}
