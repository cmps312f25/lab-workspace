// TODO: Phase 2.1 - Create SessionDao
//
// A DAO (Data Access Object) defines how to interact with a database table.
// Floor will generate the implementation automatically - you just write the method signatures!
//
// INSTRUCTIONS:
// 1. Import Floor: import 'package:floor/floor.dart';
// 2. Import Session entity: import '../../../../features/session_management/domain/entities/session.dart';
// 3. Add @dao annotation above the class
// 4. Make this an abstract class (Floor will implement it)
// 5. Add the following methods with appropriate annotations:
//
// QUERY METHODS (use @Query annotation with SQL):
// - Future<List<Session>> getAllSessions()
//   SQL: 'SELECT * FROM Session'
//
// - Future<Session?> getSessionById(String id)
//   SQL: 'SELECT * FROM Session WHERE id = :id'
//   Note: Use :id to reference the method parameter
//   Returns Session? (nullable) because session might not exist
//
// - Future<List<Session>> getSessionsByStatus(String status)
//   SQL: 'SELECT * FROM Session WHERE status = :status'
//   This uses the foreign key field indirectly
//
// - Future<List<Session>> getSessionsByTutor(String tutorId)
//   SQL: 'SELECT * FROM Session WHERE tutorId = :tutorId'
//   This leverages the foreign key relationship with Student
//
// INSERT METHODS (use @insert annotation, no SQL needed):
// - Future<void> insertSession(Session session)
//   Inserts a single session
//
// - Future<void> insertSessions(List<Session> sessions)
//   Inserts multiple sessions (useful for seeding data)
//
// UPDATE METHOD (use @update annotation, no SQL needed):
// - Future<void> updateSession(Session session)
//   Updates an existing session based on primary key
//
// DELETE METHODS (use @delete annotation or @Query):
// - Future<void> deleteSession(Session session)
//   Use @delete annotation
//
// - Future<void> deleteAllSessions()
//   Use @Query('DELETE FROM Session')
//
// IMPORTANT NOTES:
// - Table name is 'Session' (matches the entity class name)
// - Query parameters use :parameterName syntax
// - Parameter names in SQL MUST match method parameter names exactly
// - Floor enforces the foreign key constraint you defined in Session entity
//   (Can't delete a Student who has sessions due to ForeignKeyAction.restrict)
//
// Hint: Check Lab 9 document Phase 2.1 for complete method list!

// TODO: Add imports here

// TODO: Add @dao annotation here
abstract class SessionDao {
  // TODO: Add getAllSessions() method with @Query annotation

  // TODO: Add getSessionById(String id) method with @Query annotation

  // TODO: Add getSessionsByStatus(String status) method with @Query annotation

  // TODO: Add getSessionsByTutor(String tutorId) method with @Query annotation

  // TODO: Add insertSession(Session session) method with @insert annotation

  // TODO: Add insertSessions(List<Session> sessions) method with @insert annotation

  // TODO: Add updateSession(Session session) method with @update annotation

  // TODO: Add deleteSession(Session session) method with @delete annotation

  // TODO: Add deleteAllSessions() method with @Query('DELETE FROM Session')
}
