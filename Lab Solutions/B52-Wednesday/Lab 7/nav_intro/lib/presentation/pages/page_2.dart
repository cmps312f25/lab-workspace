import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo Nav App")),
      body: InkWell(
        onTap: () => context.go("/page1"),
        child: Container(
          color: Colors.blue,
          child: Center(child: Text("I am Page 2")),
        ),
      ),
    );
  }
}
