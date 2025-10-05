import '../entities/booking.dart';
import '../contracts/booking_repository.dart';

class GetStudentBookingsSummary {
  final BookingRepository repository;

  GetStudentBookingsSummary(this.repository);

  Future<Map<String, dynamic>> call(String studentId) async {
    final allBookings = await repository.getBookingsByStudent(studentId);
    final now = DateTime.now();

    // Categorize bookings
    final upcoming = <Booking>[];
    final past = <Booking>[];
    final pending = <Booking>[];
    final cancelled = <Booking>[];

    for (final booking in allBookings) {
      if (booking.isCancelled) {
        cancelled.add(booking);
      } else if (booking.isPending) {
        pending.add(booking);
      } else if (booking.bookedAt.isAfter(now)) {
        upcoming.add(booking);
      } else {
        past.add(booking);
      }
    }

    // Calculate statistics
    final totalBookings = allBookings.length;
    final attendedBookings = allBookings.where((b) => b.isAttended).length;
    final attendanceRate = totalBookings > 0
        ? (attendedBookings / totalBookings * 100).round()
        : 0;

    return {
      'totalBookings': totalBookings,
      'upcomingBookings': upcoming.length,
      'pastBookings': past.length,
      'pendingBookings': pending.length,
      'cancelledBookings': cancelled.length,
      'attendedBookings': attendedBookings,
      'attendanceRate': attendanceRate,
      'upcomingBookingsList': upcoming,
      'pendingBookingsList': pending,
    };
  }
}
