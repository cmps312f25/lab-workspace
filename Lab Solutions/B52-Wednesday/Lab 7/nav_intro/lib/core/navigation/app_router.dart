import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:nav_intro/presentation/pages/main_scaffold.dart';
import 'package:nav_intro/presentation/pages/page_1.dart';
import 'package:nav_intro/presentation/pages/page_2.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      // ShellRoute(routes: routes)
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: "/",
            name: "home",
            builder: (context, state) => Page1(),
          ),
          GoRoute(
            path: "/page2/:name/:age",
            name: "details",
            builder: (context, state) {
              final String name = state.pathParameters["name"]!;
              final int age = int.tryParse(state.pathParameters["age"]!) ?? 0;
              debugPrint(name);
              debugPrint("$age");
              return Page2();
            },
          ),
        ],
      ),
    ],
  );
}
