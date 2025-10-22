// TODO: Phase 1.2 & 1.5 - Add Floor Annotations and Foreign Keys
//
// PART 1: Basic Floor Annotations (Phase 1.2)
// 1. Import the Floor package: import 'package:floor/floor.dart';
// 2. Add @Entity annotation above the class (capital E, not lowercase)
// 3. Add @primaryKey annotation above the 'id' field
//
// PART 2: Foreign Key Constraints (Phase 1.5 - REQUIRED)
// This Booking entity has TWO one-to-many relationships:
//
// Relationship 1: Session (1) → Booking (many)
// - One Session can have MANY Bookings
// - Each Booking belongs to ONE Session (via sessionId)
// - onDelete: ForeignKeyAction.cascade
//   (When a session is deleted, automatically delete all its bookings)
//
// Relationship 2: Student (1) → Booking (many)
// - One Student can make MANY Bookings
// - Each Booking belongs to ONE Student (via studentId)
// - onDelete: ForeignKeyAction.restrict
//   (Prevent deleting a student who has bookings - preserve history)
//
// To implement BOTH foreign keys:
// 1. Use @Entity (capital E) with a foreignKeys parameter
// 2. The foreignKeys parameter takes a LIST of ForeignKey objects
// 3. Create TWO ForeignKey objects (one for sessionId, one for studentId)
//
// Structure for multiple foreign keys:
// @Entity(
//   foreignKeys: [
//     ForeignKey(
//       childColumns: ['FIELD_1'],
//       parentColumns: ['id'],
//       entity: ParentEntity1,
//       onDelete: ForeignKeyAction.cascade,
//     ),
//     ForeignKey(
//       childColumns: ['FIELD_2'],
//       parentColumns: ['id'],
//       entity: ParentEntity2,
//       onDelete: ForeignKeyAction.restrict,
//     ),
//   ],
// )
//
// Hints:
// - Import Session entity: import '../../../session_management/domain/entities/session.dart';
// - Import Student entity: import '../../../user_management/domain/entities/student.dart';
// - Check Lab 9 document Phase 1.5 for complete example!

import '../../../../core/domain/enums/booking_status.dart';

// TODO: Add your @Entity annotation here with TWO foreign keys in the foreignKeys list

class Booking {
  // TODO: Add @primaryKey annotation here
  final String id;
  final String sessionId;  // Foreign key referencing Session.id
  final String studentId;  // Foreign key referencing Student.id

  // Floor doesn't support enums directly - store as String
  final String status;

  // Floor doesn't support DateTime directly - store as milliseconds
  final int bookedAtMillis;

  final String? reason;

  const Booking({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.status,
    required this.bookedAtMillis,
    this.reason,
  });

  // Helper getters for convenient access
  DateTime get bookedAt => DateTime.fromMillisecondsSinceEpoch(bookedAtMillis);
  BookingStatus get bookingStatus => BookingStatus.fromString(status);

  bool get isPending => bookingStatus == BookingStatus.pending;
  bool get isConfirmed => bookingStatus == BookingStatus.confirmed;
  bool get isCancelled => bookingStatus == BookingStatus.cancelled;
  bool get isAttended => bookingStatus == BookingStatus.attended;

  // Factory for creating from DateTime and Enum
  factory Booking.create({
    required String id,
    required String sessionId,
    required String studentId,
    required BookingStatus status,
    required DateTime bookedAt,
    String? reason,
  }) {
    return Booking(
      id: id,
      sessionId: sessionId,
      studentId: studentId,
      status: status.value,
      bookedAtMillis: bookedAt.millisecondsSinceEpoch,
      reason: reason,
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      studentId: json['studentId'] as String,
      status: json['status'] is String
          ? json['status'] as String
          : (json['status'] as BookingStatus).value,
      bookedAtMillis: json['bookedAt'] != null
          ? DateTime.parse(json['bookedAt'] as String).millisecondsSinceEpoch
          : json['bookedAtMillis'] as int,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'studentId': studentId,
      'status': status,
      'bookedAt': bookedAt.toIso8601String(),
      'reason': reason,
    };
  }

  Booking copyWith({
    String? id,
    String? sessionId,
    String? studentId,
    String? status,
    int? bookedAtMillis,
    String? reason,
  }) {
    return Booking(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
      bookedAtMillis: bookedAtMillis ?? this.bookedAtMillis,
      reason: reason ?? this.reason,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Booking(id: $id, sessionId: $sessionId, studentId: $studentId, status: $status)';
}
