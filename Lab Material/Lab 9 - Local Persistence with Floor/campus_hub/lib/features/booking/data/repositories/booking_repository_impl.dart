import '../../domain/entities/booking.dart';
import '../../domain/contracts/booking_repository.dart';
import '../datasources/local/booking_local_data_source_impl.dart';
import '../../../../core/domain/enums/booking_status.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource localDataSource;

  BookingRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Booking>> getAllBookings() async {
    try {
      return await localDataSource.getBookings();
    } catch (e) {
      throw Exception('Failed to load bookings: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getBookingsByStudent(String studentId) async {
    try {
      final bookings = await getAllBookings();
      return bookings
          .where((booking) => booking.studentId == studentId)
          .toList();
    } catch (e) {
      throw Exception('Failed to load student bookings: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getStudentBookingHistory(String studentId) async {
    try {
      final bookings = await getBookingsByStudent(studentId);
      // Sort by booking date (most recent first)
      bookings.sort((a, b) => b.bookedAt.compareTo(a.bookedAt));
      return bookings;
    } catch (e) {
      throw Exception(
        'Failed to load student booking history: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Booking>> getStudentUpcomingBookings(String studentId) async {
    try {
      final bookings = await getBookingsByStudent(studentId);
      final now = DateTime.now();

      return bookings
          .where(
            (booking) =>
                (booking.isConfirmed || booking.isPending) &&
                booking.bookedAt.isAfter(now),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load upcoming bookings: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getBookingsBySession(String sessionId) async {
    try {
      final bookings = await getAllBookings();
      return bookings
          .where((booking) => booking.sessionId == sessionId)
          .toList();
    } catch (e) {
      throw Exception('Failed to load session bookings: ${e.toString()}');
    }
  }

  @override
  Future<int> getSessionBookingCount(String sessionId) async {
    try {
      final bookings = await getBookingsBySession(sessionId);
      return bookings.where((b) => b.isConfirmed || b.isPending).length;
    } catch (e) {
      throw Exception('Failed to get session booking count: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getBookingsByStatus(String status) async {
    try {
      final bookings = await getAllBookings();
      return bookings
          .where(
            (booking) => booking.status == BookingStatus.fromString(status),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load bookings by status: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getPendingBookings() async {
    try {
      return await getBookingsByStatus('pending');
    } catch (e) {
      throw Exception('Failed to load pending bookings: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getConfirmedBookings() async {
    try {
      return await getBookingsByStatus('confirmed');
    } catch (e) {
      throw Exception('Failed to load confirmed bookings: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getAttendedBookings() async {
    try {
      return await getBookingsByStatus('attended');
    } catch (e) {
      throw Exception('Failed to load attended bookings: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getCancelledBookings() async {
    try {
      return await getBookingsByStatus('cancelled');
    } catch (e) {
      throw Exception('Failed to load cancelled bookings: ${e.toString()}');
    }
  }

  @override
  Future<Booking?> getBookingById(String id) async {
    try {
      final bookings = await localDataSource.getBookings();
      try {
        return bookings.firstWhere((booking) => booking.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load booking: ${e.toString()}');
    }
  }

  @override
  Future<void> createBooking(Booking booking) async {
    try {
      await localDataSource.saveBooking(booking);
    } catch (e) {
      throw Exception('Failed to create booking: ${e.toString()}');
    }
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    try {
      await localDataSource.updateBooking(booking);
    } catch (e) {
      throw Exception('Failed to update booking: ${e.toString()}');
    }
  }

  @override
  Future<void> updateBookingStatus(String id, String status) async {
    try {
      final booking = await getBookingById(id);
      if (booking != null) {
        final updatedBooking = Booking(
          id: booking.id,
          sessionId: booking.sessionId,
          studentId: booking.studentId,
          status: status,
          bookedAtMillis: booking.bookedAtMillis,
          reason: booking.reason,
        );
        await updateBooking(updatedBooking);
      }
    } catch (e) {
      throw Exception('Failed to update booking status: ${e.toString()}');
    }
  }

  @override
  Future<void> cancelBooking(String id) async {
    try {
      await updateBookingStatus(id, 'cancelled');
    } catch (e) {
      throw Exception('Failed to cancel booking: ${e.toString()}');
    }
  }

  @override
  Future<bool> canStudentBookSession(String studentId, String sessionId) async {
    try {
      final existingBookings = await getBookingsByStudent(studentId);

      // Check if student already has a booking for this session
      final hasExistingBooking = existingBookings.any(
        (booking) =>
            booking.sessionId == sessionId &&
            (booking.isConfirmed || booking.isPending),
      );

      return !hasExistingBooking;
    } catch (e) {
      throw Exception('Failed to check booking eligibility: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getBookingsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final bookings = await getAllBookings();
      return bookings
          .where(
            (booking) =>
                booking.bookedAt.isAfter(start) &&
                booking.bookedAt.isBefore(end),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load bookings by date range: ${e.toString()}');
    }
  }
}
