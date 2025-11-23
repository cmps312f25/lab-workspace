/// Flat entity - only stores authorId, not Author object
class Book {
  final String id;
  final String title;
  final String authorId;
  final int publishedYear;
  final String category;
  final bool isAvailable;
  final String? coverImageUrl;
  final String? description;
  final int pageCount;
  final String isbn;
  final String publisher;

  Book({
    required this.id,
    required this.title,
    required this.authorId,
    required this.publishedYear,
    required this.category,
    required this.isAvailable,
    this.coverImageUrl,
    this.description,
    required this.pageCount,
    required this.isbn,
    required this.publisher,
  });

  String getItemType() => 'Book';

  /// Convert Book to JSON (snake_case for Supabase)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author_id': authorId,
        'published_year': publishedYear,
        'category': category,
        'is_available': isAvailable,
        'cover_image_url': coverImageUrl,
        'description': description,
        'isbn': isbn,
        'page_count': pageCount,
        'publisher': publisher,
      };

  /// Create Book from JSON (supports both camelCase and snake_case)
  factory Book.fromJson(Map<String, dynamic> json) {
    // Support multiple formats: authorId, author_id, or authorIds array
    final String authorId;
    if (json.containsKey('authorId')) {
      authorId = json['authorId'] as String;
    } else if (json.containsKey('author_id')) {
      authorId = json['author_id'] as String;
    } else if (json.containsKey('authorIds')) {
      final authorIds = (json['authorIds'] as List).cast<String>();
      authorId = authorIds.isNotEmpty ? authorIds.first : '';
    } else {
      authorId = '';
    }

    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      authorId: authorId,
      publishedYear: json['publishedYear'] ?? json['published_year'] as int,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] ?? json['is_available'] as bool,
      coverImageUrl: json['coverImageUrl'] ?? json['cover_image_url'] as String?,
      description: json['description'] as String?,
      isbn: json['isbn'] as String,
      pageCount: json['pageCount'] ?? json['page_count'] as int,
      publisher: json['publisher'] as String,
    );
  }

  Book copyWith({
    String? id,
    String? title,
    String? authorId,
    int? publishedYear,
    String? category,
    bool? isAvailable,
    String? coverImageUrl,
    String? description,
    int? pageCount,
    String? isbn,
    String? publisher,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      publishedYear: publishedYear ?? this.publishedYear,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      description: description ?? this.description,
      pageCount: pageCount ?? this.pageCount,
      isbn: isbn ?? this.isbn,
      publisher: publisher ?? this.publisher,
    );
  }

  @override
  String toString() => 'Book(id: $id, title: $title, authorId: $authorId)';
}
