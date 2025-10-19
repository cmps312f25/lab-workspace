// TODO: Phase 7.2 - Update BookingLocalDataSource to use Database
//
// Similar to SessionLocalDataSource, this will use BookingDao to interact with the database.
// Remember: Bookings have foreign keys to both Session and Student!
//
// INSTRUCTIONS:
// 1. Import Booking entity: import '../../../domain/entities/booking.dart';
// 2. Import BookingDao: import '../../../../../core/data/database/daos/booking_dao.dart';
//
// 3. Create BookingLocalDataSource class with:
//    - Private BookingDao field: final BookingDao _bookingDao;
//    - Constructor that accepts BookingDao: BookingLocalDataSource(this._bookingDao);
//
// 4. Implement the following methods using the DAO:
//
//    Future<List<Booking>> getBookings() async {
//      // TODO: Call _bookingDao.getAllBookings()
//    }
//
//    Future<void> saveBooking(Booking booking) async {
//      // TODO: Call _bookingDao.insertBooking(booking)
//      // Note: Floor will validate that sessionId and studentId exist!
//    }
//
//    Future<void> updateBooking(Booking booking) async {
//      // TODO: Call _bookingDao.updateBooking(booking)
//    }
//
//    Future<void> deleteBooking(String id) async {
//      // TODO: First get the booking by id using _bookingDao.getBookingById(id)
//      // TODO: If booking is not null, call _bookingDao.deleteBooking(booking)
//    }
//
// IMPORTANT NOTES ABOUT FOREIGN KEYS:
// - When saveBooking() is called, Floor enforces:
//   * The sessionId must reference an existing Session
//   * The studentId must reference an existing Student
//   * If either doesn't exist, Floor throws a foreign key constraint error
//
// - If you delete a Session, all its Bookings are automatically deleted (cascade)
// - You cannot delete a Student who has Bookings (restrict)
//
// Hint: Check Lab 9 document Phase 7.2 for complete example!

// TODO: Add imports here (Booking entity, BookingDao)

class BookingLocalDataSource {
  // TODO: Add BookingDao field

  // TODO: Add constructor that accepts BookingDao

  // TODO: Implement getBookings() method

  // TODO: Implement saveBooking(Booking booking) method

  // TODO: Implement updateBooking(Booking booking) method

  // TODO: Implement deleteBooking(String id) method
}
