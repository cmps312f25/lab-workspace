import 'package:flutter/material.dart';
import '../../../../core/domain/enums/user_role.dart';
import '../../domain/entities/student.dart';
import '../../../session_management/domain/entities/session.dart';
import '../../../reviews/domain/entities/review.dart';
import '../../domain/contracts/user_repository.dart';
import '../../../session_management/domain/contracts/session_repository.dart';
import '../../../reviews/domain/contracts/review_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../../session_management/data/repositories/session_repository_impl.dart';
import '../../../reviews/data/repositories/review_repository_impl.dart';
import '../../data/datasources/local/user_local_data_source_impl.dart';
import '../../../session_management/data/datasources/local/session_local_data_source_impl.dart';
import '../../../reviews/data/datasources/local/review_local_data_source_impl.dart';
import '../../../booking/data/datasources/local/booking_local_data_source_impl.dart';
import '../widgets/profile_header.dart';
import '../widgets/info_card.dart';
import '../widgets/list_item.dart';
import '../widgets/stat_item.dart';

class TutorProfilePage extends StatefulWidget {
  const TutorProfilePage({super.key});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  // Repository instances
  late UserRepository userRepository;
  late SessionRepository sessionRepository;
  late ReviewRepository reviewRepository;

  // Data from repositories
  Student? tutor;
  List<Session> tutorSessions = [];
  List<Review> tutorReviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    _loadData();
  }

  void _initializeRepositories() {
    userRepository = UserRepositoryImpl(localDataSource: UserLocalDataSource());
    sessionRepository = SessionRepositoryImpl(
      localDataSource: SessionLocalDataSource(),
    );
    reviewRepository = ReviewRepositoryImpl(
      localDataSource: ReviewLocalDataSource(),
      bookingDataSource: BookingLocalDataSource(),
      sessionDataSource: SessionLocalDataSource(),
    );
  }

  Future<void> _loadData() async {
    try {
      // Get tutor data - repository handles finding the tutor
      final students = await userRepository.getAllStudents();
      tutor = students.firstWhere((s) => s.role == UserRole.tutor);

      // Get tutor sessions - repository handles filtering by tutor
      tutorSessions = await sessionRepository.getSessionsByTutor(tutor!.id);

      // Get tutor reviews - repository handles filtering by tutor
      tutorReviews = await reviewRepository.getReviewsByTutor(tutor!.id);
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tutor == null) {
      return const Center(child: Text('Error loading tutor data'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileHeader(
            name: tutor!.name,
            email: tutor!.email,
            subtitle: '${tutor!.major} - Year ${tutor!.year}',
            avatarUrl: tutor!.avatarUrl,
            themeColor: Colors.green,
            additionalInfo: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tutor!.bio != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    tutor!.bio!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${tutor!.averageRating.toStringAsFixed(1)} Average Rating',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Statistics Row
          Row(
            children: [
              Expanded(
                child: StatItem(
                  value: tutor!.tutoringCourses.length.toString(),
                  label: 'Tutoring\nCourses',
                  icon: Icons.school,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatItem(
                  value: tutor!.averageRating.toStringAsFixed(1),
                  label: 'Average\nRating',
                  icon: Icons.star,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatItem(
                  value: tutorSessions.length.toString(),
                  label: 'Total\nSessions',
                  icon: Icons.event,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatItem(
                  value: tutorReviews.length.toString(),
                  label: 'Total\nReviews',
                  icon: Icons.rate_review,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatItem(
                  value:
                      '${((tutorSessions.where((s) => s.isOpen).length / tutorSessions.length) * 100).toStringAsFixed(0)}%',
                  label: 'Success\nRate',
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatItem(
                  value: tutor!.ratings.length.toString(),
                  label: 'Student\nRatings',
                  icon: Icons.people,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tutoring Courses
          InfoCard(
            title: 'Tutoring Courses',
            icon: Icons.school,
            iconColor: Colors.blue,
            child: tutor!.tutoringCourses.isEmpty
                ? Text(
                    'No tutoring courses available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: tutor!.tutoringCourses
                        .map(
                          (course) => ListItem(
                            title: course,
                            icon: Icons.book,
                            iconColor: Colors.blue,
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Recent Sessions
          InfoCard(
            title: 'Recent Sessions',
            icon: Icons.event,
            iconColor: Colors.purple,
            child: tutorSessions.isEmpty
                ? Text(
                    'No sessions available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: tutorSessions.take(5).map((session) {
                      Color statusColor;
                      IconData statusIcon;
                      switch (session.status.value) {
                        case 'open':
                          statusColor = Colors.green;
                          statusIcon = Icons.check_circle;
                          break;
                        case 'closed':
                          statusColor = Colors.grey;
                          statusIcon = Icons.lock;
                          break;
                        case 'cancelled':
                          statusColor = Colors.red;
                          statusIcon = Icons.cancel;
                          break;
                        default:
                          statusColor = Colors.orange;
                          statusIcon = Icons.help;
                      }
                      return ListItem(
                        title: '${session.courseId} - ${session.location}',
                        subtitle:
                            '${_formatDate(session.start)} - ${_formatTime(session.start)} to ${_formatTime(session.end)}',
                        icon: statusIcon,
                        iconColor: statusColor,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${session.capacity} spots',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Recent Reviews
          InfoCard(
            title: 'Recent Reviews',
            icon: Icons.rate_review,
            iconColor: Colors.orange,
            child: tutorReviews.isEmpty
                ? Text(
                    'No reviews available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: tutorReviews.take(3).map((review) {
                      return ListItem(
                        title: '${review.rating.value} stars',
                        subtitle: review.comment,
                        icon: Icons.star,
                        iconColor: Colors.amber,
                        trailing: Text(
                          _formatDate(review.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
