import 'package:flutter/material.dart';

class TipCalculator extends StatefulWidget {
  const TipCalculator({super.key});

  @override
  State<TipCalculator> createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  String title = "";
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Tip Calculator", style: TextStyle(fontSize: 20)),
        TextField(
          decoration: InputDecoration(
            hintText: "Enter Amount",
            border: OutlineInputBorder(),
          ),
        ),
        Text("Select Tip Percentage", style: TextStyle(fontSize: 20)),
        Divider(),
        RadioGroup(
          groupValue: 30,
          onChanged: (value) {},
          child: Column(
            children: [
              RadioListTile(value: 10, title: Text("10")),
              RadioListTile(value: 20, title: Text("20")),
              RadioListTile(value: 30, title: Text("30")),
            ],
          ),
        ),
        SwitchListTile(
          value: true,
          onChanged: (value) {},
          title: Text("Round Tip Up"),
        ),
      ],
    );
  }
}
