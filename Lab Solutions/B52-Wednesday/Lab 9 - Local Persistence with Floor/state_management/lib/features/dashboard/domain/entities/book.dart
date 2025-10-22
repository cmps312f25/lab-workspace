import 'package:floor/floor.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';

@Entity(
  tableName: "books",
  foreignKeys: [
    ForeignKey(
      childColumns: ["categoryId"],
      parentColumns: ["id"],
      entity: Category,
      onDelete: ForeignKeyAction.restrict,
      onUpdate: ForeignKeyAction.cascade,
    ),
  ],
)
class Book {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String author;
  final int year;
  final int categoryId;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.categoryId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      year: json['year'] as int,
      categoryId: json['categoryId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'categoryId': categoryId,
    };
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, year: $year, categoryId: $categoryId}';
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    int? year,
    int? categoryId,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
