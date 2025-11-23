import 'dart:io';
import 'package:chat_app/features/chat/domain/entities/message.dart';

/// Abstract repository defining message operations.
/// Day 3: Send/receive messages with realtime
/// Day 4: Add image upload to Storage
abstract class MessageRepository {
  /// Get messages for a room (real-time stream)
  Stream<List<Message>> watchMessages(int roomId);

  /// Get messages for a room (one-time fetch)
  Future<List<Message>> getMessages(int roomId);

  /// Send a new message
  Future<void> sendMessage(Message message);

  /// Delete a message
  Future<void> deleteMessage(Message message);

  /// Upload an image to Supabase Storage (Day 4)
  Future<String> uploadImage(File imageFile);

  /// Send a message with an image attachment (Day 4)
  Future<void> sendMessageWithImage(Message message, File imageFile);
}
