import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // context.go("/pageB");
        context.push("/pageB/Abdulahi");
      },
      child: Container(color: Colors.amber),
    );
  }
}
