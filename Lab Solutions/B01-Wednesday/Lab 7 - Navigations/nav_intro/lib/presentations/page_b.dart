import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nav Demo")),
      body: Container(
        color: Colors.lightBlue,
        child: InkWell(
          onTap: () => context.go("/"),
          child: Center(child: Text("Page B -> Click Me to Navigate to A")),
        ),
      ),
    );
  }
}
