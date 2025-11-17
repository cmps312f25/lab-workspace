// Flat entity - only stores authorId, not Author object
class Book {
  final String id;
  final String title;
  final String authorId;  // Foreign key - just the ID!
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'Book',
        'title': title,
        'authorId': authorId,
        'publishedYear': publishedYear,
        'category': category,
        'isAvailable': isAvailable,
        'coverImageUrl': coverImageUrl,
        'description': description,
        'isbn': isbn,
        'pageCount': pageCount,
        'publisher': publisher,
      };

  factory Book.fromJson(Map<String, dynamic> json) {
    // Support both formats: single authorId or authorIds array
    final String authorId;
    if (json.containsKey('authorId')) {
      authorId = json['authorId'] as String;
    } else if (json.containsKey('authorIds')) {
      // Fallback to old format: take first author from authorIds array
      final authorIds = (json['authorIds'] as List).cast<String>();
      authorId = authorIds.isNotEmpty ? authorIds.first : '';
    } else {
      authorId = '';
    }

    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      authorId: authorId,
      publishedYear: json['publishedYear'] as int,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool,
      coverImageUrl: json['coverImageUrl'] as String?,
      description: json['description'] as String?,
      isbn: json['isbn'] as String,
      pageCount: json['pageCount'] as int,
      publisher: json['publisher'] as String,
    );
  }

  @override
  String toString() => 'Book(id: $id, title: $title, authorId: $authorId)';
}
