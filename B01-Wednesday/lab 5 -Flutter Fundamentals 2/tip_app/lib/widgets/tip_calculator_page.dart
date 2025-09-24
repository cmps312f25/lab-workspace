import 'package:flutter/material.dart';

class TipCalculatorPage extends StatefulWidget {
  const TipCalculatorPage({super.key});

  @override
  State<TipCalculatorPage> createState() => _TipCalculatorPageState();
}

class _TipCalculatorPageState extends State<TipCalculatorPage> {
  double _billAmount = 0.0;
  double _totalBill = 0.0;
  int _tipPercentage = 0;
  bool _roundUp = false;

  void calculateTotalBill() {
    setState(() {
      _totalBill = _billAmount + _billAmount * _tipPercentage / 100;
      if (_roundUp) _totalBill = _totalBill.ceilToDouble();
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
            calculateTotalBill();
          },
        ),
        Text("Select Tip Percentage"),
        Divider(),

        RadioGroup<int>(
          onChanged: (value) {
            _tipPercentage = value!;
            calculateTotalBill();
          },
          groupValue: _tipPercentage,

          child: Column(
            children: [
              RadioListTile(
                value: 10,
                title: Text("10", style: TextStyle(color: Colors.black)),
              ),
              RadioListTile(
                value: 20,
                title: Text("20", style: TextStyle(color: Colors.black)),
              ),
              RadioListTile(
                value: 30,
                title: Text("30", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
        SwitchListTile.adaptive(
          value: _roundUp,
          onChanged: (value) {
            _roundUp = value;
            calculateTotalBill();
          },
          title: Text("Round Tip"),
        ),
        Text("Total Amount : $_totalBill"),
      ],
    );
  }
}
