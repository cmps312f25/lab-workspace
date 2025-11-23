import 'dart:async';
import 'dart:io';
import 'package:chat_app/features/auth/presentation/providers/repo_providers.dart';
import 'package:chat_app/features/chat/domain/contracts/message_repo.dart';
import 'package:chat_app/features/chat/domain/entities/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State class for messages
class MessageData {
  List<Message> messages;

  MessageData({required this.messages});
}

/// Provider for messages - takes roomId as parameter
/// Day 3: Send/receive messages with realtime
final messageStreamProvider =
    StreamProvider.family<List<Message>, int>((ref, roomId) {
  final messageRepo = ref.read(messageRepoProvider);
  return messageRepo.watchMessages(roomId);
});

/// Provider for message actions
final messageActionsProvider = Provider((ref) {
  final messageRepo = ref.read(messageRepoProvider);
  return MessageActions(messageRepo);
});

/// Class containing message actions
/// Day 3: Send/receive messages with realtime
/// Day 4: Add image upload to Storage
class MessageActions {
  final MessageRepository messageRepo;

  MessageActions(this.messageRepo);

  /// Send a text message
  Future<void> sendMessage(Message message) async {
    try {
      await messageRepo.sendMessage(message);
    } catch (e) {
      rethrow;
    }
  }

  /// Send a message with an image (Day 4)
  Future<void> sendMessageWithImage(Message message, File imageFile) async {
    try {
      await messageRepo.sendMessageWithImage(message, imageFile);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a message
  Future<void> deleteMessage(Message message) async {
    try {
      await messageRepo.deleteMessage(message);
    } catch (e) {
      rethrow;
    }
  }
}
