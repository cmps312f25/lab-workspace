import '../entities/booking.dart';

abstract class BookingRepository {
  // Get all bookings
  Future<List<Booking>> getAllBookings();

  // Get bookings by student
  Future<List<Booking>> getBookingsByStudent(String studentId);
  Future<List<Booking>> getStudentBookingHistory(String studentId);
  Future<List<Booking>> getStudentUpcomingBookings(String studentId);

  // Get bookings by session
  Future<List<Booking>> getBookingsBySession(String sessionId);
  Future<int> getSessionBookingCount(String sessionId);

  // Get bookings by status
  Future<List<Booking>> getBookingsByStatus(String status);
  Future<List<Booking>> getPendingBookings();
  Future<List<Booking>> getConfirmedBookings();
  Future<List<Booking>> getAttendedBookings();
  Future<List<Booking>> getCancelledBookings();

  // Get specific booking
  Future<Booking?> getBookingById(String id);

  // Booking operations
  Future<void> createBooking(Booking booking);
  Future<void> updateBooking(Booking booking);
  Future<void> updateBookingStatus(String id, String status);
  Future<void> cancelBooking(String id);

  // Business logic
  Future<bool> canStudentBookSession(String studentId, String sessionId);
  Future<List<Booking>> getBookingsByDateRange(DateTime start, DateTime end);
}
