import '../../../borrowing/domain/entities/review.dart';

mixin Reviewable {
  final List<Review> reviews = [];

  /// Adds a review with validation
  /// Validates rating range and prevents duplicate reviews
  void addReview(Review review) {
    // Validate rating range
    if (!review.isValidRating()) {
      throw ArgumentError('Rating must be between 1 and 5');
    }

    // Prevent duplicate reviews from same user
    if (hasReviewFromUser(review.reviewerName)) {
      throw StateError(
          'User ${review.reviewerName} has already reviewed this item');
    }

    reviews.add(review);
  }

  /// Calculates weighted average rating
  /// Returns 0.0 if no reviews
  double getAverageRating() {
    if (reviews.isEmpty) return 0.0;
    final sum = reviews.fold<double>(
        0.0, (previousValue, review) => previousValue + review.rating);
    return sum / reviews.length;
  }

  /// Returns total number of reviews
  int getReviewCount() => reviews.length;

  /// Returns highest-rated reviews, sorted by rating then date
  List<Review> getTopReviews(int count) {
    final sortedReviews = List<Review>.from(reviews);
    sortedReviews.sort((a, b) {
      final ratingComparison = b.rating.compareTo(a.rating);
      if (ratingComparison != 0) return ratingComparison;
      return b.reviewDate.compareTo(a.reviewDate);
    });
    return sortedReviews.take(count).toList();
  }

  /// Checks if specific user already reviewed this item
  bool hasReviewFromUser(String userName) =>
      reviews.any((review) => review.reviewerName == userName);
}
