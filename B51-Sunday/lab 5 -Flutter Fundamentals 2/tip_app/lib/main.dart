import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _tipPercentage = 30;

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
        // mainAxisAlignment: MainAxisAlignment.center,
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
          RadioGroup<int>(
            onChanged: (value) {
              setState(() {
                // TRIGGER UI REFRESH
                _tipPercentage = value!;
              });
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
        ],
      ),
    );
  }
}
