import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QQDemo Nav App")),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            context.go("/");
          } else if (index == 1) {
            context.go("/page2/ali/22");

            // goName
            //go
            // push
            //replace
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Page 1"),
          BottomNavigationBarItem(icon: Icon(Icons.details), label: "Page 2"),
        ],
      ),
    );
  }
}
