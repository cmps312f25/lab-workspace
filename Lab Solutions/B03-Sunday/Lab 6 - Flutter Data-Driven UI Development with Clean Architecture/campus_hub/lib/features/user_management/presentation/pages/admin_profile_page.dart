import 'package:campus_hub/features/user_management/presentation/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/admin.dart';
import '../../domain/contracts/user_repository.dart';
import '../../../admin/domain/contracts/admin_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../../admin/data/repositories/admin_repository_impl.dart';
import '../../data/datasources/local/user_local_data_source_impl.dart';
import '../../../session_management/data/datasources/local/session_local_data_source_impl.dart';
import '../../../booking/data/datasources/local/booking_local_data_source_impl.dart';
import '../../../reviews/data/datasources/local/review_local_data_source_impl.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  // Repository instances
  late AdminRepository adminRepository;
  late UserRepository userRepository;

  // Data from repositories
  Admin? admin;
  Map<String, dynamic> systemAnalytics = {};

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    _loadData();
  }

  void _initializeRepositories() {
    adminRepository = AdminRepositoryImpl(
      userDataSource: UserLocalDataSource(),
      sessionDataSource: SessionLocalDataSource(),
      bookingDataSource: BookingLocalDataSource(),
      reviewDataSource: ReviewLocalDataSource(),
    );
    userRepository = UserRepositoryImpl(localDataSource: UserLocalDataSource());
  }

  Future<void> _loadData() async {
    // Get admin data - repository handles finding the admin
    final admins = await userRepository.getAllAdmins();
    admin = admins.first;

    // Get system analytics - repository handles all the calculations
    systemAnalytics = await adminRepository.getSystemAnalytics();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (admin == null) {
      return Center(child: Text('Loading...'));
    }

    // TODO: Implement the admin profile page design here
    // Available data:
    // - admin: Admin object containing admin information and permissions
    // - systemAnalytics: Map<String, dynamic> containing system statistics
    //   - systemAnalytics['users']['totalUsers'] - total number of users
    //   - systemAnalytics['sessions']['totalSessions'] - total number of sessions
    //   - systemAnalytics['bookings']['totalBookings'] - total number of bookings
    //   - systemAnalytics['reviews']['averageRating'] - average rating across all reviews
    // Requirements:
    // - Display admin profile information (name, email, avatar)
    // - Show system statistics in a dashboard format
    // - Show admin permissions
    // - Show admin actions/features
    // - Follow the design guidelines in DESIGN_GUIDELINES.md
    // - Use orange theme for admin profile
    //
    // HINT: Use the common widgets from the widgets/ directory
    // - ProfileHeader for the top section with avatar and user info
    // - StatItem for displaying system statistics in a dashboard format
    // - InfoCard for organizing different sections (permissions, actions)
    // - ListItem for individual permission and action items

    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileHeader(
          name: admin!.name,
          email: admin!.email,
          themeColor: Colors.orange[100]!,
          avatarUrl: admin!.avatarUrl,
          subtitle: 'Administrator',
        ),
        Text(
          'Admin Profile Page - Design Implementation Needed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text('Admin: ${admin!.name}', style: TextStyle(fontSize: 16)),
        Text(
          'Email: ${admin!.email}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 20),
        Text(
          'Total Users: ${systemAnalytics['users']?['totalUsers'] ?? 0}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Total Sessions: ${systemAnalytics['sessions']?['totalSessions'] ?? 0}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Total Bookings: ${systemAnalytics['bookings']?['totalBookings'] ?? 0}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Average Rating: ${systemAnalytics['reviews']?['averageRating']?.toStringAsFixed(1) ?? '0.0'}',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 20),
        Text(
          'Permissions: ${admin!.permissions.length}',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
