import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: InkWell(
        onTap: () {
          // context.go("/page2/ali/22");
          context.push("/page2/ali/22");
          // context.goNamed("details");
        },
        child: Center(child: Text("I am Page 1 -> Click to go to Page 2")),
      ),
    );
  }
}
