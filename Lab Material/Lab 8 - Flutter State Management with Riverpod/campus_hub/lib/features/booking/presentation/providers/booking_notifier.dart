import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/contracts/booking_repository.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/datasources/local/booking_local_data_source_impl.dart';
import 'states/booking_state.dart';

// Booking Notifier
// TODO 1: Make this class extend Notifier
// Requirements: BookingNotifier should extend the Notifier class
// Hint: Notifier is a generic class - you need to specify what state type it manages
// Hint: The state type for bookings is BookingData
class BookingNotifier extends Notifier<BookingData>{
  late BookingRepository bookingRepository;

  // TODO 2: Override the build() method to return initial state
  // Requirements:
  // - This method must be overridden from the parent class
  // - It should return BookingData as the initial state
  // - Call _initializeRepository() before returning
  // Hint: build() is called when the notifier is first created
  // Hint: Return an empty BookingData() object as the starting state

  void _initializeRepository() {
    bookingRepository = BookingRepositoryImpl(
      localDataSource: BookingLocalDataSource(),
    );
  }

  Future<void> loadAllBookings() async {
    try {
      final bookings = await bookingRepository.getAllBookings();
      // TODO 9: Update state with all bookings
      // Requirements: Assign a new BookingData object to state with the loaded bookings
      // Hint: In Riverpod, you update state by assigning to the 'state' property
      // Hint: Create a BookingData object with bookings parameter
    } catch (e) {
      print('Error loading bookings: $e');
    }
  }

  Future<void> loadBookingsByStudent(String studentId) async {
    try {
      final bookings = await bookingRepository.getBookingsByStudent(studentId);
      // TODO 10: Update state with student's bookings
      // Requirements: Assign a new BookingData object to state with the student's bookings
      // Hint: Similar to TODO 9
    } catch (e) {
      print('Error loading bookings: $e');
    }
  }

  Future<void> loadBookingsBySession(String sessionId) async {
    try {
      final bookings = await bookingRepository.getBookingsBySession(sessionId);
      // TODO 11: Update state with session's bookings
      // Requirements: Assign a new BookingData object to state with the session's bookings
      // Hint: Same pattern as TODO 9 and 10
    } catch (e) {
      print('Error loading bookings: $e');
    }
  }

  Future<void> loadBookingById(String bookingId) async {
    try {
      final booking = await bookingRepository.getBookingById(bookingId);
      // TODO 12: Update state with selected booking
      // Requirements: Update state while keeping existing bookings list and adding selectedBooking
      // Hint: BookingData has two parameters - bookings (keep current) and selectedBooking (new)
      // Hint: You can access current state using 'state.bookings'
    } catch (e) {
      print('Error loading booking: $e');
    }
  }
}

// TODO 4: Create a global provider to make BookingNotifier accessible throughout the app
// Requirements:
// - Declare a final variable named 'bookingNotifierProvider'
// - Use NotifierProvider (it's generic - needs two type parameters)
// - First type: the notifier class (BookingNotifier)
// - Second type: the state class (BookingData)
// - Pass a function that creates a new BookingNotifier instance
// Hint: This provider makes your notifier accessible via ref.read() and ref.watch()
// Hint: Look at how other providers are declared in Riverpod documentation
