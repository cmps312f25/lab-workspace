// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SessionDao? _sessionDaoInstance;

  BookingDao? _bookingDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Student` (`id` TEXT NOT NULL, `role` TEXT NOT NULL, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, `avatarUrl` TEXT, `createdAtMillis` INTEGER NOT NULL, `major` TEXT NOT NULL, `year` INTEGER NOT NULL, `strugglingCourses` TEXT NOT NULL, `completedCourses` TEXT NOT NULL, `achievements` TEXT NOT NULL, `interests` TEXT NOT NULL, `studyPreferences` TEXT NOT NULL, `bio` TEXT, `tutoringCourses` TEXT NOT NULL, `ratings` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Session` (`id` TEXT NOT NULL, `tutorId` TEXT NOT NULL, `courseId` TEXT NOT NULL, `startMillis` INTEGER NOT NULL, `endMillis` INTEGER NOT NULL, `capacity` INTEGER NOT NULL, `location` TEXT NOT NULL, `status` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Booking` (`id` TEXT NOT NULL, `sessionId` TEXT NOT NULL, `studentId` TEXT NOT NULL, `status` TEXT NOT NULL, `bookedAtMillis` INTEGER NOT NULL, `reason` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SessionDao get sessionDao {
    return _sessionDaoInstance ??= _$SessionDao(database, changeListener);
  }

  @override
  BookingDao get bookingDao {
    return _bookingDaoInstance ??= _$BookingDao(database, changeListener);
  }
}

class _$SessionDao extends SessionDao {
  _$SessionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sessionInsertionAdapter = InsertionAdapter(
            database,
            'Session',
            (Session item) => <String, Object?>{
                  'id': item.id,
                  'tutorId': item.tutorId,
                  'courseId': item.courseId,
                  'startMillis': item.startMillis,
                  'endMillis': item.endMillis,
                  'capacity': item.capacity,
                  'location': item.location,
                  'status': item.status
                }),
        _sessionUpdateAdapter = UpdateAdapter(
            database,
            'Session',
            ['id'],
            (Session item) => <String, Object?>{
                  'id': item.id,
                  'tutorId': item.tutorId,
                  'courseId': item.courseId,
                  'startMillis': item.startMillis,
                  'endMillis': item.endMillis,
                  'capacity': item.capacity,
                  'location': item.location,
                  'status': item.status
                }),
        _sessionDeletionAdapter = DeletionAdapter(
            database,
            'Session',
            ['id'],
            (Session item) => <String, Object?>{
                  'id': item.id,
                  'tutorId': item.tutorId,
                  'courseId': item.courseId,
                  'startMillis': item.startMillis,
                  'endMillis': item.endMillis,
                  'capacity': item.capacity,
                  'location': item.location,
                  'status': item.status
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Session> _sessionInsertionAdapter;

  final UpdateAdapter<Session> _sessionUpdateAdapter;

  final DeletionAdapter<Session> _sessionDeletionAdapter;

  @override
  Future<List<Session>> getAllSessions() async {
    return _queryAdapter.queryList('SELECT * FROM Session',
        mapper: (Map<String, Object?> row) => Session(
            id: row['id'] as String,
            tutorId: row['tutorId'] as String,
            courseId: row['courseId'] as String,
            startMillis: row['startMillis'] as int,
            endMillis: row['endMillis'] as int,
            capacity: row['capacity'] as int,
            location: row['location'] as String,
            status: row['status'] as String));
  }

  @override
  Future<Session?> getSessionById(String id) async {
    return _queryAdapter.query('SELECT * FROM Session WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Session(
            id: row['id'] as String,
            tutorId: row['tutorId'] as String,
            courseId: row['courseId'] as String,
            startMillis: row['startMillis'] as int,
            endMillis: row['endMillis'] as int,
            capacity: row['capacity'] as int,
            location: row['location'] as String,
            status: row['status'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Session>> getSessionsByStatus(String status) async {
    return _queryAdapter.queryList('SELECT * FROM Session WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Session(
            id: row['id'] as String,
            tutorId: row['tutorId'] as String,
            courseId: row['courseId'] as String,
            startMillis: row['startMillis'] as int,
            endMillis: row['endMillis'] as int,
            capacity: row['capacity'] as int,
            location: row['location'] as String,
            status: row['status'] as String),
        arguments: [status]);
  }

  @override
  Future<List<Session>> getSessionsByTutor(String tutorId) async {
    return _queryAdapter.queryList('SELECT * FROM Session WHERE tutorId = ?1',
        mapper: (Map<String, Object?> row) => Session(
            id: row['id'] as String,
            tutorId: row['tutorId'] as String,
            courseId: row['courseId'] as String,
            startMillis: row['startMillis'] as int,
            endMillis: row['endMillis'] as int,
            capacity: row['capacity'] as int,
            location: row['location'] as String,
            status: row['status'] as String),
        arguments: [tutorId]);
  }

  @override
  Future<List<Session>> getSessionsByCourse(String courseId) async {
    return _queryAdapter.queryList('SELECT * FROM Session WHERE courseId = ?1',
        mapper: (Map<String, Object?> row) => Session(
            id: row['id'] as String,
            tutorId: row['tutorId'] as String,
            courseId: row['courseId'] as String,
            startMillis: row['startMillis'] as int,
            endMillis: row['endMillis'] as int,
            capacity: row['capacity'] as int,
            location: row['location'] as String,
            status: row['status'] as String),
        arguments: [courseId]);
  }

  @override
  Future<List<Session>> getSessionsByTutorAndStatus(
    String tutorId,
    String status,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Session WHERE tutorId = ?1 AND status = ?2',
        mapper: (Map<String, Object?> row) => Session(
            id: row['id'] as String,
            tutorId: row['tutorId'] as String,
            courseId: row['courseId'] as String,
            startMillis: row['startMillis'] as int,
            endMillis: row['endMillis'] as int,
            capacity: row['capacity'] as int,
            location: row['location'] as String,
            status: row['status'] as String),
        arguments: [tutorId, status]);
  }

  @override
  Future<List<Session>> getSessionsInTimeRange(
    int startMillis,
    int endMillis,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Session WHERE startMillis >= ?1 AND endMillis <= ?2',
        mapper: (Map<String, Object?> row) => Session(
            id: row['id'] as String,
            tutorId: row['tutorId'] as String,
            courseId: row['courseId'] as String,
            startMillis: row['startMillis'] as int,
            endMillis: row['endMillis'] as int,
            capacity: row['capacity'] as int,
            location: row['location'] as String,
            status: row['status'] as String),
        arguments: [startMillis, endMillis]);
  }

  @override
  Future<void> deleteAllSessions() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Session');
  }

  @override
  Future<void> insertSession(Session session) async {
    await _sessionInsertionAdapter.insert(session, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSessions(List<Session> sessions) async {
    await _sessionInsertionAdapter.insertList(
        sessions, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSession(Session session) async {
    await _sessionUpdateAdapter.update(session, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSession(Session session) async {
    await _sessionDeletionAdapter.delete(session);
  }
}

class _$BookingDao extends BookingDao {
  _$BookingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _bookingInsertionAdapter = InsertionAdapter(
            database,
            'Booking',
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'sessionId': item.sessionId,
                  'studentId': item.studentId,
                  'status': item.status,
                  'bookedAtMillis': item.bookedAtMillis,
                  'reason': item.reason
                }),
        _bookingUpdateAdapter = UpdateAdapter(
            database,
            'Booking',
            ['id'],
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'sessionId': item.sessionId,
                  'studentId': item.studentId,
                  'status': item.status,
                  'bookedAtMillis': item.bookedAtMillis,
                  'reason': item.reason
                }),
        _bookingDeletionAdapter = DeletionAdapter(
            database,
            'Booking',
            ['id'],
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'sessionId': item.sessionId,
                  'studentId': item.studentId,
                  'status': item.status,
                  'bookedAtMillis': item.bookedAtMillis,
                  'reason': item.reason
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Booking> _bookingInsertionAdapter;

  final UpdateAdapter<Booking> _bookingUpdateAdapter;

  final DeletionAdapter<Booking> _bookingDeletionAdapter;

  @override
  Future<List<Booking>> getAllBookings() async {
    return _queryAdapter.queryList('SELECT * FROM Booking',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as String,
            sessionId: row['sessionId'] as String,
            studentId: row['studentId'] as String,
            status: row['status'] as String,
            bookedAtMillis: row['bookedAtMillis'] as int,
            reason: row['reason'] as String?));
  }

  @override
  Future<Booking?> getBookingById(String id) async {
    return _queryAdapter.query('SELECT * FROM Booking WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as String,
            sessionId: row['sessionId'] as String,
            studentId: row['studentId'] as String,
            status: row['status'] as String,
            bookedAtMillis: row['bookedAtMillis'] as int,
            reason: row['reason'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<Booking>> getBookingsBySession(String sessionId) async {
    return _queryAdapter.queryList('SELECT * FROM Booking WHERE sessionId = ?1',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as String,
            sessionId: row['sessionId'] as String,
            studentId: row['studentId'] as String,
            status: row['status'] as String,
            bookedAtMillis: row['bookedAtMillis'] as int,
            reason: row['reason'] as String?),
        arguments: [sessionId]);
  }

  @override
  Future<List<Booking>> getBookingsByStudent(String studentId) async {
    return _queryAdapter.queryList('SELECT * FROM Booking WHERE studentId = ?1',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as String,
            sessionId: row['sessionId'] as String,
            studentId: row['studentId'] as String,
            status: row['status'] as String,
            bookedAtMillis: row['bookedAtMillis'] as int,
            reason: row['reason'] as String?),
        arguments: [studentId]);
  }

  @override
  Future<List<Booking>> getBookingsByStatus(String status) async {
    return _queryAdapter.queryList('SELECT * FROM Booking WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as String,
            sessionId: row['sessionId'] as String,
            studentId: row['studentId'] as String,
            status: row['status'] as String,
            bookedAtMillis: row['bookedAtMillis'] as int,
            reason: row['reason'] as String?),
        arguments: [status]);
  }

  @override
  Future<List<Booking>> getBookingsByStudentAndStatus(
    String studentId,
    String status,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Booking WHERE studentId = ?1 AND status = ?2',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as String,
            sessionId: row['sessionId'] as String,
            studentId: row['studentId'] as String,
            status: row['status'] as String,
            bookedAtMillis: row['bookedAtMillis'] as int,
            reason: row['reason'] as String?),
        arguments: [studentId, status]);
  }

  @override
  Future<List<Booking>> getBookingsBySessionAndStatus(
    String sessionId,
    String status,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Booking WHERE sessionId = ?1 AND status = ?2',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as String,
            sessionId: row['sessionId'] as String,
            studentId: row['studentId'] as String,
            status: row['status'] as String,
            bookedAtMillis: row['bookedAtMillis'] as int,
            reason: row['reason'] as String?),
        arguments: [sessionId, status]);
  }

  @override
  Future<int?> getBookingCountForSession(String sessionId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM Booking WHERE sessionId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [sessionId]);
  }

  @override
  Future<void> deleteAllBookings() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Booking');
  }

  @override
  Future<void> insertBooking(Booking booking) async {
    await _bookingInsertionAdapter.insert(booking, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertBookings(List<Booking> bookings) async {
    await _bookingInsertionAdapter.insertList(
        bookings, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    await _bookingUpdateAdapter.update(booking, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBooking(Booking booking) async {
    await _bookingDeletionAdapter.delete(booking);
  }
}
