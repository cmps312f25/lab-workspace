import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            children: [
              Card(
                color: Colors.lightGreen,
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
                  child: Text(
                    "This is my first apps",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Times New Roman",
                      // backgroundColor: Colors.amber[50],
                      letterSpacing: 3,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.purple,
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
                  child: Text(
                    "This is my first apps",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Times New Roman",
                      // backgroundColor: Colors.amber[50],
                      letterSpacing: 3,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.pink,
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
                  child: Text(
                    "This is my first apps",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Times New Roman",
                      // backgroundColor: Colors.amber[100],
                      letterSpacing: 3,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
