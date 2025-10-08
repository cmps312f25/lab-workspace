import 'package:go_router/go_router.dart';
import 'package:nav_intro/presentations/page_a.dart';
import 'package:nav_intro/presentations/page_b.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      // ShellRoute(routes: routes)
      GoRoute(path: "/", builder: (context, state) => PageA()),
      GoRoute(path: "/pageb", builder: (context, state) => PageB()),
    ],
  );
}
