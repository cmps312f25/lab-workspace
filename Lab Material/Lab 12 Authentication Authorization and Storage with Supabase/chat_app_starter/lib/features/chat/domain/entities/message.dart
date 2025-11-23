/// Message entity representing a chat message.
/// This maps to the `messages` table in Supabase.
class Message {
  final int? id;
  final int roomId;
  final String senderId; // User ID who sent the message
  final String content;
  final String? imageUrl; // Optional image attachment (Day 4)
  final DateTime? createdAt;

  // Joined data (from profiles table)
  final String? senderEmail;
  final String? senderDisplayName;

  Message({
    this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    this.imageUrl,
    this.createdAt,
    this.senderEmail,
    this.senderDisplayName,
  });

  /// Create Message from JSON (Supabase response)
  factory Message.fromJson(Map<String, dynamic> json) {
    // Handle joined profile data
    final profiles = json['profiles'] as Map<String, dynamic>?;

    return Message(
      id: json['id'] as int?,
      roomId: json['room_id'] as int,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      senderEmail: profiles?['email'] as String?,
      senderDisplayName: profiles?['display_name'] as String?,
    );
  }

  /// Convert Message to JSON for Supabase insert
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  /// Create a copy with updated fields
  Message copyWith({
    int? id,
    int? roomId,
    String? senderId,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    String? senderEmail,
    String? senderDisplayName,
  }) {
    return Message(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      senderEmail: senderEmail ?? this.senderEmail,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, roomId: $roomId, senderId: $senderId, content: $content)';
  }
}
