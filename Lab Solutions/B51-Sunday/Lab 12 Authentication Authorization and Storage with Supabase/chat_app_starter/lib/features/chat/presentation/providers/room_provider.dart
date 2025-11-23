import 'dart:async';
import 'package:chat_app/features/auth/presentation/providers/repo_providers.dart';
import 'package:chat_app/features/chat/domain/contracts/room_repo.dart';
import 'package:chat_app/features/chat/domain/entities/room.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State class for rooms
class RoomData {
  List<Room> rooms;
  Room? selectedRoom;

  RoomData({required this.rooms, this.selectedRoom});
}

/// RoomNotifier - manages room state with real-time updates
/// Day 2: Create/list rooms with RLS policies
class RoomNotifier extends AsyncNotifier<RoomData> {
  RoomRepository get _roomRepo => ref.read(roomRepoProvider);
  late final StreamSubscription _streamSubscription;

  @override
  Future<RoomData> build() async {
    // Set up real-time listener
    _streamSubscription = _roomRepo.watchRooms().listen((rooms) {
      state = AsyncData(RoomData(rooms: rooms));
    });

    // Clean up on dispose
    ref.onDispose(() {
      _streamSubscription.cancel();
    });

    // Initial data load
    final rooms = await _roomRepo.getRooms();
    return RoomData(rooms: rooms);
  }

  /// Add a new room
  Future<void> addRoom(Room room) async {
    try {
      await _roomRepo.addRoom(room);
      // Real-time will update the state automatically
    } catch (e) {
      rethrow;
    }
  }

  /// Update a room
  Future<void> updateRoom(Room room) async {
    try {
      await _roomRepo.updateRoom(room);
      // Real-time will update the state automatically
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a room
  Future<void> deleteRoom(Room room) async {
    try {
      await _roomRepo.deleteRoom(room);
      // Real-time will update the state automatically
    } catch (e) {
      rethrow;
    }
  }

  /// Select a room
  void selectRoom(Room? room) {
    if (state.value != null) {
      state = AsyncData(
        RoomData(
          rooms: state.value!.rooms,
          selectedRoom: room,
        ),
      );
    }
  }

  /// Get room by ID
  Future<Room?> getRoomById(int id) async {
    return await _roomRepo.getRoomById(id);
  }
}

/// Provider for RoomNotifier
final roomNotifierProvider =
    AsyncNotifierProvider<RoomNotifier, RoomData>(() => RoomNotifier());
