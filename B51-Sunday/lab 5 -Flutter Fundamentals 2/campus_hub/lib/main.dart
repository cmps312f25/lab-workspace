import 'package:campus_hub/widgets/main_app_bar.dart';
import 'package:campus_hub/widgets/profile_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "My Profile", bgColor: Colors.purpleAccent),
      body: Column(children: [ProfileCard()]),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
