import '../../../../core/domain/enums/booking_status.dart';

class Booking {
  final String id;
  final String sessionId;
  final String studentId;
  final BookingStatus status;
  final DateTime bookedAt;
  final String? reason; // Why the student needs tutoring

  const Booking({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.status,
    required this.bookedAt,
    this.reason,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      studentId: json['studentId'] as String,
      status: BookingStatus.fromString(json['status'] as String),
      bookedAt: DateTime.parse(json['bookedAt'] as String),
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'studentId': studentId,
      'status': status.value,
      'bookedAt': bookedAt.toIso8601String(),
      'reason': reason,
    };
  }

  bool get isPending => status == BookingStatus.pending;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isAttended => status == BookingStatus.attended;

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
