import 'package:chat_app/features/auth/presentation/screens/login_screen.dart';
import 'package:chat_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:chat_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:chat_app/features/chat/presentation/screens/rooms_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// App Router Configuration using GoRouter
class AppRouter {
  // Route definitions
  static const login = (
    path: "/login",
    name: "login",
  );

  static const signup = (
    path: "/signup",
    name: "signup",
  );

  static const rooms = (
    path: "/rooms",
    name: "rooms",
  );

  static const chat = (
    path: "/chat/:roomId",
    name: "chat",
  );

  // Router configuration
  static final router = GoRouter(
    initialLocation: _getInitialLocation(),
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      final isAuthRoute = state.matchedLocation == login.path ||
          state.matchedLocation == signup.path;

      // If not logged in and not on auth route, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return login.path;
      }

      // If logged in and on auth route, redirect to rooms
      if (isLoggedIn && isAuthRoute) {
        return rooms.path;
      }

      return null;
    },
    routes: [
      // Login Screen (Day 1)
      GoRoute(
        path: login.path,
        name: login.name,
        builder: (context, state) => const LoginScreen(),
      ),

      // Sign Up Screen (Day 1)
      GoRoute(
        path: signup.path,
        name: signup.name,
        builder: (context, state) => const SignUpScreen(),
      ),

      // Rooms Screen (Day 2)
      GoRoute(
        path: rooms.path,
        name: rooms.name,
        builder: (context, state) => const RoomsScreen(),
      ),

      // Chat Screen (Day 3 & 4)
      GoRoute(
        path: chat.path,
        name: chat.name,
        builder: (context, state) {
          final roomId = int.parse(state.pathParameters['roomId'] ?? '0');
          final extra = state.extra as Map<String, dynamic>?;
          final roomName = extra?['roomName'] ?? 'Chat';
          return ChatScreen(
            roomId: roomId,
            roomName: roomName,
          );
        },
      ),
    ],
  );

  /// Determine initial location based on auth state
  static String _getInitialLocation() {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    return isLoggedIn ? rooms.path : login.path;
  }
}
