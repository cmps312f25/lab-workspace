import 'package:campus_hub/features/user_management/presentation/widgets/info_card.dart';
import 'package:campus_hub/features/user_management/presentation/widgets/profile_header.dart';
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
    // Get student data - repository handles finding the student
    final students = await userRepository.getAllStudents();
    student = students.firstWhere((s) => s.role == UserRole.student);

    // Get course recommendations - use case handles the business logic
    courseRecommendations = await getCourseRecommendations(student!.id);

    // Get student bookings - repository handles filtering by student
    studentBookings = await bookingRepository.getBookingsByStudent(student!.id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (student == null) {
      return Center(child: Text('Loading...'));
    }

    // TODO: Implement the student profile page design here
    // Available data:
    // - student: Student object with profile information
    // - courseRecommendations: List<Course> - recommended courses
    // - studentBookings: List<Booking> - student's booking history
    // Requirements:
    // - Display student profile information (name, email, major, year, avatar)
    // - Show struggling courses
    // - Show course recommendations
    // - Show recent bookings
    // - Follow the design guidelines in DESIGN_GUIDELINES.md
    // - Use blue theme for student profile
    //
    // HINT: Use the common widgets from the widgets/ directory
    // - ProfileHeader for the top section with avatar and user info
    // - InfoCard for organizing different sections (struggling courses, recommendations, bookings)
    // - ListItem for individual course and booking items
    // - StatItem if you want to show any statistics

    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ProfileHeader(
            name: student!.name,
            email: student!.email,
            themeColor: Colors.blue,
            avatarUrl: student!.avatarUrl,
            subtitle: '${student!.major} - Year ${student!.year}',
          ),
        ),
        // SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InfoCard(
            title: 'Struggling Courses',
            icon: Icons.school,
            child: Column(
              children: [
                ...studentBookings.map((booking) {
                  return Card(
                    color: Colors.blue.shade50,
                    margin: EdgeInsets.all(2.0),
                    child: ListTile(
                      title: Text(booking.studentId),
                      leading: Icon(Icons.local_activity),
                      trailing: Chip(label: Text(booking.status.name)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Text(
          'Student Profile Page - Design Implementation Needed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text('Student: ${student!.name}', style: TextStyle(fontSize: 16)),
        Text(
          'Email: ${student!.email}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Text(
          'Major: ${student!.major} - Year ${student!.year}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 20),
        Text(
          'Struggling Courses: ${student!.strugglingCourses.length}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Course Recommendations: ${courseRecommendations.length}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Recent Bookings: ${studentBookings.length}',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 20),
        Text(
          '💡 Tip: Use the common widgets from the widgets/ directory!',
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
