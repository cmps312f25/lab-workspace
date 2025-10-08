import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo Nav App")),
      body: Container(
        color: Colors.red,
        child: Center(child: Text("I am Page 1")),
      ),
    );
  }
}
