import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(appBar: _appBar(), 
      body: _body()
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        "Tip App",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.red,
    );
  }

  Widget _body() {
    return Container(child: Text("This is the body"));
  }
}
