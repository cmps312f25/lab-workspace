import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/contracts/session_repository.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../data/datasources/local/session_local_data_source_impl.dart';
import 'states/session_state.dart';

// Session Notifier
// TODO 1: Make this class extend AsyncNotifier<SessionData>
// AsyncNotifier is used for asynchronous operations like loading data from repositories
class SessionNotifier {
  late SessionRepository sessionRepository;

  // TODO 2: Override the build() method to return Future<SessionData>
  // This method is called when the notifier is first created
  // It must be async and return a Future because we're using AsyncNotifier
  // Initialize the repository and return an empty SessionData() as initial state

  Future<void> _initializeRepository() async {
    sessionRepository = SessionRepositoryImpl(
      localDataSource: SessionLocalDataSource(),
    );
  }

  Future<void> loadAllSessions() async {
    // TODO 5: Update state with all sessions
    // With AsyncNotifier, wrap your state in AsyncValue
    // Set state to loading, then load data, then set state to data using AsyncData
    // Don't forget to handle errors with try-catch
  }

  Future<void> loadAvailableSessions() async {
    // TODO 6: Update state with available sessions only
    // Same pattern as loadAllSessions, but filter for sessions where isOpen is true
  }

  Future<void> loadSessionsByTutor(String tutorId) async {
    // TODO 7: Update state with tutor's sessions
    // Same AsyncValue pattern as above
  }

  Future<void> loadSessionById(String sessionId) async {
    // TODO 8: Update state with selected session
    // Keep existing sessions list and add the selectedSession
    // Access current state's sessions using state.value
  }
}

// TODO 3: Create a global provider to make SessionNotifier accessible throughout the app
// Use AsyncNotifierProvider (not NotifierProvider!) since we're using AsyncNotifier
// The provider should be named: sessionNotifierProvider
