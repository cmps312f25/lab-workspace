import 'package:go_router/go_router.dart';
import 'package:nav_intro/presentation/page_a.dart';
import 'package:nav_intro/presentation/page_b.dart';
import 'package:nav_intro/presentation/page_b1.dart';
import 'package:nav_intro/presentation/widget/main_scafold.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: "/",
            builder: (context, state) => PageA(),
            routes: [
              GoRoute(
                path: "pageB/:name",
                builder: (context, state) {
                  final String name = state.pathParameters["name"]!;

                  return PageB(name: name);
                },
                routes: [
                  GoRoute(
                    path: "PageB1",
                    builder: (context, state) => PageB1(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
