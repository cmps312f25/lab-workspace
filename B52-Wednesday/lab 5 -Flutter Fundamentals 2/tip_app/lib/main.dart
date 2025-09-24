import 'package:flutter/material.dart';
import 'package:tip_app/widgets/my_app_bar.dart';
import 'package:tip_app/widgets/tip_calculator.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Tip App", color: Colors.red),
      body: TipCalculator(),
    );
  }
}
