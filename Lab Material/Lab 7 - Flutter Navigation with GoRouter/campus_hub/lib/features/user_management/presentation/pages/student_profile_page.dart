import 'package:flutter/material.dart';
import '../../../../core/domain/enums/user_role.dart';
import '../../domain/entities/student.dart';
import '../../../academic/domain/entities/course.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../domain/contracts/user_repository.dart';
import '../../../academic/domain/contracts/academic_repository.dart';
import '../../../booking/domain/contracts/booking_repository.dart';
import '../../../academic/domain/usecases/get_course_recommendations.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../../academic/data/repositories/academic_repository_impl.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';
import '../../data/datasources/local/user_local_data_source_impl.dart';
import '../../../academic/data/datasources/local/academic_local_data_source_impl.dart';
import '../../../booking/data/datasources/local/booking_local_data_source_impl.dart';
import '../widgets/profile_header.dart';
import '../widgets/info_card.dart';
import '../widgets/list_item.dart';
import '../widgets/stat_item.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  // Repository instances
  late UserRepository userRepository;
  late AcademicRepository academicRepository;
  late BookingRepository bookingRepository;
  late GetCourseRecommendations getCourseRecommendations;

  // Data from repositories
  Student? student;
  List<Course> courseRecommendations = [];
  List<Booking> studentBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    _loadData();
  }

  void _initializeRepositories() {
    userRepository = UserRepositoryImpl(localDataSource: UserLocalDataSource());
    academicRepository = AcademicRepositoryImpl(
      localDataSource: AcademicLocalDataSource(),
    );
    bookingRepository = BookingRepositoryImpl(
      localDataSource: BookingLocalDataSource(),
    );
    getCourseRecommendations = GetCourseRecommendations(
      academicRepository,
      userRepository,
    );
  }

  Future<void> _loadData() async {
    try {
      // Get student data - repository handles finding the student
      final students = await userRepository.getAllStudents();
      student = students.firstWhere((s) => s.role == UserRole.student);

      // Get course recommendations - use case handles the business logic
      courseRecommendations = await getCourseRecommendations(student!.id);

      // Get student bookings - repository handles filtering by student
      studentBookings = await bookingRepository.getBookingsByStudent(
        student!.id,
      );
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

    if (student == null) {
      return const Center(child: Text('Error loading student data'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileHeader(
            name: student!.name,
            email: student!.email,
            subtitle: '${student!.major} - Year ${student!.year}',
            avatarUrl: student!.avatarUrl,
            themeColor: Colors.blue,
            additionalInfo: Row(
              children: [
                if (student!.achievements.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      student!.achievements.first,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  value: student!.strugglingCourses.length.toString(),
                  label: 'Struggling\nCourses',
                  icon: Icons.school,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatItem(
                  value: courseRecommendations.length.toString(),
                  label: 'Course\nRecommendations',
                  icon: Icons.recommend,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatItem(
                  value: studentBookings.length.toString(),
                  label: 'Recent\nBookings',
                  icon: Icons.book_online,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Struggling Courses
          InfoCard(
            title: 'Struggling Courses',
            icon: Icons.warning,
            iconColor: Colors.orange,
            child: student!.strugglingCourses.isEmpty
                ? Text(
                    'No struggling courses',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: student!.strugglingCourses
                        .map(
                          (course) => ListItem(
                            title: course,
                            icon: Icons.school,
                            iconColor: Colors.orange,
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Course Recommendations
          InfoCard(
            title: 'Course Recommendations',
            icon: Icons.recommend,
            iconColor: Colors.green,
            child: courseRecommendations.isEmpty
                ? Text(
                    'No course recommendations available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: courseRecommendations
                        .map(
                          (course) => ListItem(
                            title: course.title,
                            subtitle:
                                '${course.code} - ${course.credits} credits',
                            icon: Icons.book,
                            iconColor: Colors.green,
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Recent Bookings
          InfoCard(
            title: 'Recent Bookings',
            icon: Icons.book_online,
            iconColor: Colors.purple,
            child: studentBookings.isEmpty
                ? Text(
                    'No recent bookings',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: studentBookings.take(5).map((booking) {
                      Color statusColor;
                      IconData statusIcon;
                      switch (booking.status.value) {
                        case 'confirmed':
                          statusColor = Colors.green;
                          statusIcon = Icons.check_circle;
                          break;
                        case 'pending':
                          statusColor = Colors.orange;
                          statusIcon = Icons.pending;
                          break;
                        case 'attended':
                          statusColor = Colors.blue;
                          statusIcon = Icons.done_all;
                          break;
                        case 'cancelled':
                          statusColor = Colors.red;
                          statusIcon = Icons.cancel;
                          break;
                        default:
                          statusColor = Colors.grey;
                          statusIcon = Icons.help;
                      }
                      return ListItem(
                        title: 'Session ${booking.sessionId}',
                        subtitle: 'Booked: ${_formatDate(booking.bookedAt)}',
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
                            booking.status.value.toUpperCase(),
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

          // Study Preferences
          if (student!.studyPreferences.isNotEmpty)
            InfoCard(
              title: 'Study Preferences',
              icon: Icons.settings,
              iconColor: Colors.indigo,
              child: Column(
                children: student!.studyPreferences.entries
                    .map(
                      (entry) => ListItem(
                        title: entry.key,
                        subtitle: entry.value,
                        icon: Icons.info,
                        iconColor: Colors.indigo,
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
