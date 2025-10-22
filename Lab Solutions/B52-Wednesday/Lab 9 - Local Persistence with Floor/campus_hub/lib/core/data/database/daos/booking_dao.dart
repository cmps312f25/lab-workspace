// TODO: Phase 2.2 - Create BookingDao
//
// This DAO manages Booking entities, which have TWO foreign key relationships:
// - Booking → Session (via sessionId)
// - Booking → Student (via studentId)
//
// INSTRUCTIONS:
// 1. Import Floor: import 'package:floor/floor.dart';
// 2. Import Booking entity: import '../../../../features/booking/domain/entities/booking.dart';
// 3. Add @dao annotation above the class
// 4. Make this an abstract class
// 5. Add the following methods with appropriate annotations:
//
// QUERY METHODS (use @Query annotation with SQL):
// - Future<List<Booking>> getAllBookings()
//   SQL: 'SELECT * FROM Booking'
//
// - Future<Booking?> getBookingById(String id)
//   SQL: 'SELECT * FROM Booking WHERE id = :id'
//   Returns Booking? (nullable) because booking might not exist
//
// - Future<List<Booking>> getBookingsBySession(String sessionId)
//   SQL: 'SELECT * FROM Booking WHERE sessionId = :sessionId'
//   This leverages the foreign key relationship with Session
//   Shows all bookings for a specific session
//
// - Future<List<Booking>> getBookingsByStudent(String studentId)
//   SQL: 'SELECT * FROM Booking WHERE studentId = :studentId'
//   This leverages the foreign key relationship with Student
//   Shows booking history for a specific student
//
// INSERT METHODS (use @insert annotation):
// - Future<void> insertBooking(Booking booking)
//   Inserts a single booking
//   Note: Floor will validate that sessionId and studentId exist due to foreign keys!
//
// - Future<void> insertBookings(List<Booking> bookings)
//   Inserts multiple bookings (useful for seeding)
//
// UPDATE METHOD (use @update annotation):
// - Future<void> updateBooking(Booking booking)
//   Updates an existing booking
//
// DELETE METHODS (use @delete annotation or @Query):
// - Future<void> deleteBooking(Booking booking)
//   Use @delete annotation
//
// - Future<void> deleteAllBookings()
//   Use @Query('DELETE FROM Booking')
//
// IMPORTANT NOTES ABOUT FOREIGN KEYS:
// - When you insert a Booking, Floor enforces that:
//   * sessionId must reference a valid Session (or insertion fails)
//   * studentId must reference a valid Student (or insertion fails)
//
// - When you delete a Session:
//   * All its Bookings are automatically deleted (cascade)
//
// - When you try to delete a Student with Bookings:
//   * The deletion is prevented (restrict)
//
// Hint: Check Lab 9 document Phase 2.2 for complete method list!

// TODO: Add imports here

// TODO: Add @dao annotation here
abstract class BookingDao {
  // TODO: Add getAllBookings() method with @Query annotation

  // TODO: Add getBookingById(String id) method with @Query annotation

  // TODO: Add getBookingsBySession(String sessionId) method with @Query annotation

  // TODO: Add getBookingsByStudent(String studentId) method with @Query annotation

  // TODO: Add insertBooking(Booking booking) method with @insert annotation

  // TODO: Add insertBookings(List<Booking> bookings) method with @insert annotation

  // TODO: Add updateBooking(Booking booking) method with @update annotation

  // TODO: Add deleteBooking(Booking booking) method with @delete annotation

  // TODO: Add deleteAllBookings() method with @Query('DELETE FROM Booking')
}
