import '../../../domain/entities/booking.dart';

class BookingData {
  final List<Booking> bookings;
  final Booking? selectedBooking;

  BookingData({
    this.bookings = const [],
    this.selectedBooking,
  });
}
