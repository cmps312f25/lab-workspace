class Review {
  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime reviewDate;
  final String itemId;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    required this.reviewDate,
    required this.itemId,
  });

  /// Validates rating is between 1-5
  bool isValidRating() => rating >= 1 && rating <= 5;

  /// Returns comment word count
  int getWordCount() => comment.trim().split(RegExp(r'\s+')).length;

  /// Convert Review to JSON
  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
        'reviewerName': reviewerName,
        'reviewDate': reviewDate.toIso8601String(),
        'itemId': itemId,
      };

  /// Create Review from JSON
  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: json['rating'] as int,
        comment: json['comment'] as String,
        reviewerName: json['reviewerName'] as String,
        reviewDate: DateTime.parse(json['reviewDate'] as String),
        itemId: json['itemId'] as String,
      );

  @override
  String toString() =>
      'Review(rating: $rating, reviewer: $reviewerName, date: $reviewDate)';
}
