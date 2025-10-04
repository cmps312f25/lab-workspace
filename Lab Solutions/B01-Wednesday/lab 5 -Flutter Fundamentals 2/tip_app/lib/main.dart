import 'package:flutter/material.dart';
import 'package:tip_app/widgets/main_app_bar.dart';
import 'package:tip_app/widgets/tip_calculator_page.dart';

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
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: 'Tip App', color: Colors.red),
      body: TipCalculatorPage(),
    );
  }
}
