class Book {
  final int? id;
  final String title;
  final String author;
  final int year;
  final int categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      title: json['title'] as String,
      author: json['author'] as String,
      year: json['year'] as int,
      categoryId: json['categoryId'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'categoryId': categoryId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, year: $year, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    int? year,
    int? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
