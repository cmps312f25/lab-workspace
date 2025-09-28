import '../../domain/contracts/admin_repository.dart';
import '../../../user_management/data/datasources/local/user_local_data_source_impl.dart';
import '../../../session_management/data/datasources/local/session_local_data_source_impl.dart';
import '../../../booking/data/datasources/local/booking_local_data_source_impl.dart';
import '../../../reviews/data/datasources/local/review_local_data_source_impl.dart';
import '../../../../core/domain/enums/session_status.dart';
import '../../../../core/domain/enums/booking_status.dart';

class AdminRepositoryImpl implements AdminRepository {
  final UserLocalDataSource userDataSource;
  final SessionLocalDataSource sessionDataSource;
  final BookingLocalDataSource bookingDataSource;
  final ReviewLocalDataSource reviewDataSource;

  AdminRepositoryImpl({
    required this.userDataSource,
    required this.sessionDataSource,
    required this.bookingDataSource,
    required this.reviewDataSource,
  });

  @override
  Future<Map<String, dynamic>> getSystemAnalytics() async {
    try {
      final userStats = await getUserStatistics();
      final sessionStats = await getSessionStatistics();
      final bookingStats = await getBookingStatistics();
      final reviewStats = await getReviewStatistics();

      return {
        'users': userStats,
        'sessions': sessionStats,
        'bookings': bookingStats,
        'reviews': reviewStats,
        'generatedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to get system analytics: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getUserStatistics() async {
    try {
      final students = await userDataSource.getStudents();
      final tutors = students.where((student) => student.isTutor).toList();
      final admins = await userDataSource.getAdmins();

      return {
        'totalUsers': students.length + admins.length,
        'totalStudents': students.where((s) => s.isStudent).length,
        'totalTutors': tutors.length,
        'totalAdmins': admins.length,
      };
    } catch (e) {
      throw Exception('Failed to get user statistics: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getSessionStatistics() async {
    try {
      final sessions = await sessionDataSource.getSessions();
      final now = DateTime.now();

      final openSessions = sessions
          .where((s) => s.status == SessionStatus.open)
          .length;
      final closedSessions = sessions
          .where((s) => s.status == SessionStatus.closed)
          .length;
      final upcomingSessions = sessions
          .where((s) => s.start.isAfter(now))
          .length;
      final pastSessions = sessions.where((s) => s.end.isBefore(now)).length;

      return {
        'totalSessions': sessions.length,
        'openSessions': openSessions,
        'closedSessions': closedSessions,
        'upcomingSessions': upcomingSessions,
        'pastSessions': pastSessions,
      };
    } catch (e) {
      throw Exception('Failed to get session statistics: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getBookingStatistics() async {
    try {
      final bookings = await bookingDataSource.getBookings();

      final pendingBookings = bookings
          .where((b) => b.status == BookingStatus.pending)
          .length;
      final confirmedBookings = bookings
          .where((b) => b.status == BookingStatus.confirmed)
          .length;
      final attendedBookings = bookings
          .where((b) => b.status == BookingStatus.attended)
          .length;
      final cancelledBookings = bookings
          .where((b) => b.status == BookingStatus.cancelled)
          .length;

      return {
        'totalBookings': bookings.length,
        'pendingBookings': pendingBookings,
        'confirmedBookings': confirmedBookings,
        'attendedBookings': attendedBookings,
        'cancelledBookings': cancelledBookings,
      };
    } catch (e) {
      throw Exception('Failed to get booking statistics: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, double>> getReviewStatistics() async {
    try {
      final reviews = await reviewDataSource.getReviews();

      if (reviews.isEmpty) {
        return {
          'totalReviews': 0,
          'averageRating': 0.0,
          'highestRating': 0.0,
          'lowestRating': 0.0,
        };
      }

      final totalRating = reviews.fold(
        0.0,
        (sum, review) => sum + review.rating.value,
      );
      final averageRating = totalRating / reviews.length;
      final highestRating = reviews
          .map((r) => r.rating.value)
          .reduce((a, b) => a > b ? a : b);
      final lowestRating = reviews
          .map((r) => r.rating.value)
          .reduce((a, b) => a < b ? a : b);

      return {
        'totalReviews': reviews.length.toDouble(),
        'averageRating': averageRating,
        'highestRating': highestRating,
        'lowestRating': lowestRating,
      };
    } catch (e) {
      throw Exception('Failed to get review statistics: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalUsersCount() async {
    try {
      final userStats = await getUserStatistics();
      return userStats['totalUsers'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get total users count: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalStudentsCount() async {
    try {
      final userStats = await getUserStatistics();
      return userStats['totalStudents'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get total students count: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalTutorsCount() async {
    try {
      final userStats = await getUserStatistics();
      return userStats['totalTutors'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get total tutors count: ${e.toString()}');
    }
  }

  @override
  Future<int> getActiveUsersCount() async {
    try {
      // For now, return total users (would need to track last activity in real app)
      return await getTotalUsersCount();
    } catch (e) {
      throw Exception('Failed to get active users count: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalSessionsCount() async {
    try {
      final sessionStats = await getSessionStatistics();
      return sessionStats['totalSessions'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get total sessions count: ${e.toString()}');
    }
  }

  @override
  Future<int> getActiveSessionsCount() async {
    try {
      final sessionStats = await getSessionStatistics();
      return sessionStats['openSessions'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get active sessions count: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getSessionsByCourse() async {
    try {
      final sessions = await sessionDataSource.getSessions();
      final counts = <String, int>{};

      for (final session in sessions) {
        counts[session.courseId] = (counts[session.courseId] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get sessions by course: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getSessionsByDepartment() async {
    try {
      final sessions = await sessionDataSource.getSessions();
      final counts = <String, int>{};

      for (final session in sessions) {
        // Extract department code from course ID (e.g., CMPS312 -> CMPS)
        final deptCode = session.courseId.replaceAll(RegExp(r'\d+'), '');
        counts[deptCode] = (counts[deptCode] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get sessions by department: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getSessionsByStatus() async {
    try {
      final sessions = await sessionDataSource.getSessions();
      final counts = <String, int>{};

      for (final session in sessions) {
        counts[session.status.value] = (counts[session.status.value] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get sessions by status: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalBookingsCount() async {
    try {
      final bookingStats = await getBookingStatistics();
      return bookingStats['totalBookings'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get total bookings count: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getBookingsByStatus() async {
    try {
      return await getBookingStatistics();
    } catch (e) {
      throw Exception('Failed to get bookings by status: ${e.toString()}');
    }
  }

  @override
  Future<double> getBookingSuccessRate() async {
    try {
      final bookingStats = await getBookingStatistics();
      final totalBookings = bookingStats['totalBookings'] ?? 0;
      final attendedBookings = bookingStats['attendedBookings'] ?? 0;

      if (totalBookings == 0) return 0.0;
      return (attendedBookings / totalBookings * 100);
    } catch (e) {
      throw Exception('Failed to get booking success rate: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPopularSessions() async {
    try {
      final sessions = await sessionDataSource.getSessions();
      final bookings = await bookingDataSource.getBookings();

      final sessionPopularity = <String, int>{};
      for (final booking in bookings) {
        sessionPopularity[booking.sessionId] =
            (sessionPopularity[booking.sessionId] ?? 0) + 1;
      }

      final popularSessions = <Map<String, dynamic>>[];
      for (final session in sessions) {
        final bookingCount = sessionPopularity[session.id] ?? 0;
        popularSessions.add({
          'sessionId': session.id,
          'courseId': session.courseId,
          'tutorId': session.tutorId,
          'bookingCount': bookingCount,
          'location': session.location,
        });
      }

      // Sort by booking count (most popular first)
      popularSessions.sort(
        (a, b) =>
            (b['bookingCount'] as int).compareTo(a['bookingCount'] as int),
      );

      return popularSessions.take(10).toList();
    } catch (e) {
      throw Exception('Failed to get popular sessions: ${e.toString()}');
    }
  }

  @override
  Future<double> getOverallSystemRating() async {
    try {
      final reviewStats = await getReviewStatistics();
      return reviewStats['averageRating'] ?? 0.0;
    } catch (e) {
      throw Exception('Failed to get overall system rating: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getReviewDistribution() async {
    try {
      final reviews = await reviewDataSource.getReviews();
      final distribution = <String, int>{};

      for (int i = 1; i <= 5; i++) {
        distribution['${i}_star'] = 0;
      }

      for (final review in reviews) {
        final rating = review.rating.value.round();
        final key = '${rating}_star';
        distribution[key] = (distribution[key] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      throw Exception('Failed to get review distribution: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTopRatedTutors() async {
    try {
      final students = await userDataSource.getStudents();
      final tutors = students.where((student) => student.isTutor).toList();
      final topTutors = <Map<String, dynamic>>[];

      for (final tutor in tutors) {
        if (tutor.ratings.isNotEmpty) {
          topTutors.add({
            'tutorId': tutor.id,
            'name': tutor.name,
            'averageRating': tutor.averageRating,
            'totalRatings': tutor.ratings.length,
            'major': tutor.major,
          });
        }
      }

      // Sort by average rating (highest first)
      topTutors.sort(
        (a, b) => (b['averageRating'] as double).compareTo(
          a['averageRating'] as double,
        ),
      );

      return topTutors.take(10).toList();
    } catch (e) {
      throw Exception('Failed to get top rated tutors: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getLowPerformingTutors() async {
    try {
      final students = await userDataSource.getStudents();
      final tutors = students.where((student) => student.isTutor).toList();
      final lowPerformingTutors = <Map<String, dynamic>>[];

      for (final tutor in tutors) {
        if (tutor.ratings.isNotEmpty && tutor.averageRating < 3.0) {
          lowPerformingTutors.add({
            'tutorId': tutor.id,
            'name': tutor.name,
            'averageRating': tutor.averageRating,
            'totalRatings': tutor.ratings.length,
            'major': tutor.major,
          });
        }
      }

      // Sort by average rating (lowest first)
      lowPerformingTutors.sort(
        (a, b) => (a['averageRating'] as double).compareTo(
          b['averageRating'] as double,
        ),
      );

      return lowPerformingTutors;
    } catch (e) {
      throw Exception('Failed to get low performing tutors: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getDailyStats(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final sessions = await sessionDataSource.getSessions();
      final bookings = await bookingDataSource.getBookings();

      final dailySessions = sessions
          .where(
            (s) => s.start.isAfter(startOfDay) && s.start.isBefore(endOfDay),
          )
          .length;

      final dailyBookings = bookings
          .where(
            (b) =>
                b.bookedAt.isAfter(startOfDay) && b.bookedAt.isBefore(endOfDay),
          )
          .length;

      return {
        'date': date.toIso8601String(),
        'sessions': dailySessions,
        'bookings': dailyBookings,
      };
    } catch (e) {
      throw Exception('Failed to get daily stats: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getWeeklyStats(DateTime startDate) async {
    try {
      final endDate = startDate.add(const Duration(days: 7));

      final sessions = await sessionDataSource.getSessions();
      final bookings = await bookingDataSource.getBookings();

      final weeklySessions = sessions
          .where((s) => s.start.isAfter(startDate) && s.start.isBefore(endDate))
          .length;

      final weeklyBookings = bookings
          .where(
            (b) =>
                b.bookedAt.isAfter(startDate) && b.bookedAt.isBefore(endDate),
          )
          .length;

      return {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'sessions': weeklySessions,
        'bookings': weeklyBookings,
      };
    } catch (e) {
      throw Exception('Failed to get weekly stats: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getMonthlyStats(DateTime month) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 1);

      final sessions = await sessionDataSource.getSessions();
      final bookings = await bookingDataSource.getBookings();

      final monthlySessions = sessions
          .where(
            (s) =>
                s.start.isAfter(startOfMonth) && s.start.isBefore(endOfMonth),
          )
          .length;

      final monthlyBookings = bookings
          .where(
            (b) =>
                b.bookedAt.isAfter(startOfMonth) &&
                b.bookedAt.isBefore(endOfMonth),
          )
          .length;

      return {
        'month': '${month.year}-${month.month.toString().padLeft(2, '0')}',
        'sessions': monthlySessions,
        'bookings': monthlyBookings,
      };
    } catch (e) {
      throw Exception('Failed to get monthly stats: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFlaggedReviews() async {
    try {
      // For now, return low-rated reviews as "flagged"
      final reviews = await reviewDataSource.getReviews();
      final flaggedReviews = reviews
          .where((r) => r.rating.value <= 2.0)
          .toList();

      return flaggedReviews
          .map(
            (review) => {
              'reviewId': review.id,
              'bookingId': review.bookingId,
              'rating': review.rating,
              'comment': review.comment,
              'createdAt': review.createdAt.toIso8601String(),
              'flagReason': 'Low rating',
            },
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get flagged reviews: ${e.toString()}');
    }
  }

  @override
  Future<void> moderateReview(String reviewId, String action) async {
    try {
      // Placeholder for review moderation
      // In a real app, this would update the review status
      throw UnimplementedError(
        'Review moderation not implemented for JSON files',
      );
    } catch (e) {
      throw Exception('Failed to moderate review: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getReportedUsers() async {
    try {
      // Placeholder - would need to track user reports
      return [];
    } catch (e) {
      throw Exception('Failed to get reported users: ${e.toString()}');
    }
  }

  @override
  Future<void> moderateUser(String userId, String action) async {
    try {
      // Placeholder for user moderation
      throw UnimplementedError(
        'User moderation not implemented for JSON files',
      );
    } catch (e) {
      throw Exception('Failed to moderate user: ${e.toString()}');
    }
  }
}
