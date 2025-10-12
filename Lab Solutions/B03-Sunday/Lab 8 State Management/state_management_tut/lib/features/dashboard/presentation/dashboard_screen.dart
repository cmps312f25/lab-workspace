import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) =>
              Card(child: ListTile(title: Text("$index Title"))),
          itemCount: 20,
        ),
      ),
    );
  }
}
