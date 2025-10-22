// TODO: Phase 6.1 - Create Database Seeder
//
// The DatabaseSeeder class loads initial data from JSON files into the database.
// This only happens once - the first time the app runs.
//
// INSTRUCTIONS:
// 1. Import necessary packages:
//    - import 'dart:convert'; (for json.decode)
//    - import 'package:flutter/services.dart'; (for rootBundle)
//
// 2. Import entities:
//    - Session: import '../../../features/session_management/domain/entities/session.dart';
//    - Booking: import '../../../features/booking/domain/entities/booking.dart';
//
// 3. Import AppDatabase: import 'app_database.dart';
//
// 4. Create DatabaseSeeder class with a static seedDatabase method:
//    static Future<void> seedDatabase(AppDatabase database) async { }
//
// 5. Inside seedDatabase method:
//    a) Check if database already has data (to avoid re-seeding)
//       - Call database.sessionDao.getAllSessions()
//       - If the list is not empty, return early
//
//    b) Seed Sessions:
//       - Load JSON: await rootBundle.loadString('assets/json/sessions_sample.json')
//       - Parse JSON: json.decode(jsonString)
//       - Map to Session objects: jsonData.map((json) => Session.fromJson(json)).toList()
//       - Insert: database.sessionDao.insertSessions(sessions)
//
//    c) Seed Bookings:
//       - Same process with 'assets/json/bookings_sample.json'
//       - Map to Booking objects
//       - Insert: database.bookingDao.insertBookings(bookings)
//
// IMPORTANT NOTES ABOUT FOREIGN KEYS:
// - You MUST seed Sessions BEFORE Bookings!
// - Why? Because Bookings have foreign keys referencing Sessions
// - If you try to insert a Booking before its Session exists, Floor will throw an error
// - Order matters: Sessions first, then Bookings
//
// - Similarly, if Student data needs to be seeded, it must be done BEFORE Sessions
//   (because Sessions reference Students via tutorId)
//
// OPTIONAL: Add a clearDatabase method for testing:
// static Future<void> clearDatabase(AppDatabase database) async {
//   await database.sessionDao.deleteAllSessions();
//   await database.bookingDao.deleteAllBookings();
// }
//
// Hint: Check Lab 9 document Phase 6.1 for complete code template!

// TODO: Add imports here (dart:convert, flutter/services, entities, app_database)

class DatabaseSeeder {
  // TODO: Create static seedDatabase method
  // static Future<void> seedDatabase(AppDatabase database) async {
  //   // TODO: Check if already seeded
  //
  //   // TODO: Seed Sessions (create _seedSessions helper method)
  //
  //   // TODO: Seed Bookings (create _seedBookings helper method)
  // }

  // TODO: Create static _seedSessions helper method
  // static Future<void> _seedSessions(AppDatabase database) async {
  //   // Load JSON, parse, map to Session objects, insert
  // }

  // TODO: Create static _seedBookings helper method
  // static Future<void> _seedBookings(AppDatabase database) async {
  //   // Load JSON, parse, map to Booking objects, insert
  // }

  // TODO (OPTIONAL): Create clearDatabase method for testing
}
