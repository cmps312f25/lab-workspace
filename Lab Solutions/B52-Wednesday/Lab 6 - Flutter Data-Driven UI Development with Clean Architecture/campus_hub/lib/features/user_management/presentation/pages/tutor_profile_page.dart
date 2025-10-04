import 'package:campus_hub/features/user_management/presentation/widgets/profile_header.dart';
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
    // Get tutor data - repository handles finding the tutor
    final students = await userRepository.getAllStudents();
    tutor = students.firstWhere((s) => s.role == UserRole.tutor);

    // Get tutor sessions - repository handles filtering by tutor
    tutorSessions = await sessionRepository.getSessionsByTutor(tutor!.id);

    // Get tutor reviews - repository handles filtering by tutor
    tutorReviews = await reviewRepository.getReviewsByTutor(tutor!.id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (tutor == null) {
      return Center(child: Text('Loading...'));
    }

    // TODO: Implement the tutor profile page design here
    // Available data:
    // - tutor: Student object (with role=tutor) containing tutor information
    // - tutorSessions: List<Session> - sessions created by this tutor
    // - tutorReviews: List<Review> - reviews for this tutor
    // Requirements:
    // - Display tutor profile information (name, email, major, year, bio, avatar)
    // - Show tutoring courses they can teach
    // - Show tutor statistics (average rating, total sessions, total reviews, success rate)
    // - Show recent sessions
    // - Follow the design guidelines in DESIGN_GUIDELINES.md
    // - Use green theme for tutor profile
    //
    // HINT: Use the common widgets from the widgets/ directory
    // - ProfileHeader for the top section with avatar and user info
    // - InfoCard for organizing different sections (tutoring courses, sessions)
    // - StatItem for displaying statistics in a dashboard format
    // - ListItem for individual session items

    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileHeader(
          name: tutor!.name,
          email: tutor!.email,
          themeColor: Colors.green,
          avatarUrl: tutor!.avatarUrl,
          subtitle: '${tutor!.major} - Year ${tutor!.year}',
        ),
        Text(
          'Tutor Profile Page - Design Implementation Needed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text('Tutor: ${tutor!.name}', style: TextStyle(fontSize: 16)),
        Text(
          'Email: ${tutor!.email}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Text(
          'Major: ${tutor!.major} - Year ${tutor!.year}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        if (tutor!.bio != null)
          Text(
            'Bio: ${tutor!.bio}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        SizedBox(height: 20),
        Text(
          'Tutoring Courses: ${tutor!.tutoringCourses.length}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Average Rating: ${tutor!.averageRating.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Total Sessions: ${tutorSessions.length}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Total Reviews: ${tutorReviews.length}',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
