import 'dart:io';
import 'package:chat_app/features/chat/domain/contracts/message_repo.dart';
import 'package:chat_app/features/chat/domain/entities/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of MessageRepository using Supabase.
///
/// Most methods are already implemented for you.
/// YOUR TASK: Implement the Storage methods (uploadImage and sendMessageWithImage)
///
/// Supabase Storage provides:
/// - _client.storage.from('bucket-name').upload(fileName, file) - Upload a file
/// - _client.storage.from('bucket-name').getPublicUrl(fileName) - Get public URL
class MessageRepoImpl implements MessageRepository {
  final SupabaseClient _client;
  final String messagesTable = "messages";
  final String storageBucket = "chat-images";

  MessageRepoImpl(this._client);

  // Cache for profile data to avoid repeated fetches
  final Map<String, Map<String, dynamic>> _profileCache = {};

  /// Watch messages in realtime (already implemented for you)
  @override
  Stream<List<Message>> watchMessages(int roomId) {
    return _client
        .from(messagesTable)
        .stream(primaryKey: ["id"])
        .eq("room_id", roomId)
        .order("created_at", ascending: true)
        .asyncMap((data) async {
          // Get unique sender IDs
          final senderIds = data.map((m) => m['sender_id'] as String).toSet();

          // Fetch profiles for senders not in cache
          for (final senderId in senderIds) {
            if (!_profileCache.containsKey(senderId)) {
              try {
                final profile = await _client
                    .from('profiles')
                    .select('email, display_name')
                    .eq('id', senderId)
                    .maybeSingle();
                if (profile != null) {
                  _profileCache[senderId] = profile;
                }
              } catch (_) {
                // Ignore profile fetch errors
              }
            }
          }

          // Map messages with profile data
          return data.map((json) {
            final senderId = json['sender_id'] as String;
            final profile = _profileCache[senderId];
            final enrichedJson = {...json, 'profiles': profile};
            return Message.fromJson(enrichedJson);
          }).toList();
        });
  }

  /// Get all messages for a room (already implemented for you)
  @override
  Future<List<Message>> getMessages(int roomId) async {
    try {
      // Join with profiles to get sender info
      final data = await _client
          .from(messagesTable)
          .select('*, profiles(email, display_name)')
          .eq("room_id", roomId)
          .order("created_at", ascending: true);
      return data.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  /// Send a text message (already implemented for you)
  @override
  Future<void> sendMessage(Message message) async {
    try {
      await _client.from(messagesTable).insert(message.toJson());
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Delete a message (already implemented for you)
  @override
  Future<void> deleteMessage(Message message) async {
    if (message.id == null) {
      throw Exception('Message ID is required for deletion');
    }

    try {
      await _client.from(messagesTable).delete().eq("id", message.id!);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  /// TODO 4: Upload image to Supabase Storage
  ///
  /// Steps:
  /// 1. Create a unique filename using timestamp + original filename
  /// 2. Upload the file to storage using _client.storage.from(storageBucket).upload()
  /// 3. Get the public URL using _client.storage.from(storageBucket).getPublicUrl()
  /// 4. Return the public URL
  ///
  /// Hint: Use FileOptions(cacheControl: '3600', upsert: false) for upload options
  @override
  Future<String> uploadImage(File imageFile) async {
    // TODO: Implement image upload
    // 1. Create unique filename:
    //    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    // 2. Upload to storage:
    //    await _client.storage.from(storageBucket).upload(fileName, imageFile, fileOptions: ...);
    // 3. Get public URL:
    //    final publicUrl = _client.storage.from(storageBucket).getPublicUrl(fileName);
    // 4. Return the URL
    throw UnimplementedError('TODO: Implement uploadImage');
  }

  /// TODO 5: Send message with image attachment
  ///
  /// Steps:
  /// 1. Call uploadImage() to upload the image and get the URL
  /// 2. Create a new message with the image URL using message.copyWith(imageUrl: url)
  /// 3. Call sendMessage() with the updated message
  ///
  /// This combines upload + send into one convenient method!
  @override
  Future<void> sendMessageWithImage(Message message, File imageFile) async {
    // TODO: Implement send message with image
    // 1. Upload the image and get URL: final imageUrl = await uploadImage(imageFile);
    // 2. Create message with image: final messageWithImage = message.copyWith(imageUrl: imageUrl);
    // 3. Send the message: await sendMessage(messageWithImage);
    throw UnimplementedError('TODO: Implement sendMessageWithImage');
  }
}
