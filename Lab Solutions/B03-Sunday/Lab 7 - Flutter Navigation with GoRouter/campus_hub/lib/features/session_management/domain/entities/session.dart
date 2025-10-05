import '../../../../core/domain/enums/session_status.dart';

class Session {
  final String id;
  final String tutorId;
  final String courseId; // Changed from subjectId to courseId
  final DateTime start;
  final DateTime end;
  final int capacity;
  final String location;
  final SessionStatus status;

  const Session({
    required this.id,
    required this.tutorId,
    required this.courseId, // Changed from subjectId to courseId
    required this.start,
    required this.end,
    required this.capacity,
    required this.location,
    required this.status,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      tutorId: json['tutorId'] as String,
      courseId: json['courseId'] as String, // Reading from 'courseId' field
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      capacity: json['capacity'] as int,
      location: json['location'] as String,
      status: SessionStatus.fromString(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutorId': tutorId,
      'courseId': courseId, // Saving as 'courseId'
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'capacity': capacity,
      'location': location,
      'status': status.value,
    };
  }

  Duration get duration => end.difference(start);
  bool get isOpen => status == SessionStatus.open;
  bool get isClosed => status == SessionStatus.closed;
  bool get isCancelled => status == SessionStatus.cancelled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Session && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Session(id: $id, tutorId: $tutorId, courseId: $courseId, location: $location)';
}
