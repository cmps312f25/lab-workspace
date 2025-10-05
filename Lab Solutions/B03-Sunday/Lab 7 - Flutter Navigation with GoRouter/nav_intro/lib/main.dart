import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MaterialApp.router(routerConfig: AppRouter.router));
}

// go router
class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: "/", builder: (context, state) => PageA()),
      GoRoute(path: "/pageB", builder: (context, state) => PageB()),
    ],
  );
}

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Common Nav")),
      body: Container(color: Colors.amber),
    );
  }
}

class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Common Nav")),
      body: Container(color: Colors.red),
    );
  }
}
