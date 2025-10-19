# Lab 9 - Solutions Guide

This document contains complete solutions for all TODOs in Lab 9. Use this as a reference if you get stuck, but try to solve each phase on your own first!

---

## Phase 1 Solutions: Annotate Entities

### Solution 1.1: Session Entity

**File:** `lib/features/session_management/domain/entities/session.dart`

```dart
import 'package:floor/floor.dart';  // ✅ TODO 1: Add Floor import
import '../../../../core/domain/enums/session_status.dart';

@entity  // ✅ TODO 2: Mark class as entity
class Session {
  @primaryKey  // ✅ TODO 3: Mark id as primary key
  final String id;
  final String tutorId;
  final String courseId;
  final int startMillis;
  final int endMillis;
  final int capacity;
  final String location;
  final String status;

  const Session({
    required this.id,
    required this.tutorId,
    required this.courseId,
    required this.startMillis,
    required this.endMillis,
    required this.capacity,
    required this.location,
    required this.status,
  });

  // Helper getters for convenient access
  DateTime get start => DateTime.fromMillisecondsSinceEpoch(startMillis);
  DateTime get end => DateTime.fromMillisecondsSinceEpoch(endMillis);
  SessionStatus get sessionStatus => SessionStatus.fromString(status);

  // ... rest of the class
}
```

---

### Solution 1.2: Booking Entity

**File:** `lib/features/booking/domain/entities/booking.dart`

```dart
import 'package:floor/floor.dart';  // ✅ TODO 1: Add Floor import
import '../../../../core/domain/enums/booking_status.dart';

@entity  // ✅ TODO 2: Mark class as entity
class Booking {
  @primaryKey  // ✅ TODO 3: Mark id as primary key
  final String id;
  final String sessionId;
  final String studentId;
  final String status;
  final int bookedAtMillis;
  final String? reason;

  const Booking({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.status,
    required this.bookedAtMillis,
    this.reason,
  });

  // Helper getters
  DateTime get bookedAt => DateTime.fromMillisecondsSinceEpoch(bookedAtMillis);
  BookingStatus get bookingStatus => BookingStatus.fromString(status);

  // ... rest of the class
}
```

---

## Phase 2 Solutions: Create DAOs

### Solution 2.1: SessionDao

**File:** `lib/core/data/database/daos/session_dao.dart`

```dart
import 'package:floor/floor.dart';
import '../../../../features/session_management/domain/entities/session.dart';

@dao  // ✅ Mark as DAO
abstract class SessionDao {
  // ✅ Get all sessions
  @Query('SELECT * FROM Session')
  Future<List<Session>> getAllSessions();

  // ✅ Get session by id
  @Query('SELECT * FROM Session WHERE id = :id')
  Future<Session?> getSessionById(String id);

  // ✅ Get sessions by status
  @Query('SELECT * FROM Session WHERE status = :status')
  Future<List<Session>> getSessionsByStatus(String status);

  // ✅ Get sessions by tutor
  @Query('SELECT * FROM Session WHERE tutorId = :tutorId')
  Future<List<Session>> getSessionsByTutor(String tutorId);

  // ✅ Insert one session
  @insert
  Future<void> insertSession(Session session);

  // ✅ Insert multiple sessions (for seeding)
  @insert
  Future<void> insertSessions(List<Session> sessions);

  // ✅ Update a session
  @update
  Future<void> updateSession(Session session);

  // ✅ Delete a session
  @delete
  Future<void> deleteSession(Session session);

  // ✅ Delete all sessions
  @Query('DELETE FROM Session')
  Future<void> deleteAllSessions();
}
```

**Key Points:**
- `@Query` requires SQL string with table name matching entity class name
- Query parameters use `:parameterName` syntax
- Parameter names must match method parameter names exactly
- `@insert`, `@update`, `@delete` auto-generate SQL

---

### Solution 2.2: BookingDao

**File:** `lib/core/data/database/daos/booking_dao.dart`

