import 'package:chat_app/features/chat/domain/contracts/room_repo.dart';
import 'package:chat_app/features/chat/domain/entities/room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of RoomRepository using Supabase.
/// Day 2: Create/list rooms with RLS policies
class RoomRepoImpl implements RoomRepository {
  final SupabaseClient _client;
  final String roomsTable = "rooms";

  RoomRepoImpl(this._client);

  @override
  Stream<List<Room>> watchRooms() {
    return _client
        .from(roomsTable)
        .stream(primaryKey: ["id"])
        .order("created_at", ascending: false)
        .map((data) => data.map((json) => Room.fromJson(json)).toList());
  }

  @override
  Future<List<Room>> getRooms() async {
    try {
      final data = await _client
          .from(roomsTable)
          .select()
          .order("created_at", ascending: false);
      return data.map((json) => Room.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch rooms: $e');
    }
  }

  @override
  Future<Room?> getRoomById(int id) async {
    try {
      final data = await _client
          .from(roomsTable)
          .select()
          .eq("id", id)
          .single();
      return Room.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addRoom(Room room) async {
    try {
      await _client.from(roomsTable).insert(room.toJson());
    } catch (e) {
      throw Exception('Failed to add room: $e');
    }
  }

  @override
  Future<void> updateRoom(Room room) async {
    if (room.id == null) {
      throw Exception('Room ID is required for update');
    }

    try {
      await _client
          .from(roomsTable)
          .update(room.toJson())
          .eq("id", room.id!);
    } catch (e) {
      throw Exception('Failed to update room: $e');
    }
  }

  @override
  Future<void> deleteRoom(Room room) async {
    if (room.id == null) {
      throw Exception('Room ID is required for deletion');
    }

    try {
      await _client.from(roomsTable).delete().eq("id", room.id!);
    } catch (e) {
      throw Exception('Failed to delete room: $e');
    }
  }
}
