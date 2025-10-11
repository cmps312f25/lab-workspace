import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/borrowing/presentation/screens/home_screen.dart';
import '../../features/library_items/presentation/screens/library_items_screen.dart';
import '../../features/library_items/presentation/screens/library_item_details_screen.dart';
import '../../features/members/presentation/screens/members_screen.dart';
import '../../features/members/presentation/screens/member_details_screen.dart';
import 'shell_scaffold.dart';

// TODO: Configure all routes for the app
// Login route at /login (outside shell)
// ShellRoute with bottom nav (home, library items, members)
// Detail routes with parameters (outside shell)

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    // TODO: Add all routes here
  ],
);
