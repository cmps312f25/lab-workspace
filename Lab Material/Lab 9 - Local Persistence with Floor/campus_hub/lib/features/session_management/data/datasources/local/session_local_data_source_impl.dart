// TODO: Phase 7.1 - Update SessionLocalDataSource to use Database
//
// Previously, this data source loaded sessions from JSON files.
// Now it will use the SessionDao to interact with the SQLite database.
//
// INSTRUCTIONS:
// 1. Import Session entity: import 'package:campus_hub/features/session_management/domain/entities/session.dart';
// 2. Import SessionDao: import '../../../../../core/data/database/daos/session_dao.dart';
//
// 3. Create SessionLocalDataSource class with:
//    - Private SessionDao field: final SessionDao _sessionDao;
//    - Constructor that accepts SessionDao: SessionLocalDataSource(this._sessionDao);
//
// 4. Implement the following methods using the DAO:
//
//    Future<List<Session>> getSessions() async {
//      // TODO: Call _sessionDao.getAllSessions()
//    }
//
//    Future<void> saveSession(Session session) async {
//      // TODO: Call _sessionDao.insertSession(session)
//    }
//
//    Future<void> updateSession(Session session) async {
//      // TODO: Call _sessionDao.updateSession(session)
//    }
//
//    Future<void> deleteSession(String id) async {
//      // TODO: First get the session by id using _sessionDao.getSessionById(id)
//      // TODO: If session is not null, call _sessionDao.deleteSession(session)
//    }
//
// IMPORTANT NOTES:
// - Remove all JSON loading code (rootBundle, json.decode, etc.)
// - All data now comes from the database, not JSON files
// - The DAO handles all SQL operations - you just call its methods
// - Foreign key constraints are automatically enforced by Floor
//
// Hint: Check Lab 9 document Phase 7.1 for complete example!

// TODO: Add imports here (Session entity, SessionDao)

class SessionLocalDataSource {
  // TODO: Add SessionDao field

  // TODO: Add constructor that accepts SessionDao

  // TODO: Implement getSessions() method

  // TODO: Implement saveSession(Session session) method

  // TODO: Implement updateSession(Session session) method

  // TODO: Implement deleteSession(String id) method
}
