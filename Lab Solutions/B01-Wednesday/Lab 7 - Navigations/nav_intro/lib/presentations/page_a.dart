import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nav Demo")),
      body: Container(
        color: Colors.red,
        child: InkWell(
          onTap: () {
            context.go("/pageb");
          },
          child: Center(child: Text("Page A -> Click Me to Navigate to B")),
        ),
      ),
    );
  }
}
