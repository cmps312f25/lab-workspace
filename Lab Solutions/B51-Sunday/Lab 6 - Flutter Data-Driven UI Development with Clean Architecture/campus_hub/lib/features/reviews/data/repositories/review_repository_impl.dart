import '../../domain/entities/review.dart';
import '../../domain/contracts/review_repository.dart';
import '../datasources/local/review_local_data_source_impl.dart';
import '../../../booking/data/datasources/local/booking_local_data_source_impl.dart';
import '../../../session_management/data/datasources/local/session_local_data_source_impl.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewLocalDataSource localDataSource;
  final BookingLocalDataSource bookingDataSource;
  final SessionLocalDataSource sessionDataSource;

  ReviewRepositoryImpl({
    required this.localDataSource,
    required this.bookingDataSource,
    required this.sessionDataSource,
  });

  @override
  Future<List<Review>> getAllReviews() async {
    try {
      return await localDataSource.getReviews();
    } catch (e) {
      throw Exception('Failed to load reviews: ${e.toString()}');
    }
  }

  @override
  Future<List<Review>> getReviewsByBooking(String bookingId) async {
    try {
      final reviews = await getAllReviews();
      return reviews.where((review) => review.bookingId == bookingId).toList();
    } catch (e) {
      throw Exception('Failed to load reviews by booking: ${e.toString()}');
    }
  }

  @override
  Future<Review?> getReviewByBooking(String bookingId) async {
    try {
      final reviews = await getReviewsByBooking(bookingId);
      return reviews.isNotEmpty ? reviews.first : null;
    } catch (e) {
      throw Exception('Failed to load review by booking: ${e.toString()}');
    }
  }

  @override
  Future<List<Review>> getReviewsByTutor(String tutorId) async {
    try {
      // Get all bookings and sessions to find reviews for this tutor
      final allBookings = await bookingDataSource.getBookings();
      final allSessions = await sessionDataSource.getSessions();
      final allReviews = await getAllReviews();

      // Find sessions by this tutor
      final tutorSessions = allSessions
          .where((s) => s.tutorId == tutorId)
          .toList();
      final tutorSessionIds = tutorSessions.map((s) => s.id).toSet();

      // Find bookings for these sessions
      final tutorBookings = allBookings
          .where((b) => tutorSessionIds.contains(b.sessionId))
          .toList();
      final tutorBookingIds = tutorBookings.map((b) => b.id).toSet();

      // Find reviews for these bookings
      return allReviews
          .where((r) => tutorBookingIds.contains(r.bookingId))
          .toList();
    } catch (e) {
      throw Exception('Failed to load reviews by tutor: ${e.toString()}');
    }
  }

  @override
  Future<double> getTutorAverageRating(String tutorId) async {
    try {
      final reviews = await getReviewsByTutor(tutorId);
      if (reviews.isEmpty) return 0.0;

      final totalRating = reviews.fold(
        0.0,
        (sum, review) => sum + review.rating.value,
      );
      return totalRating / reviews.length;
    } catch (e) {
      throw Exception(
        'Failed to calculate tutor average rating: ${e.toString()}',
      );
    }
  }

  @override
  Future<int> getTutorReviewCount(String tutorId) async {
    try {
      final reviews = await getReviewsByTutor(tutorId);
      return reviews.length;
    } catch (e) {
      throw Exception('Failed to get tutor review count: ${e.toString()}');
    }
  }

  @override
  Future<List<Review>> getReviewsByStudent(String studentId) async {
    try {
      // Get all bookings by this student, then find their reviews
      final studentBookings = await bookingDataSource.getBookings();
      final studentBookingIds = studentBookings
          .where((b) => b.studentId == studentId)
          .map((b) => b.id)
          .toSet();

      final allReviews = await getAllReviews();
      return allReviews
          .where((r) => studentBookingIds.contains(r.bookingId))
          .toList();
    } catch (e) {
      throw Exception('Failed to load reviews by student: ${e.toString()}');
    }
  }

  @override
  Future<List<Review>> getReviewsByRating(double minRating) async {
    try {
      final reviews = await getAllReviews();
      return reviews
          .where((review) => review.rating.value >= minRating)
          .toList();
    } catch (e) {
      throw Exception('Failed to load reviews by rating: ${e.toString()}');
    }
  }

  @override
  Future<List<Review>> getHighRatedReviews({double minRating = 4.0}) async {
    try {
      return await getReviewsByRating(minRating);
    } catch (e) {
      throw Exception('Failed to load high rated reviews: ${e.toString()}');
    }
  }

  @override
  Future<List<Review>> getLowRatedReviews({double maxRating = 2.0}) async {
    try {
      final reviews = await getAllReviews();
      return reviews
          .where((review) => review.rating.value <= maxRating)
          .toList();
    } catch (e) {
      throw Exception('Failed to load low rated reviews: ${e.toString()}');
    }
  }

  @override
  Future<Review?> getReviewById(String id) async {
    try {
      final reviews = await localDataSource.getReviews();
      try {
        return reviews.firstWhere((review) => review.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load review: ${e.toString()}');
    }
  }

  @override
  Future<void> createReview(Review review) async {
    try {
      await localDataSource.saveReview(review);
    } catch (e) {
      throw Exception('Failed to create review: ${e.toString()}');
    }
  }

  @override
  Future<void> updateReview(Review review) async {
    try {
      await localDataSource.updateReview(review);
    } catch (e) {
      throw Exception('Failed to update review: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteReview(String id) async {
    try {
      await localDataSource.deleteReview(id);
    } catch (e) {
      throw Exception('Failed to delete review: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasStudentReviewedBooking(
    String studentId,
    String bookingId,
  ) async {
    try {
      final review = await getReviewByBooking(bookingId);
      return review != null;
    } catch (e) {
      throw Exception(
        'Failed to check if student reviewed booking: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Review>> getRecentReviews({int limit = 10}) async {
    try {
      final reviews = await getAllReviews();
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reviews.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to load recent reviews: ${e.toString()}');
    }
  }

  @override
  Future<Map<int, int>> getReviewRatingDistribution() async {
    try {
      final reviews = await getAllReviews();
      final distribution = <int, int>{};

      for (int i = 1; i <= 5; i++) {
        distribution[i] = 0;
      }

      for (final review in reviews) {
        final rating = review.rating.value.round();
        distribution[rating] = (distribution[rating] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      throw Exception(
        'Failed to get review rating distribution: ${e.toString()}',
      );
    }
  }
}
