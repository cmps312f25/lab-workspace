import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/contracts/booking_repository.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/datasources/local/booking_local_data_source_impl.dart';
import 'states/booking_state.dart';

// Booking Notifier
// TODO 1: Make this class extend AsyncNotifier<BookingData>
// AsyncNotifier is used for asynchronous operations like loading data from repositories
class BookingNotifier {
  late BookingRepository bookingRepository;

  // TODO 2: Override the build() method to return Future<BookingData>
  // This method is called when the notifier is first created
  // It must be async and return a Future because we're using AsyncNotifier
  // Initialize the repository and return an empty BookingData() as initial state

  Future<void> _initializeRepository() async {
    bookingRepository = BookingRepositoryImpl(
      localDataSource: BookingLocalDataSource(),
    );
  }

  Future<void> loadAllBookings() async {
    // TODO 9: Update state with all bookings
    // With AsyncNotifier, wrap your state in AsyncValue
    // Set state to loading, then load data, then set state to data using AsyncData
    // Don't forget to handle errors with try-catch
  }

  Future<void> loadBookingsByStudent(String studentId) async {
    // TODO 10: Update state with student's bookings
    // Same pattern as loadAllBookings
  }

  Future<void> loadBookingsBySession(String sessionId) async {
    // TODO 11: Update state with session's bookings
    // Same AsyncValue pattern as above
  }

  Future<void> loadBookingById(String bookingId) async {
    // TODO 12: Update state with selected booking
    // Keep existing bookings list and add the selectedBooking
    // Access current state's bookings using state.value
  }
}

// TODO 4: Create a global provider to make BookingNotifier accessible throughout the app
// Use AsyncNotifierProvider (not NotifierProvider!) since we're using AsyncNotifier
// The provider should be named: bookingNotifierProvider
