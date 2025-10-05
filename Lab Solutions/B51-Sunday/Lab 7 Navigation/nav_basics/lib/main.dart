import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MaterialApp.router(routerConfig: AppRouter._router));
}

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nav Demo")),
      body: Container(
        color: Colors.red,
        child: InkWell(
          onTap: () {
            // here we will navigate to page B
          },
          child: Center(
            child: Text(
              "I am Page A",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nav Demo")),
      body: Container(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            // here we will navigate to page B
          },
          child: Center(
            child: Text(
              "I am Page B",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class AppRouter {
  static final _router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(path: "/", builder: (context, state) => const PageA()),
      // GoRoute(path: "/pageA", builder: (context, state) => const PageA()),
      // GoRoute(path: "/pageB", builder: (context, state) => const PageA()),
      // GoRoute(path: "/pageC", builder: (context, state) => const PageA()),
    ],
  );
}
