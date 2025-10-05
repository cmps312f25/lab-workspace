import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Common Nav")),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          if (index == 0) context.go("/") else context.go("/pageB"),
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
          BottomNavigationBarItem(
            icon: Icon(Icons.portable_wifi_off_outlined),
            label: "Wifi",
          ),
        ],
      ),
    );
  }
}
