/// Room entity representing a chat room.
/// This maps to the `rooms` table in Supabase.
class Room {
  final int? id;
  final String name;
  final String? description;
  final String createdBy; // User ID who created the room
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Room({
    this.id,
    required this.name,
    this.description,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  /// Create Room from JSON (Supabase response)
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert Room to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'created_by': createdBy,
    };
  }

  /// Create a copy with updated fields
  Room copyWith({
    int? id,
    String? name,
    String? description,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Room(id: $id, name: $name, createdBy: $createdBy)';
  }
}
