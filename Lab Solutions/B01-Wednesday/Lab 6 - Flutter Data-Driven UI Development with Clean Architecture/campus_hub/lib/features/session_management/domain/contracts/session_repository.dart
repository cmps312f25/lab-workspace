import '../entities/session.dart';

abstract class SessionRepository {
  // Get all sessions
  Future<List<Session>> getAllSessions();

  // Get sessions by filters
  Future<List<Session>> getOpenSessions();
  Future<List<Session>> getSessionsByTutor(String tutorId);
  Future<List<Session>> getSessionsByCourse(String courseId);
  Future<List<Session>> getSessionsByDepartment(String departmentCode);
  Future<List<Session>> getSessionsByLocation(String location);
  Future<List<Session>> getSessionsByStatus(String status);

  // Get sessions by date/time
  Future<List<Session>> getSessionsByDateRange(DateTime start, DateTime end);
  Future<List<Session>> getUpcomingSessions();
  Future<List<Session>> getTodaySessions();

  // Get specific session
  Future<Session?> getSessionById(String id);

  // Session operations
  Future<void> createSession(Session session);
  Future<void> updateSession(Session session);
  Future<void> deleteSession(String id);
  Future<void> updateSessionStatus(String id, String status);

  // Capacity management
  Future<List<Session>> getSessionsWithAvailableCapacity();
  Future<int> getAvailableCapacity(String sessionId);
}
