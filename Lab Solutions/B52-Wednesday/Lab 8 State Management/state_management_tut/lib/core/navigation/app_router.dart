import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_management_tut/core/widget/main_scaffold.dart';
import 'package:state_management_tut/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:state_management_tut/features/settings/presentations/screens/settings_screen.dart';

class AppRouter {
  static final dashboard = (
    path: "/",
    name: "dashboard",
    screen: DashboardScreen(),
  );
  static final settings = (
    path: "/settings",
    name: "settings",
    screen: SettingsScreen(),
  );

  // create the router here

  static final router = GoRouter(
    initialLocation: dashboard.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: dashboard.path,
            name: dashboard.name,
            builder: (context, state) => dashboard.screen,
          ),
          GoRoute(
            path: settings.path,
            name: settings.name,
            builder: (context, state) => settings.screen,
          ),
        ],
      ),
    ],
  );
}
