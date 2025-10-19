// TODO: Phase 8.2 - Update BookingNotifier to use Database
//
// Same pattern as SessionNotifier - initialize database and seed it.
//
// INSTRUCTIONS:
// 1. Add standard imports:
//    - import 'package:flutter_riverpod/flutter_riverpod.dart';
//    - import '../../domain/contracts/booking_repository.dart';
//    - import '../../data/repositories/booking_repository_impl.dart';
//    - import '../../data/datasources/local/booking_local_data_source_impl.dart';
//    - import 'states/booking_state.dart';
//
// 2. Add database imports:
//    - import '../../../../core/data/database/database_provider.dart';
//    - import '../../../../core/data/database/database_seeder.dart';
//
// 3. Update the _initializeRepository() method:
//
//    Future<void> _initializeRepository() async {
//      // TODO: Get database from provider
//      // Use: await ref.read(databaseProvider.future)
//
//      // TODO: Seed the database if needed
//      // Use: await DatabaseSeeder.seedDatabase(database)
//
//      // TODO: Create repository with BookingLocalDataSource
//      // Pass database.bookingDao to BookingLocalDataSource constructor
//      // bookingRepository = BookingRepositoryImpl(
//      //   localDataSource: BookingLocalDataSource(database.bookingDao),
//      // );
//    }
//
// IMPORTANT NOTE:
// The rest of the BookingNotifier class stays the same!
// You only need to update _initializeRepository() to use the database.
//
// Hint: Check Lab 9 document Phase 8.2 for complete example!

// TODO: Add all imports here (riverpod, contracts, repository, data source, database_provider, database_seeder, state)

class BookingNotifier extends AsyncNotifier<BookingData> {
  late BookingRepository bookingRepository;

  @override
  Future<BookingData> build() async {
    await _initializeRepository();
    return BookingData();
  }

  Future<void> _initializeRepository() async {
    // TODO: Get database from provider using await ref.read(databaseProvider.future)

    // TODO: Seed the database using await DatabaseSeeder.seedDatabase(database)

    // TODO: Create repository with BookingLocalDataSource
    // Pass database.bookingDao to BookingLocalDataSource constructor
  }

  Future<void> loadAllBookings() async {
    // With AsyncNotifier, wrap your state in AsyncValue
    // Set state to loading, then load data, then set state to data using AsyncData
    // Don't forget to handle errors with try-catch
    state = const AsyncValue.loading();
    try {
      final bookings = await bookingRepository.getAllBookings();
      state = AsyncData(BookingData(bookings: bookings));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadBookingsByStudent(String studentId) async {
    // Same pattern as loadAllBookings
    state = const AsyncValue.loading();
    try {
      final bookings = await bookingRepository.getBookingsByStudent(studentId);
      state = AsyncData(BookingData(bookings: bookings));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadBookingsBySession(String sessionId) async {
    // Same AsyncValue pattern as above
    state = const AsyncValue.loading();
    try {
      final bookings = await bookingRepository.getBookingsBySession(sessionId);
      state = AsyncData(BookingData(bookings: bookings));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadBookingById(String bookingId) async {
    // Keep existing bookings list and add the selectedBooking
    // Access current state's bookings using state.value
    state = const AsyncValue.loading();
    try {
      final booking = await bookingRepository.getBookingById(bookingId);
      state = AsyncData(BookingData(
        bookings: state.value?.bookings ?? [],
        selectedBooking: booking,
      ));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

// Use AsyncNotifierProvider (not NotifierProvider!) since we're using AsyncNotifier
// The provider should be named: bookingNotifierProvider
final bookingNotifierProvider = AsyncNotifierProvider<BookingNotifier, BookingData>(
  () => BookingNotifier(),
);
