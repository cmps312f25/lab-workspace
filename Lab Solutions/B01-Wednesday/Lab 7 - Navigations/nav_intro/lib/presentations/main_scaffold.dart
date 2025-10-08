import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Scaffold Nav Demo")),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              context.go("/");
              break;
            case 1:
              context.go("/pageb/Omar/33");
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "PAGE A"),
          BottomNavigationBarItem(icon: Icon(Icons.details), label: "PAGE B"),
        ],
      ),
    );
  }
}
