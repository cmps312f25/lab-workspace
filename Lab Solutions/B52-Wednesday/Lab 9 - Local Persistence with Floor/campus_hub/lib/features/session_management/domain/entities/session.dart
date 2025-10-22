// TODO: Phase 1.1 & 1.5 - Add Floor Annotations and Foreign Keys
//
// PART 1: Basic Floor Annotations (Phase 1.1)
// 1. Import the Floor package: import 'package:floor/floor.dart';
// 2. Add @Entity annotation above the class (capital E, not lowercase)
// 3. Add @primaryKey annotation above the 'id' field
//
// PART 2: Foreign Key Constraint (Phase 1.5 - REQUIRED)
// This Session entity has a one-to-many relationship with Student:
// - One Student (tutor) can have MANY Sessions
// - Each Session belongs to ONE Student (via tutorId)
//
// To enforce this relationship at the database level:
// 1. Use @Entity (capital E) instead of @entity
// 2. Add a foreignKeys parameter with a ForeignKey object:
//    - childColumns: ['tutorId'] (the field in THIS table)
//    - parentColumns: ['id'] (the field in the Student table it references)
//    - entity: Student (import Student entity first!)
//    - onDelete: ForeignKeyAction.restrict (prevents deleting a tutor who has sessions)
//
// Example structure:
// @Entity(
//   foreignKeys: [
//     ForeignKey(
//       childColumns: ['YOUR_FIELD'],
//       parentColumns: ['PARENT_ID_FIELD'],
//       entity: ParentEntityClass,
//       onDelete: ForeignKeyAction.restrict,
//     ),
//   ],
// )
//
// Hint: Check the Lab 9 document Phase 1.5 for the complete syntax!
// Hint: You'll need to import: import '../../../user_management/domain/entities/student.dart';

import '../../../../core/domain/enums/session_status.dart';

// TODO: Add your @Entity annotation here with foreignKeys parameter

class Session {
  // TODO: Add @primaryKey annotation here
  final String id;
  final String tutorId;  // This is the foreign key field referencing Student.id
  final String courseId;

  // Floor doesn't support DateTime directly - store as milliseconds
  final int startMillis;
  final int endMillis;

  final int capacity;
  final String location;

  // Floor doesn't support enums directly - store as String
  final String status;

  const Session({
    required this.id,
    required this.tutorId,
    required this.courseId,
    required this.startMillis,
    required this.endMillis,
    required this.capacity,
    required this.location,
    required this.status,
  });

  // Helper getters for convenient access
  DateTime get start => DateTime.fromMillisecondsSinceEpoch(startMillis);
  DateTime get end => DateTime.fromMillisecondsSinceEpoch(endMillis);
  SessionStatus get sessionStatus => SessionStatus.fromString(status);

  Duration get duration => end.difference(start);
  bool get isOpen => sessionStatus == SessionStatus.open;
  bool get isClosed => sessionStatus == SessionStatus.closed;
  bool get isCancelled => sessionStatus == SessionStatus.cancelled;

  // Factory for creating from DateTime and Enum
  factory Session.create({
    required String id,
    required String tutorId,
    required String courseId,
    required DateTime start,
    required DateTime end,
    required int capacity,
    required String location,
    required SessionStatus status,
  }) {
    return Session(
      id: id,
      tutorId: tutorId,
      courseId: courseId,
      startMillis: start.millisecondsSinceEpoch,
      endMillis: end.millisecondsSinceEpoch,
      capacity: capacity,
      location: location,
      status: status.value,
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      tutorId: json['tutorId'] as String,
      courseId: json['courseId'] as String,
      startMillis: json['start'] != null
          ? DateTime.parse(json['start'] as String).millisecondsSinceEpoch
          : json['startMillis'] as int,
      endMillis: json['end'] != null
          ? DateTime.parse(json['end'] as String).millisecondsSinceEpoch
          : json['endMillis'] as int,
      capacity: json['capacity'] as int,
      location: json['location'] as String,
      status: json['status'] is String
          ? json['status'] as String
          : (json['status'] as SessionStatus).value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutorId': tutorId,
      'courseId': courseId,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'capacity': capacity,
      'location': location,
      'status': status,
    };
  }

  Session copyWith({
    String? id,
    String? tutorId,
    String? courseId,
    int? startMillis,
    int? endMillis,
    int? capacity,
    String? location,
    String? status,
  }) {
    return Session(
      id: id ?? this.id,
      tutorId: tutorId ?? this.tutorId,
      courseId: courseId ?? this.courseId,
      startMillis: startMillis ?? this.startMillis,
      endMillis: endMillis ?? this.endMillis,
      capacity: capacity ?? this.capacity,
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }

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