```dart
import 'package:floor/floor.dart';
import '../../../../features/booking/domain/entities/booking.dart';

@dao  // ✅ Mark as DAO
abstract class BookingDao {
  // ✅ Get all bookings
  @Query('SELECT * FROM Booking')
  Future<List<Booking>> getAllBookings();

  // ✅ Get booking by id
  @Query('SELECT * FROM Booking WHERE id = :id')
  Future<Booking?> getBookingById(String id);

  // ✅ Get bookings by session
  @Query('SELECT * FROM Booking WHERE sessionId = :sessionId')
  Future<List<Booking>> getBookingsBySession(String sessionId);

  // ✅ Get bookings by student
  @Query('SELECT * FROM Booking WHERE studentId = :studentId')
  Future<List<Booking>> getBookingsByStudent(String studentId);

  // ✅ Insert one booking
  @insert
  Future<void> insertBooking(Booking booking);

  // ✅ Insert multiple bookings (for seeding)
  @insert
  Future<void> insertBookings(List<Booking> bookings);

  // ✅ Update a booking
  @update
  Future<void> updateBooking(Booking booking);

  // ✅ Delete a booking
  @delete
  Future<void> deleteBooking(Booking booking);

  // ✅ Delete all bookings
  @Query('DELETE FROM Booking')
  Future<void> deleteAllBookings();
}
```

---

## Phase 3 Solution: Create AppDatabase

### Solution 3.1: AppDatabase Class

**File:** `lib/core/data/database/app_database.dart`

```dart
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../../features/session_management/domain/entities/session.dart';
import '../../../features/booking/domain/entities/booking.dart';
import 'daos/session_dao.dart';
import 'daos/booking_dao.dart';

part 'app_database.g.dart';  // ✅ Generated file

@Database(version: 1, entities: [Session, Booking])  // ✅ Database annotation
abstract class AppDatabase extends FloorDatabase {
  // ✅ DAO getters
  SessionDao get sessionDao;
  BookingDao get bookingDao;
}
```

**Key Points:**
- `part 'app_database.g.dart'` must match the generated filename
- `@Database` needs version number and complete list of entities
- Extend `FloorDatabase`
- DAO getters are abstract (Floor implements them)

---

## Phase 4 Solution: Code Generation

Run this command in your terminal:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Expected Output:**
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 412ms
[INFO] Creating build script snapshot...
[INFO] Creating build script snapshot completed, took 2.3s
[INFO] Running build...
[INFO] Running build completed, took 8.2s
[INFO] Caching finalized dependency graph...
[INFO] Caching finalized dependency graph completed, took 45ms
[INFO] Succeeded after 10.9s with 48 outputs
```

**Result:** `app_database.g.dart` file is created in the same directory as `app_database.dart`

---

## Phase 5 Solution: Database Provider

### Solution 5.1: DatabaseProvider

**File:** `lib/core/data/database/database_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  return await $FloorAppDatabase
      .databaseBuilder('campus_hub.db')
      .build();
});
```

**Key Points:**
- `FutureProvider` because database creation is async
- `$FloorAppDatabase` is the generated builder class (note the `$` prefix)
- `.databaseBuilder()` takes the database filename
- `.build()` creates the actual database

---

## Phase 6 Solution: Database Seeder

### Solution 6.1: DatabaseSeeder Class

**File:** `lib/core/data/database/database_seeder.dart`

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../features/session_management/domain/entities/session.dart';
import '../../../features/booking/domain/entities/booking.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase(AppDatabase database) async {
    try {
      // ✅ Check if database is already seeded
      final sessionCount = await database.sessionDao.getAllSessions();

      if (sessionCount.isNotEmpty) {
        return;  // Already seeded, skip
      }

      // ✅ Seed Sessions
      await _seedSessions(database);

      // ✅ Seed Bookings
      await _seedBookings(database);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _seedSessions(AppDatabase database) async {
    // ✅ Load JSON file
    final jsonString =
        await rootBundle.loadString('assets/json/sessions_sample.json');

    // ✅ Parse JSON
    final List<dynamic> jsonData = json.decode(jsonString);

    // ✅ Convert to Session objects
    final sessions = jsonData.map((json) => Session.fromJson(json)).toList();

    // ✅ Insert into database
    await database.sessionDao.insertSessions(sessions);
  }

  static Future<void> _seedBookings(AppDatabase database) async {
    // ✅ Load JSON file
    final jsonString =
        await rootBundle.loadString('assets/json/bookings_sample.json');

    // ✅ Parse JSON
    final List<dynamic> jsonData = json.decode(jsonString);

    // ✅ Convert to Booking objects
    final bookings = jsonData.map((json) => Booking.fromJson(json)).toList();

    // ✅ Insert into database
    await database.bookingDao.insertBookings(bookings);
  }

  // Utility method to clear database (useful for testing)
  static Future<void> clearDatabase(AppDatabase database) async {
    await database.sessionDao.deleteAllSessions();
    await database.bookingDao.deleteAllBookings();
  }
}
```

