import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// TODO: Add necessary imports for your pages

class AppRouter {
  // TODO: Implement GoRouter configuration
  // Requirements:
  // 1. Initial location should be '/login'
  // 2. Login route (no scaffold)
  // 3. Profile routes with parameters: /student/:userId, /tutor/:userId, /admin/:userId
  // 4. Use ShellRoute to wrap profile routes with MainScaffold
  // 5. Pass user data through route parameters

  static final GoRouter router = GoRouter(
    // TODO: Add your router configuration here
    initialLocation: '/login',
    routes: [
    
    ]
  );
}

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement scaffold with:
    // 1. App bar with dynamic title and role-based theming
    // 2. Access user ID from route parameters
    // 3. Logout button with confirmation dialog
    // 4. Role-based colors: Blue (Student), Green (Tutor), Orange (Admin)

    return Scaffold(
      // TODO: Implement your scaffold here
      body: widget.child,
    );
  }

  // TODO: Add helper methods for:
  // - Getting app bar title based on route
  // - Getting theme color based on user role
  // - Showing logout confirmation dialog
  // - Accessing user data from route parameters
}
