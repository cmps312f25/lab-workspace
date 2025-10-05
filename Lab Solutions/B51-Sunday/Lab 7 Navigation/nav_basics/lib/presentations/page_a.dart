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
          // here we will navigate to page B
          // context.goNamed("details");
          // context.go("/pageB");
          context.push("/pageB/1/John");
        },
        child: Center(
          child: Text(
            "I am Page AA",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
