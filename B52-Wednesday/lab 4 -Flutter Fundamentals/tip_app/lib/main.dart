import 'package:flutter/cupertino.dart';
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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: CupertinoColors.systemYellow,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "First",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Times New Roman",
                      // backgroundColor: Colors.amber[50],
                      letterSpacing: 3,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.not_accessible, size: 50, color: Colors.red),
                  Image.network(
                    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
                    width: 200,
                    height: 200,
                  ),
                  Card(
                    color: Colors.purple,
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
                      child: Text(
                        "Second",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
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
                        "Third",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
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
        ),
      ),
    );
  }
}
