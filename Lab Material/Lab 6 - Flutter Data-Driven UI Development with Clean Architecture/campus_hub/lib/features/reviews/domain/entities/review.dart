import '../../../../core/domain/enums/review_rating.dart';

class Review {
  final String id;
  final String bookingId;
  final ReviewRating rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.bookingId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      rating: ReviewRating.fromDouble((json['rating'] as num).toDouble()),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'rating': rating.value,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Review(id: $id, bookingId: $bookingId, rating: ${rating.value})';
}
