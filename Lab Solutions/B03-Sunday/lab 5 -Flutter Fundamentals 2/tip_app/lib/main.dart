import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _billAmount = 0.0;
  double _totalBill = 0;
  int _tipPercentage = 20;
  bool _roundUp = false;

  void calculateBillAmount() {
    setState(() {
      _totalBill = _billAmount + _billAmount * _tipPercentage / 100;
      if (_roundUp) {
        _totalBill = _totalBill.ceilToDouble();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tip App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          // stretched
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 40),
                ..._tipInput(),
                Text(
                  "Select Tip Percentage",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                Card.outlined(
                  margin: EdgeInsets.all(10),
                  elevation: 10,
                  // color: Colors.lightBlue,
                  child: RadioGroup<int>(
                    groupValue: _tipPercentage,
                    onChanged: (value) {
                      _tipPercentage = value!;
                      calculateBillAmount();
                    },
                    child: Column(
                      children: [
                        RadioListTile(value: 10, title: Text("10")),
                        RadioListTile(value: 20, title: Text("20")),
                        RadioListTile(value: 30, title: Text("30")),
                      ],
                    ),
                  ),
                ),
                // Spacer(flex: 1),
                Card.outlined(
                  child: SwitchListTile(
                    value: _roundUp,
                    onChanged: (value) {
                      _roundUp = value;
                      calculateBillAmount();
                    },
                    title: Text("Round Up Tip"),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 80,
              color: Colors.red,
              child: Center(
                child: Text(
                  "Amount $_totalBill",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tipInput() {
    return [
      Text(
        "Tip Calculator",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 40),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
          onChanged: (value) {
            _billAmount = int.tryParse(value)?.toDouble() ?? 0.0;
            calculateBillAmount();
          },
        ),
      ),
      SizedBox(height: 10),
    ];
  }
}
