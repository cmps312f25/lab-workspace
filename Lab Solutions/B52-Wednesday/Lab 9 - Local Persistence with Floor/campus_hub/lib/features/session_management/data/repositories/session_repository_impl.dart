import '../../domain/entities/session.dart';
import '../../domain/contracts/session_repository.dart';
import '../datasources/local/session_local_data_source_impl.dart';
import '../../../../core/domain/enums/session_status.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionLocalDataSource localDataSource;

  SessionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Session>> getAllSessions() async {
    try {
      return await localDataSource.getSessions();
    } catch (e) {
      throw Exception('Failed to load sessions: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getOpenSessions() async {
    try {
      final sessions = await getAllSessions();
      return sessions.where((session) => session.isOpen).toList();
    } catch (e) {
      throw Exception('Failed to load open sessions: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getSessionsByTutor(String tutorId) async {
    try {
      final sessions = await getAllSessions();
      return sessions.where((session) => session.tutorId == tutorId).toList();
    } catch (e) {
      throw Exception('Failed to load sessions by tutor: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getSessionsByCourse(String courseId) async {
    try {
      final sessions = await getAllSessions();
      return sessions.where((session) => session.courseId == courseId).toList();
    } catch (e) {
      throw Exception('Failed to load sessions by course: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getSessionsByDepartment(String departmentCode) async {
    try {
      final sessions = await getAllSessions();
      return sessions
          .where((session) => session.courseId.startsWith(departmentCode))
          .toList();
    } catch (e) {
      throw Exception('Failed to load sessions by department: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getSessionsByLocation(String location) async {
    try {
      final sessions = await getAllSessions();
      return sessions
          .where(
            (session) =>
                session.location.toLowerCase().contains(location.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load sessions by location: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getSessionsByStatus(String status) async {
    try {
      final sessions = await getAllSessions();
      return sessions
          .where(
            (session) => session.status == SessionStatus.fromString(status),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load sessions by status: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final sessions = await getAllSessions();
      return sessions
          .where(
            (session) =>
                session.start.isAfter(start) && session.start.isBefore(end),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load sessions by date range: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getUpcomingSessions() async {
    try {
      final sessions = await getAllSessions();
      final now = DateTime.now();
      return sessions.where((session) => session.start.isAfter(now)).toList();
    } catch (e) {
      throw Exception('Failed to load upcoming sessions: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getTodaySessions() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      return await getSessionsByDateRange(startOfDay, endOfDay);
    } catch (e) {
      throw Exception('Failed to load today sessions: ${e.toString()}');
    }
  }

  @override
  Future<Session?> getSessionById(String id) async {
    try {
      final sessions = await localDataSource.getSessions();
      try {
        return sessions.firstWhere((session) => session.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load session: ${e.toString()}');
    }
  }

  @override
  Future<void> createSession(Session session) async {
    try {
      await localDataSource.saveSession(session);
    } catch (e) {
      throw Exception('Failed to create session: ${e.toString()}');
    }
  }

  @override
  Future<void> updateSession(Session session) async {
    try {
      await localDataSource.updateSession(session);
    } catch (e) {
      throw Exception('Failed to update session: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    try {
      await localDataSource.deleteSession(id);
    } catch (e) {
      throw Exception('Failed to delete session: ${e.toString()}');
    }
  }

  @override
  Future<void> updateSessionStatus(String id, String status) async {
    try {
      final session = await getSessionById(id);
      if (session != null) {
        final updatedSession = Session(
          id: session.id,
          tutorId: session.tutorId,
          courseId: session.courseId,
          startMillis: session.startMillis,
          endMillis: session.endMillis,
          capacity: session.capacity,
          location: session.location,
          status: status,
        );
        await updateSession(updatedSession);
      }
    } catch (e) {
      throw Exception('Failed to update session status: ${e.toString()}');
    }
  }

  @override
  Future<List<Session>> getSessionsWithAvailableCapacity() async {
    try {
      final sessions = await getOpenSessions();
      // For now, return all open sessions
      // In a real implementation, you'd check actual bookings vs capacity
      return sessions;
    } catch (e) {
      throw Exception('Failed to load available sessions: ${e.toString()}');
    }
  }

  @override
  Future<int> getAvailableCapacity(String sessionId) async {
    try {
      final session = await getSessionById(sessionId);
      if (session == null) return 0;

      // For now, return full capacity
      // In a real implementation, you'd subtract actual bookings
      return session.capacity;
    } catch (e) {
      throw Exception('Failed to get available capacity: ${e.toString()}');
    }
  }
}
