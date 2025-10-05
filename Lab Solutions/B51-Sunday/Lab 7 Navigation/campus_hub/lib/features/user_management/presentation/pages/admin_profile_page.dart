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
import '../widgets/profile_header.dart';
import '../widgets/info_card.dart';
import '../widgets/list_item.dart';
import '../widgets/stat_item.dart';

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
  bool isLoading = true;

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
    try {
      // Get admin data - repository handles finding the admin
      final admins = await userRepository.getAllAdmins();
      admin = admins.first;

      // Get system analytics - repository handles all the calculations
      systemAnalytics = await adminRepository.getSystemAnalytics();
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

    if (admin == null) {
      return const Center(child: Text('Error loading admin data'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileHeader(
            name: admin!.name,
            email: admin!.email,
            subtitle: 'System Administrator',
            avatarUrl: admin!.avatarUrl,
            themeColor: Colors.orange,
            additionalInfo: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${admin!.permissions.length} Permissions',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // System Statistics
          InfoCard(
            title: 'System Analytics',
            icon: Icons.analytics,
            iconColor: Colors.blue,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatItem(
                        value:
                            '${systemAnalytics['users']?['totalUsers'] ?? 0}',
                        label: 'Total\nUsers',
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatItem(
                        value:
                            '${systemAnalytics['sessions']?['totalSessions'] ?? 0}',
                        label: 'Total\nSessions',
                        icon: Icons.event,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatItem(
                        value:
                            '${systemAnalytics['bookings']?['totalBookings'] ?? 0}',
                        label: 'Total\nBookings',
                        icon: Icons.book_online,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatItem(
                        value:
                            '${systemAnalytics['reviews']?['averageRating']?.toStringAsFixed(1) ?? '0.0'}',
                        label: 'Average\nRating',
                        icon: Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Admin Permissions
          InfoCard(
            title: 'Admin Permissions',
            icon: Icons.security,
            iconColor: Colors.red,
            child: admin!.permissions.isEmpty
                ? Text(
                    'No permissions assigned',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: admin!.permissions
                        .map(
                          (permission) => ListItem(
                            title: permission
                                .replaceAll('_', ' ')
                                .toUpperCase(),
                            icon: _getPermissionIcon(permission),
                            iconColor: Colors.red,
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Admin Actions
          InfoCard(
            title: 'Admin Actions',
            icon: Icons.admin_panel_settings,
            iconColor: Colors.indigo,
            child: Column(
              children: [
                ListItem(
                  title: 'Manage Users',
                  subtitle: 'Add, edit, or remove user accounts',
                  icon: Icons.people_alt,
                  iconColor: Colors.blue,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ),
                ListItem(
                  title: 'View Analytics',
                  subtitle: 'Access detailed system reports',
                  icon: Icons.analytics,
                  iconColor: Colors.green,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ),
                ListItem(
                  title: 'Moderate Reviews',
                  subtitle: 'Review and manage user feedback',
                  icon: Icons.rate_review,
                  iconColor: Colors.orange,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ),
                ListItem(
                  title: 'Manage Sessions',
                  subtitle: 'Oversee tutoring sessions',
                  icon: Icons.event,
                  iconColor: Colors.purple,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Stats
          InfoCard(
            title: 'Quick Stats',
            icon: Icons.dashboard,
            iconColor: Colors.teal,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatItem(
                        value: '${systemAnalytics['users']?['students'] ?? 0}',
                        label: 'Students',
                        icon: Icons.school,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatItem(
                        value: '${systemAnalytics['users']?['tutors'] ?? 0}',
                        label: 'Tutors',
                        icon: Icons.person,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatItem(
                        value:
                            '${systemAnalytics['sessions']?['openSessions'] ?? 0}',
                        label: 'Open\nSessions',
                        icon: Icons.lock_open,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatItem(
                        value:
                            '${systemAnalytics['bookings']?['confirmedBookings'] ?? 0}',
                        label: 'Confirmed\nBookings',
                        icon: Icons.check_circle,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPermissionIcon(String permission) {
    switch (permission) {
      case 'view_analytics':
        return Icons.analytics;
      case 'moderate_reviews':
        return Icons.rate_review;
      case 'manage_users':
        return Icons.people;
      case 'manage_sessions':
        return Icons.event;
      default:
        return Icons.security;
    }
  }
}
