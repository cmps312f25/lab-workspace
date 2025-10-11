import '../mixins/reviewable.dart';
import 'author.dart';

abstract class LibraryItem with Reviewable {
  final String id;
  final String title;
  final List<Author> authors;
  final int publishedYear;
  final String category;
  bool isAvailable;
  final String? coverImageUrl;
  final String? description;

  LibraryItem({
    required this.id,
    required this.title,
    required this.authors,
    required this.publishedYear,
    required this.category,
    required this.isAvailable,
    this.coverImageUrl,
    this.description,
  });

  /// Abstract method to get item type
  String getItemType();

  /// Abstract method to get display information
  String getDisplayInfo();

  /// Abstract method to convert to JSON
  Map<String, dynamic> toJson();

  /// Factory constructor to create appropriate subclass from JSON
  factory LibraryItem.fromJson(
      Map<String, dynamic> json, List<Author> allAuthors) {
    // This will be implemented in a separate file to handle Book and AudioBook
    throw UnimplementedError('Use specific subclass fromJson');
  }

  @override
  String toString() =>
      '$runtimeType(id: $id, title: $title, authors: ${authors.map((a) => a.name).join(", ")})';
}
