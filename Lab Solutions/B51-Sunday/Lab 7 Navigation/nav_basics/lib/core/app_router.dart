import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nav_basics/presentations/page_a.dart';
import 'package:nav_basics/presentations/page_b.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(title: const Text("Nav Demo - Shell Route")),
          body: child,
        ),
        routes: [
          GoRoute(path: "/", builder: (context, state) => const PageA()),
          GoRoute(
            name: "details",
            path: "/pageB/:id/:name",
            builder: (context, state) {
              // a way to extract parameters from the state object
              final id = int.tryParse(state.pathParameters['id']!) ?? 0;
              final name = state.pathParameters['name'] ?? '';
              return PageB(id: id, name: name);
            },
            redirect: (context, state) {
              // if the id is less than 1 redirect to page A
              final id = int.tryParse(state.pathParameters['id']!) ?? 0;
              if (id < 1) {
                return "/";
              }
              return null;
            },
          ),
        ],
      ),

      // GoRoute(path: "/pageA", builder: (context, state) => const PageA()),
      // GoRoute(path: "/pageB", builder: (context, state) => const PageA()),
      // GoRoute(path: "/pageC", builder: (context, state) => const PageA()),
    ],
  );
}
