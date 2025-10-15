import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:state_manage_tut/core/widgets/main_scaffold.dart';
import 'package:state_manage_tut/features/dashboard/presentation/screens/dashboard.dart';
import 'package:state_manage_tut/features/settings/presentation/screens/settings.dart';

class AppRouter {
  static final dashboard = (
    path: "/",
    name: "dashboard",
    screen: const Dashboard(),
  );
  static final settings = (
    path: "/settings",
    name: "settings",
    screen: const Settings(),
  );

  static final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: dashboard.path,
            name: dashboard.name,
            builder: (context, state) => dashboard.screen,
            routes: [
              GoRoute(
                path: settings.path,
                name: settings.name,
                builder: (context, state) => settings.screen,
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
