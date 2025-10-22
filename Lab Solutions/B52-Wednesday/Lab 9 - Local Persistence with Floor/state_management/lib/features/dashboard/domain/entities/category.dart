import 'package:floor/floor.dart';

@Entity(tableName: "categories")
class Category {
  // @primaryKey
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String description;

  Category({this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  Category copyWith({int? id, String? name, String? description}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, description: $description}';
  }
}
