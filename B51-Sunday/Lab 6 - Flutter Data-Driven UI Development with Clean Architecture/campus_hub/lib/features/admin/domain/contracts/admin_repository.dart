abstract class AdminRepository {
  // Analytics and Statistics
  Future<Map<String, dynamic>> getSystemAnalytics();
  Future<Map<String, int>> getUserStatistics();
  Future<Map<String, int>> getSessionStatistics();
  Future<Map<String, int>> getBookingStatistics();
  Future<Map<String, double>> getReviewStatistics();

  // User Management Analytics
  Future<int> getTotalUsersCount();
  Future<int> getTotalStudentsCount();
  Future<int> getTotalTutorsCount();
  Future<int> getActiveUsersCount();

  // Session Analytics
  Future<int> getTotalSessionsCount();
  Future<int> getActiveSessionsCount();
  Future<Map<String, int>> getSessionsByCourse();
  Future<Map<String, int>> getSessionsByDepartment();
  Future<Map<String, int>> getSessionsByStatus();

  // Booking Analytics
  Future<int> getTotalBookingsCount();
  Future<Map<String, int>> getBookingsByStatus();
  Future<double> getBookingSuccessRate();
  Future<List<Map<String, dynamic>>> getPopularSessions();

  // Review Analytics
  Future<double> getOverallSystemRating();
  Future<Map<String, int>> getReviewDistribution();
  Future<List<Map<String, dynamic>>> getTopRatedTutors();
  Future<List<Map<String, dynamic>>> getLowPerformingTutors();

  // Time-based Analytics
  Future<Map<String, dynamic>> getDailyStats(DateTime date);
  Future<Map<String, dynamic>> getWeeklyStats(DateTime startDate);
  Future<Map<String, dynamic>> getMonthlyStats(DateTime month);

  // Moderation
  Future<List<Map<String, dynamic>>> getFlaggedReviews();
  Future<void> moderateReview(String reviewId, String action);
  Future<List<Map<String, dynamic>>> getReportedUsers();
  Future<void> moderateUser(String userId, String action);
}
