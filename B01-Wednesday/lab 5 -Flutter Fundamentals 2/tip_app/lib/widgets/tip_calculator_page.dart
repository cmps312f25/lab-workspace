import 'package:flutter/material.dart';

class TipCalculatorPage extends StatefulWidget {
  const TipCalculatorPage({super.key});

  @override
  State<TipCalculatorPage> createState() => _TipCalculatorPageState();
}

class _TipCalculatorPageState extends State<TipCalculatorPage> {
  double _billAmount = 0.0;
  double _totalBill = 0.0;

  void calculateTotalBill() {
    setState(() {
      _totalBill = _billAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Tip Calculator"),
        TextField(
          onChanged: (value) {
            _billAmount = double.tryParse(value) ?? 0.0;
          },
        ),
        Text("Select Tip Percentage"),
        Text("$_billAmount"),
        Text("Total Amount : ${_totalBill + (_totalBill * 0.15)}"),
      ],
    );
  }
}
