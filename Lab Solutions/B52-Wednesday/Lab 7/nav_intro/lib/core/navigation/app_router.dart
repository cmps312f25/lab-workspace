import 'package:go_router/go_router.dart';
import 'package:nav_intro/presentation/pages/page_1.dart';
import 'package:nav_intro/presentation/pages/page_2.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      // ShellRoute(routes: routes)
      GoRoute(path: "/", builder: (context, state) => Page1()),
      GoRoute(
        path: "/page2", 
        builder: (context, state) => Page2()),
    ],
  );
}
