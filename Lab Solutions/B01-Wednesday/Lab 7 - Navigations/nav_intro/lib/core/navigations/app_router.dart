import 'package:go_router/go_router.dart';
import 'package:nav_intro/presentations/main_scaffold.dart';
import 'package:nav_intro/presentations/page_a.dart';
import 'package:nav_intro/presentations/page_b.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      // ShellRoute(routes: routes)
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: "/",
            name: "home",
            builder: (context, state) => PageA(),
          ),
          GoRoute(
            path: "/pageb",
            name: "details",
            builder: (context, state) => PageB(),
          ),
        ],
      ),
    ],
  );
}
