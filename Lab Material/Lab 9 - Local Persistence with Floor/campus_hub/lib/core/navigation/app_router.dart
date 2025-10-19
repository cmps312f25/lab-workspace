import 'package:campus_hub/features/user_management/presentation/pages/login_page.dart';
import 'package:campus_hub/features/user_management/presentation/pages/student_profile_page.dart';
import 'package:campus_hub/features/session_management/presentation/pages/sessions_list_page.dart';
import 'package:campus_hub/features/session_management/presentation/pages/session_detail_page.dart';
import 'package:campus_hub/features/booking/presentation/pages/bookings_list_page.dart';
import 'package:campus_hub/features/booking/presentation/pages/booking_detail_page.dart';
import 'package:campus_hub/features/user_management/data/repositories/user_repository_impl.dart';
import 'package:campus_hub/features/user_management/data/datasources/local/user_local_data_source_impl.dart';
import 'package:campus_hub/features/user_management/domain/entities/student.dart';
import 'package:campus_hub/core/providers/title_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Login route (no scaffold)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      // ShellRoute for main pages with MainScaffold
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // Profile route with userId parameter
          GoRoute(
            path: '/profile/:userId',
            builder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return StudentProfilePage(userId: userId);
            },
          ),

          // Sessions routes
          GoRoute(
            path: '/sessions',
            builder: (context, state) => const SessionsListPage(),
          ),
          GoRoute(
            path: '/session/:sessionId',
            builder: (context, state) {
              final sessionId = state.pathParameters['sessionId']!;
              return SessionDetailPage(sessionId: sessionId);
            },
          ),

          // Bookings routes
          GoRoute(
            path: '/bookings/:userId',
            builder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return BookingsListPage(studentId: userId);
            },
          ),
          GoRoute(
            path: '/booking/:bookingId',
            builder: (context, state) {
              final bookingId = state.pathParameters['bookingId']!;
              return BookingDetailPage(bookingId: bookingId);
            },
          ),
        ],
      ),
    ],
  );
}

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  Student? currentUser;
  bool isLoading = true;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
    // Delay title update to avoid modifying provider during build
    Future.microtask(() {
      if (mounted) {
        _updateCurrentIndexAndTitle();
      }
    });
  }

  void _updateCurrentIndexAndTitle() {
    final location = GoRouterState.of(context).uri.toString();
    if (location.contains('/session/')) {
      setState(() => _currentIndex = 1);
      ref.read(titleNotifierProvider.notifier).setTitle('Session Details');
    } else if (location.contains('/sessions')) {
      setState(() => _currentIndex = 1);
      ref.read(titleNotifierProvider.notifier).setTitle('Sessions');
    } else if (location.contains('/booking/')) {
      setState(() => _currentIndex = 2);
      ref.read(titleNotifierProvider.notifier).setTitle('Booking Details');
    } else if (location.contains('/bookings')) {
      setState(() => _currentIndex = 2);
      ref.read(titleNotifierProvider.notifier).setTitle('My Bookings');
    } else {
      setState(() => _currentIndex = 0); // Profile
      ref.read(titleNotifierProvider.notifier).setTitle('Profile');
    }
  }

  Future<void> _loadUserData() async {
    try {
      // Get userId from route parameters
      final userId = GoRouterState.of(context).pathParameters['userId'];
      if (userId == null) return;

      // Load user data from repository
      final localDataSource = UserLocalDataSource();
      final userRepository = UserRepositoryImpl(localDataSource: localDataSource);
      final user = await userRepository.getUserById(userId);

      if (mounted) {
        setState(() {
          currentUser = user;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final title = ref.watch(titleNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _onBottomNavTap(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Profile
        ref.read(titleNotifierProvider.notifier).setTitle('Profile');
        context.go('/profile/${currentUser!.id}');
        break;
      case 1:
        // Sessions
        ref.read(titleNotifierProvider.notifier).setTitle('Sessions');
        context.go('/sessions');
        break;
      case 2:
        // Bookings
        ref.read(titleNotifierProvider.notifier).setTitle('My Bookings');
        context.go('/bookings/${currentUser!.id}');
        break;
    }
  }

  // Show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
