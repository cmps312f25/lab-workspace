import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: InkWell(
        onTap: () {
          context.go("/pageb/ali/22");
          // context.push("/pageb");
          // context.goNamed("details");
        },
        child: Center(child: Text("Page A -> Click Me to Navigate to B")),
      ),
    );
  }
}
