import 'package:flutter/material.dart';
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
            routes: [
              GoRoute(
                path: "pageb/:name/:age",
                name: "details",
                builder: (context, state) {
                  final String name = state.pathParameters["name"]!;
                  final String age = state.pathParameters["age"]!;
                  // int.parse(age);
                  debugPrint(name);
                  debugPrint(age);
                  return PageB(name: name, age: age);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}


// pageb/dashboard