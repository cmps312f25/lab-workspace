import 'package:chat_app/features/chat/domain/entities/room.dart';

/// Abstract repository defining room operations.
/// Day 2: Create/list rooms with RLS policies
abstract class RoomRepository {
  /// Get all rooms (real-time stream)
  Stream<List<Room>> watchRooms();

  /// Get all rooms (one-time fetch)
  Future<List<Room>> getRooms();

  /// Get a single room by ID
  Future<Room?> getRoomById(int id);

  /// Create a new room
  Future<void> addRoom(Room room);

  /// Update an existing room
  Future<void> updateRoom(Room room);

  /// Delete a room
  Future<void> deleteRoom(Room room);
}
