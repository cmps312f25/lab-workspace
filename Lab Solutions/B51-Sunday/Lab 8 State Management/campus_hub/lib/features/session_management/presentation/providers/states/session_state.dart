import '../../../domain/entities/session.dart';

class SessionData {
  final List<Session> sessions;
  final Session? selectedSession;

  SessionData({
    this.sessions = const [],
    this.selectedSession,
  });
}
