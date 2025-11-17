class Author {
  final String id;
  final String name;
  final String? profileImageUrl;
  final String? biography;
  final int? birthYear;

  Author({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.biography,
    this.birthYear,
  });

  /// Formats name appropriately
  String getDisplayName() => name;

  /// Computes current age if birth year available
  int? calculateAge() {
    if (birthYear == null) return null;
    final currentYear = DateTime.now().year;
    return currentYear - birthYear!;
  }

  /// Convert Author to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profileImageUrl': profileImageUrl,
        'biography': biography,
        'birthYear': birthYear,
      };

  /// Create Author from JSON
  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json['id'] as String,
        name: json['name'] as String,
        profileImageUrl: json['profileImageUrl'] as String?,
        biography: json['biography'] as String?,
        birthYear: json['birthYear'] as int?,
      );

  @override
  String toString() => 'Author(id: $id, name: $name, birthYear: $birthYear)';
}
