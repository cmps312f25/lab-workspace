import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nav_basics/presentations/page_a.dart';
import 'package:nav_basics/presentations/page_b.dart';

class Home extends StatelessWidget {
  final Widget child;
  const Home({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nav Demo - Shell Route")),
      body: child,
    );
  }
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
        builder: (context, state, child) => Home(child: child),
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

      GoRoute(
        path: "/pageC",
        builder: (context, state) => const PageC(),
        routes: [
        
      ]),
      // GoRoute(path: "/pageB", builder: (context, state) => const PageA()),
      // GoRoute(path: "/pageC", builder: (context, state) => const PageA()),
    ],
  );
}

class PageC extends StatefulWidget {
  const PageC({super.key});

  @override
  State<PageC> createState() => _PageCState();
}

class _PageCState extends State<PageC> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SafeArea(child: const Text("I am outside the shell route")),
      ),
    );
  }
}
