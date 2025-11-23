import 'package:chat_app/features/auth/data/repository/auth_repo_impl.dart';
import 'package:chat_app/features/auth/domain/contracts/auth_repo.dart';
import 'package:chat_app/features/chat/data/repository/message_repo_impl.dart';
import 'package:chat_app/features/chat/data/repository/room_repo_impl.dart';
import 'package:chat_app/features/chat/domain/contracts/message_repo.dart';
import 'package:chat_app/features/chat/domain/contracts/room_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for AuthRepository
final authRepoProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepoImpl(client);
});

/// Provider for RoomRepository
final roomRepoProvider = Provider<RoomRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RoomRepoImpl(client);
});

/// Provider for MessageRepository
final messageRepoProvider = Provider<MessageRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MessageRepoImpl(client);
});
