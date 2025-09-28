import '../entities/review.dart';

abstract class ReviewRepository {
  // Get all reviews
  Future<List<Review>> getAllReviews();

  // Get reviews by booking
  Future<List<Review>> getReviewsByBooking(String bookingId);
  Future<Review?> getReviewByBooking(String bookingId);

  // Get reviews by tutor (through bookings and sessions)
  Future<List<Review>> getReviewsByTutor(String tutorId);
  Future<double> getTutorAverageRating(String tutorId);
  Future<int> getTutorReviewCount(String tutorId);

  // Get reviews by student
  Future<List<Review>> getReviewsByStudent(String studentId);

  // Get reviews by rating
  Future<List<Review>> getReviewsByRating(double minRating);
  Future<List<Review>> getHighRatedReviews({double minRating = 4.0});
  Future<List<Review>> getLowRatedReviews({double maxRating = 2.0});

  // Get specific review
  Future<Review?> getReviewById(String id);

  // Review operations
  Future<void> createReview(Review review);
  Future<void> updateReview(Review review);
  Future<void> deleteReview(String id);

  // Business logic
  Future<bool> hasStudentReviewedBooking(String studentId, String bookingId);
  Future<List<Review>> getRecentReviews({int limit = 10});
  Future<Map<int, int>> getReviewRatingDistribution();
}
