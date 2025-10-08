import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo Nav App")),
      body: InkWell(
        onTap: () {
          context.go("/page2");
        },
        child: Container(
          color: Colors.red,
          child: Center(
            child: Text("I am Page 1 -> Click to go to Page 2")),
        ),
      ),
    );
  }
}
