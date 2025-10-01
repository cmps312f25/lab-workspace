import '../entities/booking.dart';
import '../contracts/booking_repository.dart';
import '../../../session_management/domain/contracts/session_repository.dart';
import '../../../user_management/domain/contracts/user_repository.dart';

class CreateBookingWithValidation {
  final BookingRepository bookingRepository;
  final SessionRepository sessionRepository;
  final UserRepository userRepository;

  CreateBookingWithValidation(
    this.bookingRepository,
    this.sessionRepository,
    this.userRepository,
  );

  Future<void> call(Booking booking) async {
    // 1. Validate session exists and is available
    final session = await sessionRepository.getSessionById(booking.sessionId);
    if (session == null) {
      throw Exception('Session not found');
    }

    if (!session.isOpen) {
      throw Exception('Session is not available for booking');
    }

    if (session.start.isBefore(DateTime.now())) {
      throw Exception('Cannot book past sessions');
    }

    // 2. Check session capacity
    final existingBookings = await bookingRepository.getBookingsBySession(
      booking.sessionId,
    );
    final confirmedBookings = existingBookings
        .where((b) => b.isConfirmed || b.isPending)
        .length;

    if (confirmedBookings >= session.capacity) {
      throw Exception('Session is full');
    }

    // 3. Check if student already booked this session
    final studentBookings = await bookingRepository.getBookingsByStudent(
      booking.studentId,
    );
    final alreadyBooked = studentBookings.any(
      (b) => b.sessionId == booking.sessionId && (b.isConfirmed || b.isPending),
    );

    if (alreadyBooked) {
      throw Exception('You have already booked this session');
    }

    // 4. Validate student needs help with this course (business logic)
    final student = await userRepository.getStudentById(booking.studentId);
    if (student != null) {
      if (!student.needsHelpWith(session.courseId)) {
        // Warning but don't block - student might want to prepare for future course
        // Could add this to booking reason
      }
    }

    // 5. Create the booking
    await bookingRepository.createBooking(booking);
  }
}
