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
            // context.goNamed("details");
            // context.go("/pageB");
            context.push("/pageB/1");
          },
          child: Center(
            child: Text(
              "I am Page AA",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class PageB extends StatelessWidget {
  final int id;
  const PageB({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nav Demo")),
      body: Container(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            // here we will navigate to page B
            // context.go("/");
            context.pop();
          },
          child: Center(
            child: Text(
              "I am Page B and you sent me id: $id",
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
      GoRoute(
        name: "details",
        path: "/pageB/:id",
        builder: (context, state) {
          // a way to extract parameters from the state object
          final id = int.tryParse(state.pathParameters['id']!) ?? 0;
          return PageB(id: id);
        },
      ),

      // GoRoute(path: "/pageA", builder: (context, state) => const PageA()),
      // GoRoute(path: "/pageB", builder: (context, state) => const PageA()),
      // GoRoute(path: "/pageC", builder: (context, state) => const PageA()),
    ],
  );
}
