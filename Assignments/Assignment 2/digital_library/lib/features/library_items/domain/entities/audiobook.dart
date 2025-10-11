import 'author.dart';
import 'library_item.dart';

class AudioBook extends LibraryItem {
  final double duration; // in hours
  final String narrator;
  final double fileSize; // in MB

  AudioBook({
    required super.id,
    required super.title,
    required super.authors,
    required super.publishedYear,
    required super.category,
    required super.isAvailable,
    super.coverImageUrl,
    super.description,
    required this.duration,
    required this.narrator,
    required this.fileSize,
  });

  @override
  String getItemType() => 'AudioBook';

  @override
  String getDisplayInfo() {
    final authorNames = authors.map((a) => a.name).join(', ');
    return '''
AudioBook: $title
Authors: $authorNames
Narrator: $narrator
Duration: ${duration}h
File Size: ${fileSize}MB
Published: $publishedYear
Category: $category
Available: ${isAvailable ? 'Yes' : 'No'}
${description != null ? 'Description: $description' : ''}
    '''.trim();
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'AudioBook',
        'title': title,
        'authorIds': authors.map((a) => a.id).toList(),
        'publishedYear': publishedYear,
        'category': category,
        'isAvailable': isAvailable,
        'coverImageUrl': coverImageUrl,
        'description': description,
        'duration': duration,
        'narrator': narrator,
        'fileSize': fileSize,
      };

  factory AudioBook.fromJson(
      Map<String, dynamic> json, List<Author> allAuthors) {
    final authorIds = (json['authorIds'] as List).cast<String>();
    final bookAuthors = allAuthors
        .where((author) => authorIds.contains(author.id))
        .toList();

    return AudioBook(
      id: json['id'] as String,
      title: json['title'] as String,
      authors: bookAuthors,
      publishedYear: json['publishedYear'] as int,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool,
      coverImageUrl: json['coverImageUrl'] as String?,
      description: json['description'] as String?,
      duration: (json['duration'] as num).toDouble(),
      narrator: json['narrator'] as String,
      fileSize: (json['fileSize'] as num).toDouble(),
    );
  }
}