**Key Points:**
- Always check if data exists before seeding
- Use `rootBundle.loadString()` to load JSON assets
- Use `json.decode()` to parse JSON string
- Use `.map()` to convert JSON objects to entities
- Use bulk insert methods for better performance

---

## Phase 7 Solutions: Update Data Sources

### Solution 7.1: SessionLocalDataSource

**File:** `lib/features/session_management/data/datasources/local/session_local_data_source_impl.dart`

```dart
import '../../../domain/entities/session.dart';
import '../../../../../core/data/database/daos/session_dao.dart';

class SessionLocalDataSource {
  final SessionDao _sessionDao;  // ✅ DAO dependency

  SessionLocalDataSource(this._sessionDao);  // ✅ Inject DAO

  // ✅ Get all sessions from database
  Future<List<Session>> getSessions() async {
    return await _sessionDao.getAllSessions();
  }

  // ✅ Save session to database
  Future<void> saveSession(Session session) async {
    await _sessionDao.insertSession(session);
  }

  // ✅ Update session in database
  Future<void> updateSession(Session session) async {
    await _sessionDao.updateSession(session);
  }

  // ✅ Delete session from database
  Future<void> deleteSession(String id) async {
    final session = await _sessionDao.getSessionById(id);
    if (session != null) {
      await _sessionDao.deleteSession(session);
    }
  }
}
```

**Key Changes:**
- Removed `rootBundle` and JSON file loading
- Constructor now takes `SessionDao`
- All methods use DAO instead of JSON files

---

### Solution 7.2: BookingLocalDataSource

**File:** `lib/features/booking/data/datasources/local/booking_local_data_source_impl.dart`

```dart
import '../../../domain/entities/booking.dart';
import '../../../../../core/data/database/daos/booking_dao.dart';

class BookingLocalDataSource {
  final BookingDao _bookingDao;  // ✅ DAO dependency

  BookingLocalDataSource(this._bookingDao);  // ✅ Inject DAO

  // ✅ Get all bookings from database
  Future<List<Booking>> getBookings() async {
    return await _bookingDao.getAllBookings();
  }

  // ✅ Get bookings by student
  Future<List<Booking>> getBookingsByStudent(String studentId) async {
    return await _bookingDao.getBookingsByStudent(studentId);
  }

  // ✅ Get bookings by session
  Future<List<Booking>> getBookingsBySession(String sessionId) async {
    return await _bookingDao.getBookingsBySession(sessionId);
  }

  // ✅ Get booking by id
  Future<Booking?> getBookingById(String id) async {
    return await _bookingDao.getBookingById(id);
  }

  // ✅ Save booking to database
  Future<void> saveBooking(Booking booking) async {
    await _bookingDao.insertBooking(booking);
  }

  // ✅ Update booking in database
  Future<void> updateBooking(Booking booking) async {
    await _bookingDao.updateBooking(booking);
  }

  // ✅ Delete booking from database
  Future<void> deleteBooking(String id) async {
    final booking = await _bookingDao.getBookingById(id);
    if (booking != null) {
      await _bookingDao.deleteBooking(booking);
    }
  }
}
```

---

## Phase 8 Solutions: Update Notifiers

### Solution 8.1: SessionNotifier

**File:** `lib/features/session_management/presentation/providers/session_notifier.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/contracts/session_repository.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../data/datasources/local/session_local_data_source_impl.dart';
import '../../../../core/data/database/database_provider.dart';  // ✅ Add import
import '../../../../core/data/database/database_seeder.dart';    // ✅ Add import
import 'states/session_state.dart';

class SessionNotifier extends AsyncNotifier<SessionData> {
  late SessionRepository sessionRepository;

  @override
  Future<SessionData> build() async {
    await _initializeRepository();
    return SessionData();
  }

  Future<void> _initializeRepository() async {
    // ✅ Get database from provider
    final database = await ref.read(databaseProvider.future);

    // ✅ Seed database if needed
    await DatabaseSeeder.seedDatabase(database);

    // ✅ Create data source with database
    sessionRepository = SessionRepositoryImpl(
      localDataSource: SessionLocalDataSource(database.sessionDao),
    );
  }

  // ... rest of the methods stay the same
}

final sessionNotifierProvider = AsyncNotifierProvider<SessionNotifier, SessionData>(
  () => SessionNotifier(),
);
```

**Key Changes:**
- Import database provider and seeder
- Get database using `ref.read(databaseProvider.future)`
- Call seeder before creating data source
- Pass `database.sessionDao` to data source constructor

