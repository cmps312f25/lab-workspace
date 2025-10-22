// TODO: Phase 3.1 - Create AppDatabase Class
//
// The AppDatabase class is the main database configuration for your app.
// It tells Floor which entities (tables) and DAOs exist in your database.
//
// INSTRUCTIONS:
// 1. Import necessary packages:
//    - import 'dart:async';
//    - import 'package:floor/floor.dart';
//    - import 'package:sqflite/sqflite.dart' as sqflite;
//
// 2. Import all entity classes:
//    - Student: import '../../../features/user_management/domain/entities/student.dart';
//    - Session: import '../../../features/session_management/domain/entities/session.dart';
//    - Booking: import '../../../features/booking/domain/entities/booking.dart';
//
// 3. Import all DAO classes:
//    - SessionDao: import 'daos/session_dao.dart';
//    - BookingDao: import 'daos/booking_dao.dart';
//
// 4. Add a 'part' directive for the generated file:
//    part 'app_database.g.dart';
//    This file will be created by Floor's code generator
//
// 5. Add @Database annotation with:
//    - version: 1 (increment this when you change the schema)
//    - entities: [Student, Session, Booking] (list all entity classes)
//
// 6. Create an abstract class that extends FloorDatabase
//
// 7. Add abstract getters for each DAO:
//    - SessionDao get sessionDao;
//    - BookingDao get bookingDao;
//
// IMPORTANT NOTES:
// - The class must be abstract (Floor generates the implementation)
// - The part directive MUST match the generated file name exactly
// - All entities with foreign keys will have those constraints enforced
// - Floor validates the database schema matches your annotations
//
// Example structure:
// @Database(version: 1, entities: [Entity1, Entity2])
// abstract class AppDatabase extends FloorDatabase {
//   DaoClass get daoName;
// }
//
// Hint: Check Lab 9 document Phase 3.1 for complete template!

// TODO: Add all imports here (dart:async, floor, sqflite, entities, daos)

// TODO: Add part directive for 'app_database.g.dart'

// TODO: Add @Database annotation with version and entities list
abstract class AppDatabase extends FloorDatabase {
  // TODO: Add SessionDao getter

  // TODO: Add BookingDao getter
}
