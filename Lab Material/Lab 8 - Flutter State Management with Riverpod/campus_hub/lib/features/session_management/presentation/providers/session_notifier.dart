import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/contracts/session_repository.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../data/datasources/local/session_local_data_source_impl.dart';
import 'states/session_state.dart';

// Session Notifier
// TODO 1: Make this class extend Notifier
// Requirements: SessionNotifier should extend the Notifier class
// Hint: Notifier is a generic class - you need to specify what state type it manages
// Hint: The state type for sessions is SessionData
class SessionNotifier {
  late SessionRepository sessionRepository;

  // TODO 2: Override the build() method to return initial state
  // Requirements:
  // - This method must be overridden from the parent class
  // - It should return SessionData as the initial state
  // - Call _initializeRepository() before returning
  // Hint: build() is called when the notifier is first created
  // Hint: Return an empty SessionData() object as the starting state

  void _initializeRepository() {
    sessionRepository = SessionRepositoryImpl(
      localDataSource: SessionLocalDataSource(),
    );
  }

  Future<void> loadAllSessions() async {
    try {
      final sessions = await sessionRepository.getAllSessions();
      // TODO 5: Update state with all sessions
      // Requirements: Assign a new SessionData object to state with the loaded sessions
      // Hint: In Riverpod, you update state by assigning to the 'state' property
      // Hint: Create a SessionData object with sessions parameter
    } catch (e) {
      print('Error loading sessions: $e');
    }
  }

  Future<void> loadAvailableSessions() async {
    try {
      final sessions = await sessionRepository.getAllSessions();
      final availableSessions = sessions.where((s) => s.isOpen).toList();
      // TODO 6: Update state with available sessions only
      // Requirements: Assign a new SessionData object to state with availableSessions
      // Hint: Similar to TODO 5, but use availableSessions instead of sessions
    } catch (e) {
      print('Error loading sessions: $e');
    }
  }

  Future<void> loadSessionsByTutor(String tutorId) async {
    try {
      final sessions = await sessionRepository.getSessionsByTutor(tutorId);
      // TODO 7: Update state with tutor's sessions
      // Requirements: Assign a new SessionData object to state with the tutor's sessions
      // Hint: Same pattern as TODO 5 and 6
    } catch (e) {
      print('Error loading tutor sessions: $e');
    }
  }

  Future<void> loadSessionById(String sessionId) async {
    try {
      final session = await sessionRepository.getSessionById(sessionId);
      // TODO 8: Update state with selected session
      // Requirements: Update state while keeping existing sessions list and adding selectedSession
      // Hint: SessionData has two parameters - sessions (keep current) and selectedSession (new)
      // Hint: You can access current state using 'state.sessions'
    } catch (e) {
      print('Error loading session: $e');
    }
  }
}

// TODO 3: Create a global provider to make SessionNotifier accessible throughout the app
// Requirements:
// - Declare a final variable named 'sessionNotifierProvider'
// - Use NotifierProvider (it's generic - needs two type parameters)
// - First type: the notifier class (SessionNotifier)
// - Second type: the state class (SessionData)
// - Pass a function that creates a new SessionNotifier instance
// Hint: This provider makes your notifier accessible via ref.read() and ref.watch()
// Hint: Look at how other providers are declared in Riverpod documentation
