import 'package:flutter/material.dart';
import 'package:tip_app/widgets/main_app_bar.dart';
import 'package:tip_app/widgets/tip_calculator_page.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body: Container(
        color: Colors.red,
        child: const Center(child: Text('This is Page 2')),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: Container(
        color: Colors.blue,
        child: const Center(child: Text('This is Page 2')),
      ),
    );
  }
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[Page1(), Page2()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: 'Tip App', color: Colors.red),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          _selectedIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Page1'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Page2'),
        ],
      ),
    );
  }
}
