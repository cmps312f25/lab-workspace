import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageB extends StatelessWidget {
  final String name;
  const PageB({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // context.go("/");
        context.pop();
      },
      child: Container(color: Colors.red, child: Text(name)),
    );
  }
}
