import 'package:go_router/go_router.dart';
import 'package:state_management_tut/features/dashboard/presentation/screens/dashboard_screen.dart';

class AppRouter {
  static final home = (path: "/", name: "dashboard", screen: DashboardScreen());

  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: home.path,
        name: home.name,
        builder: (context, state) => home.screen,
      ),
    ],
  );
}
