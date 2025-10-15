import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_management_tut/core/navigation/app_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Books Dashboard")),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => index == 0
            ? context.go(AppRouter.dashboard.path)
            : context.go(AppRouter.settings.path),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Books"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
