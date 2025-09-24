import 'package:flutter/material.dart';

class TipCalculator extends StatefulWidget {
  const TipCalculator({super.key});

  @override
  State<TipCalculator> createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  double _billAmount = 0.0;
  int _tipPercentage = 20;
  bool _roundUp = false;
  double _totalAmount = 0.0;

  void calculateTip() {
    setState(() {
      _totalAmount = _billAmount + _billAmount * (_tipPercentage / 100);
      if (_roundUp) {
        _totalAmount = _totalAmount.ceilToDouble();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 40),
        Text(
          "Tip Calculator",
          style: TextStyle(
            fontSize: 25,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            onChanged: (value) {
              _billAmount = double.tryParse(value) ?? 0.0;
              calculateTip();
            },
            decoration: InputDecoration(
              hintText: "Enter Amount",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Text("Select Tip Percentage", style: TextStyle(fontSize: 20)),
        Padding(padding: const EdgeInsets.all(20.0), child: Divider()),
        RadioGroup(
          groupValue: _tipPercentage,
          onChanged: (value) {
            _tipPercentage = value!;
            calculateTip();
          },
          child: Column(
            children: [
              RadioListTile(value: 10, title: Text("10")),
              RadioListTile(value: 20, title: Text("20")),
              RadioListTile(value: 30, title: Text("30")),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SwitchListTile(
            value: _roundUp,
            onChanged: (value) {
              _roundUp = value;
              calculateTip();
            },
            title: Text("Round Tip Up"),
          ),
        ),
        // Spacer(flex: 4),
        // ElevatedButton(
        //   onPressed: () {
        //     calculateTip();
        //   },
        //   style: ButtonStyle(
        //     backgroundColor: WidgetStatePropertyAll(Colors.red),
        //   ),
        //   child: Text("Calculate", style: TextStyle(color: Colors.white)),
        // ),
        Spacer(flex: 1),
        Container(
          width: double.infinity,
          height: 100,
          color: Colors.red,
          child: Center(
            child: Text(
              "Total Amount : $_totalAmount",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
