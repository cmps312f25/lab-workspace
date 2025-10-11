import 'author.dart';
import 'library_item.dart';

class Book extends LibraryItem {
  final int pageCount;
  final String isbn;
  final String publisher;

  Book({
    required super.id,
    required super.title,
    required super.authors,
    required super.publishedYear,
    required super.category,
    required super.isAvailable,
    super.coverImageUrl,
    super.description,
    required this.pageCount,
    required this.isbn,
    required this.publisher,
  });

  @override
  String getItemType() => 'Book';

  @override
  String getDisplayInfo() {
    final authorNames = authors.map((a) => a.name).join(', ');
    return '''
Book: $title
Authors: $authorNames
ISBN: $isbn
Pages: $pageCount
Publisher: $publisher
Published: $publishedYear
Category: $category
Available: ${isAvailable ? 'Yes' : 'No'}
${description != null ? 'Description: $description' : ''}
    '''.trim();
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'Book',
        'title': title,
        'authorIds': authors.map((a) => a.id).toList(),
        'publishedYear': publishedYear,
        'category': category,
        'isAvailable': isAvailable,
        'coverImageUrl': coverImageUrl,
        'description': description,
        'isbn': isbn,
        'pageCount': pageCount,
        'publisher': publisher,
      };

  factory Book.fromJson(Map<String, dynamic> json, List<Author> allAuthors) {
    final authorIds = (json['authorIds'] as List).cast<String>();
    final bookAuthors = allAuthors
        .where((author) => authorIds.contains(author.id))
        .toList();

    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      authors: bookAuthors,
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
}
