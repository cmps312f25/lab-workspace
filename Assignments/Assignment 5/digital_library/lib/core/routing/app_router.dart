import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/borrowing/presentation/screens/home_screen.dart';
import '../../features/borrowing/presentation/screens/transactions_screen.dart';
import '../../features/library_items/presentation/screens/library_items_screen.dart';
import '../../features/library_items/presentation/screens/library_item_details_screen.dart';
import '../../features/members/presentation/screens/members_screen.dart';
import '../../features/members/presentation/screens/member_details_screen.dart';
import 'shell_scaffold.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    // Login route (outside shell - no bottom nav)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Signup route (outside shell - no bottom nav)
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),

    // Shell route with bottom navigation
    ShellRoute(
      builder: (context, state, child) {
        // Calculate current index based on the route path
        int currentIndex = 0;
        final location = state.matchedLocation;
        if (location.startsWith('/library-items')) {
          currentIndex = 1;
        } else if (location.startsWith('/members')) {
          currentIndex = 2;
        } else if (location.startsWith('/transactions')) {
          currentIndex = 3;
        }

        return ShellScaffold(
          currentIndex: currentIndex,
          child: child,
        );
      },
      routes: [
        // Home tab
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Library items tab
        GoRoute(
          path: '/library-items',
          builder: (context, state) => const LibraryItemsScreen(),
        ),

        // Members tab
        GoRoute(
          path: '/members',
          builder: (context, state) => const MembersScreen(),
        ),

        // Transactions tab
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsScreen(),
        ),
      ],
    ),

    // Detail routes (outside shell - no bottom nav)
    GoRoute(
      path: '/library-items/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return LibraryItemDetailsScreen(itemId: id);
      },
    ),

    GoRoute(
      path: '/members/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MemberDetailsScreen(memberId: id);
      },
    ),
  ],
);
