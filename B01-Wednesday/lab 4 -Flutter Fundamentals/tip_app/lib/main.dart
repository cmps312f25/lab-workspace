import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: Icon(Icons.menu, color: Colors.white),
          centerTitle: true,
          title: Text(
            "Tip App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Arial",
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Text(
            "Hello, World!",
            style: TextStyle(
              fontSize: 22,
              color: Colors.red,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
