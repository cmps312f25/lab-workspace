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
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 40),
        Text(
          "Tip Calculator",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            onChanged: (value) {
              _billAmount = double.tryParse(value) ?? 0.0;
              calculateTotalBill();
            },
          ),
        ),
        Text(
          "Select Tip Percentage",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            // fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2,
          ),
        ),
        Padding(padding: const EdgeInsets.all(20), child: Divider()),

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
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: () {
            calculateTotalBill();
          },
          child: Text("Calculate", style: TextStyle(color: Colors.white)),
        ),

        // Card(
        //   child: ListTile(
        //     leading: CircleAvatar(
        //       radius: 20,
        //       backgroundImage: NetworkImage(
        //         "https://hips.hearstapps.com/hmg-prod/images/cristiano-ronaldo-of-portugal-during-the-uefa-nations-news-photo-1748359673.pjpeg?crop=0.610xw:0.917xh;0.317xw,0.0829xh&resize=640:*",
        //       ),
        //     ),
        //     title: Text("Cristiano Ronaldo", textAlign: TextAlign.center),
        //     subtitle: Text("The Goat", textAlign: TextAlign.center),
        //     trailing: Icon(Icons.delete, color: Colors.amber),
        //   ),
        // ),

        // Wra(
        //   children: [
        //     Chip(label: Text("Flutter")),
        //     Chip(label: Text("Flutter")),
        //     Chip(label: Text("Flutter")),
        //     Chip(label: Text("Flutter")),
        //     Chip(label: Text("Flutter")),
        //     Chip(label: Text("Flutter")),
        //   ],
        // ),
        SwitchListTile.adaptive(
          value: _roundUp,
          onChanged: (value) {
            _roundUp = value;
            calculateTotalBill();
          },
          title: Text("Round Tip"),
        ),
        Spacer(),
        Container(
          color: Colors.red,
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text(
              "Total Amount : $_totalBill",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
