import '../entities/session.dart';
import '../contracts/session_repository.dart';
import '../../../booking/domain/contracts/booking_repository.dart';

class GetAvailableSessions {
  final SessionRepository sessionRepository;
  final BookingRepository bookingRepository;

  GetAvailableSessions(this.sessionRepository, this.bookingRepository);

  Future<List<Session>> call({
    String? courseId,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
  }) async {
    var sessions = await sessionRepository.getOpenSessions();

    // Filter by course if specified
    if (courseId != null) {
      sessions = sessions
          .where((session) => session.courseId == courseId)
          .toList();
    }

    // Filter by date range
    if (startDate != null) {
      sessions = sessions
          .where((session) => session.start.isAfter(startDate))
          .toList();
    }
    if (endDate != null) {
      sessions = sessions
          .where((session) => session.start.isBefore(endDate))
          .toList();
    }

    // Filter by location
    if (location != null) {
      sessions = sessions
          .where(
            (session) =>
                session.location.toLowerCase().contains(location.toLowerCase()),
          )
          .toList();
    }

    // Filter out full sessions (check actual bookings vs capacity)
    final availableSessions = <Session>[];
    for (final session in sessions) {
      final bookings = await bookingRepository.getBookingsBySession(session.id);
      final confirmedBookings = bookings
          .where((b) => b.isConfirmed || b.isPending)
          .length;

      if (confirmedBookings < session.capacity) {
        availableSessions.add(session);
      }
    }

    // Sort by date (earliest first)
    availableSessions.sort((a, b) => a.start.compareTo(b.start));

    return availableSessions;
  }
}