---

### Solution 8.2: BookingNotifier

**File:** `lib/features/booking/presentation/providers/booking_notifier.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/contracts/booking_repository.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/datasources/local/booking_local_data_source_impl.dart';
import '../../../../core/data/database/database_provider.dart';  // ✅ Add import
import '../../../../core/data/database/database_seeder.dart';    // ✅ Add import
import 'states/booking_state.dart';

class BookingNotifier extends AsyncNotifier<BookingData> {
  late BookingRepository bookingRepository;

  @override
  Future<BookingData> build() async {
    await _initializeRepository();
    return BookingData();
  }

  Future<void> _initializeRepository() async {
    // ✅ Get database from provider
    final database = await ref.read(databaseProvider.future);

    // ✅ Seed database if needed
    await DatabaseSeeder.seedDatabase(database);

    // ✅ Create data source with database
    bookingRepository = BookingRepositoryImpl(
      localDataSource: BookingLocalDataSource(database.bookingDao),
    );
  }

  // ... rest of the methods stay the same
}

final bookingNotifierProvider = AsyncNotifierProvider<BookingNotifier, BookingData>(
  () => BookingNotifier(),
);
```

---

## Additional Notes

### Important Fix: Student Entity

One issue you might encounter is with the `Student.fromJson()` method. Some students in the JSON might have null values for `major` and `year`. Here's the fix:

**File:** `lib/features/user_management/domain/entities/student.dart`

```dart
// In the fromJson method, change:
major: json['major'] as String,
year: json['year'] as int,

// To:
major: (json['major'] as String?) ?? 'Unknown',
year: (json['year'] as int?) ?? 1,
```

This handles null values gracefully by providing default values.

---

## Testing Your Implementation

### 1. Run the App

```bash
flutter run
```

### 2. Check Console Output

You should see database seeding messages on first launch:
```
flutter: [SEED] Starting database seeding check...
flutter: [SEED] Found 0 existing sessions
flutter: [SEED] Database empty, starting seeding...
flutter: [SEED] ✓ Inserted 15 sessions
flutter: [SEED] ✓ Inserted 6 bookings
flutter: [SEED] Database seeded successfully!
```

On subsequent launches:
```
flutter: [SEED] Starting database seeding check...
flutter: [SEED] Found 15 existing sessions
flutter: [SEED] Database already seeded, skipping
```

### 3. Verify Data Persistence

1. Launch the app - see sessions and bookings
2. Close the app completely
3. Relaunch the app
4. Data should still be there!

---

## Common Issues and Solutions

### Issue 1: "Table doesn't exist"

**Solution:** Run code generation again
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Issue 2: No data appears

**Solution:** Check console for errors. Make sure:
- JSON files are in `assets/json/` folder
- `pubspec.yaml` includes assets
- Seeder is being called
- No errors in fromJson conversion

### Issue 3: Data doesn't persist

**Solution:** Make sure:
- Data sources use database, not JSON files
- `rootBundle.loadString` is only in seeder, not in data sources

### Issue 4: Seeding runs every time

**Solution:** Check the seeder's early return logic:
```dart
final sessionCount = await database.sessionDao.getAllSessions();
if (sessionCount.isNotEmpty) {
  return;  // This should prevent re-seeding
}
```

---

## Complete File Structure

After completing all phases, your project should have these new files:

```
lib/
├── core/
│   └── data/
│       └── database/
│           ├── app_database.dart
│           ├── app_database.g.dart (generated)
│           ├── database_provider.dart
│           ├── database_seeder.dart
│           └── daos/
│               ├── session_dao.dart
│               └── booking_dao.dart
└── features/
    ├── session_management/
    │   ├── domain/
    │   │   └── entities/
    │   │       └── session.dart (with Floor annotations)
    │   ├── data/
    │   │   └── datasources/
    │   │       └── local/
    │   │           └── session_local_data_source_impl.dart (updated)
    │   └── presentation/
    │       └── providers/
    │           └── session_notifier.dart (updated)
    └── booking/
        ├── domain/
        │   └── entities/
        │       └── booking.dart (with Floor annotations)
        ├── data/
        │   └── datasources/
        │       └── local/
        │           └── booking_local_data_source_impl.dart (updated)
        └── presentation/
            └── providers/
                └── booking_notifier.dart (updated)
```

---

**Congratulations!** You've successfully implemented local persistence with Floor. Your app now has a real database! 🎉
