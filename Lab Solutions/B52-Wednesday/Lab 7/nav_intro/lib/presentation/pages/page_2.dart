import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          // context.pop()
          // context.goNamed("home");
          context.push("/");
          // context.go("home");
        },
        child: Center(child: Text("I am Page 2")),
      ),
    );
  }
}
