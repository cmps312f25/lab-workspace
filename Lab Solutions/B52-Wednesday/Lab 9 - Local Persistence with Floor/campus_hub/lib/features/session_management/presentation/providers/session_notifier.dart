// TODO: Phase 8.1 - Update SessionNotifier to use Database
//
// The notifier needs to initialize the database and seed it on first run.
//
// INSTRUCTIONS:
// 1. Add standard imports:
//    - import 'package:flutter_riverpod/flutter_riverpod.dart';
//    - import '../../domain/contracts/session_repository.dart';
//    - import '../../data/repositories/session_repository_impl.dart';
//    - import '../../data/datasources/local/session_local_data_source_impl.dart';
//    - import 'states/session_state.dart';
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
//      // TODO: Create repository with SessionLocalDataSource
//      // Pass database.sessionDao to SessionLocalDataSource constructor
//      // sessionRepository = SessionRepositoryImpl(
//      //   localDataSource: SessionLocalDataSource(database.sessionDao),
//      // );
//    }
//
// IMPORTANT NOTE:
// The rest of the SessionNotifier class stays the same!
// You only need to update _initializeRepository() to use the database.
//
// Hint: Check Lab 9 document Phase 8.1 for complete example!

// TODO: Add all imports here (riverpod, contracts, repository, data source, database_provider, database_seeder, state)

class SessionNotifier extends AsyncNotifier<SessionData> {
  late SessionRepository sessionRepository;

  @override
  Future<SessionData> build() async {
    await _initializeRepository();
    return SessionData();
  }

  Future<void> _initializeRepository() async {
    // TODO: Get database from provider using await ref.read(databaseProvider.future)

    // TODO: Seed the database using await DatabaseSeeder.seedDatabase(database)

    // TODO: Create repository with SessionLocalDataSource
    // Pass database.sessionDao to SessionLocalDataSource constructor
  }

  Future<void> loadAllSessions() async {
    // With AsyncNotifier, wrap your state in AsyncValue
    // Set state to loading, then load data, then set state to data using AsyncData
    // Don't forget to handle errors with try-catch
    state = const AsyncValue.loading();
    try {
      final sessions = await sessionRepository.getAllSessions();
      state = AsyncData(SessionData(sessions: sessions));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadAvailableSessions() async {
    // Same pattern as loadAllSessions, but filter for sessions where isOpen is true
    state = const AsyncValue.loading();
    try {
      final sessions = await sessionRepository.getOpenSessions();
      state = AsyncData(SessionData(sessions: sessions));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadSessionsByTutor(String tutorId) async {
    // Same AsyncValue pattern as above
    state = const AsyncValue.loading();
    try {
      final sessions = await sessionRepository.getSessionsByTutor(tutorId);
      state = AsyncData(SessionData(sessions: sessions));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadSessionById(String sessionId) async {
    // Keep existing sessions list and add the selectedSession
    // Access current state's sessions using state.value
    state = const AsyncValue.loading();
    try {
      final session = await sessionRepository.getSessionById(sessionId);
      state = AsyncData(SessionData(
        sessions: state.value?.sessions ?? [],
        selectedSession: session,
      ));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

// Use AsyncNotifierProvider (not NotifierProvider!) since we're using AsyncNotifier
// The provider should be named: sessionNotifierProvider
final sessionNotifierProvider = AsyncNotifierProvider<SessionNotifier, SessionData>(
  () => SessionNotifier(),
);
