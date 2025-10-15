import 'package:go_router/go_router.dart';
import 'package:state_manage_tut/features/dashboard/presentation/screens/dashboard.dart';
import 'package:state_manage_tut/features/settings/presentation/screens/settings.dart';

class AppRouter {
  static final dashboard = (
    path: "/",
    name: "dashboard",
    screen: const Dashboard(),
  );
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: dashboard.path,
        name: dashboard.name,
        builder: (context, state) => dashboard.screen,
        routes: [
          GoRoute(
            path: "settings",
            name: "settings",
            builder: (context, state) => const Settings(),
          ),
        ],
      ),
    ],
  );
}
