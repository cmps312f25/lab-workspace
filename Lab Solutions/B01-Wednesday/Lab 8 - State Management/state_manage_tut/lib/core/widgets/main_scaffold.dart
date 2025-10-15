import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_manage_tut/core/navigation/app_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          if (index == 0)
            {context.go(AppRouter.dashboard.path)}
          else
            {context.push(AppRouter.settings.path)},
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
