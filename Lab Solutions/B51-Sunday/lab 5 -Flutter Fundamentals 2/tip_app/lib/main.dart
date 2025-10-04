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
  int _tipPercentage = 30;
  double _billAmount = 0.0;
  double totalBillAmount = 0.0;
  bool _roundTip = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(appBar: _appBar(), body: _body()),
    );
  }

  PreferredSizeWidget? _appBar() {
    return AppBar(
      title: Text(
        "Tip App",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.red,
    );
  }

  Widget _body() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Text(
                  "Tip Calculator",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  onChanged: (value) {
                    _billAmount = double.tryParse(value) ?? 0.0;
                    calculateBill();
                  },
                  decoration: InputDecoration(
                    hintText: "Bill Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Text(
                "Tip Calculator",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Divider(),
              SizedBox(height: 30),
              Card.outlined(
                elevation: 10,
                child: RadioGroup<int>(
                  onChanged: (value) {
                    _tipPercentage = value!;
                    calculateBill();
                  },
                  groupValue: _tipPercentage,
                  child: Column(
                    children: [
                      RadioListTile(value: 10, title: Text("10")),
                      RadioListTile(value: 20, title: Text("20")),
                      RadioListTile(value: 30, title: Text("30")),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),
              Card.filled(
                elevation: 10,
                child: SwitchListTile(
                  value: _roundTip,
                  onChanged: (value) {
                    _roundTip = value;
                    calculateBill();
                  },
                  title: Text("Round Up Tip"),
                ),
              ),
            ],
          ),

          Container(
            color: Colors.red,
            width: double.infinity,
            height: 100,
            child: Center(
              child: Text(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                "Bill Amount : $totalBillAmount",
              ),
            ),
          ),
        ],
      ),
    );
  }

  void calculateBill() {
    setState(() {
      totalBillAmount = _billAmount + _billAmount * _tipPercentage / 100;
      if (_roundTip) {
        totalBillAmount = totalBillAmount.ceilToDouble();
        debugPrint(totalBillAmount.toString());
      }
    });
  }
}
