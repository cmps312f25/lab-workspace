import 'package:flutter/material.dart';
import 'login_page.dart';
import 'student_profile_page.dart';
import 'tutor_profile_page.dart';
import 'admin_profile_page.dart';

class PageSelector extends StatefulWidget {
  const PageSelector({super.key});

  @override
  State<PageSelector> createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    LoginPage(),
    StudentProfilePage(),
    TutorProfilePage(),
    AdminProfilePage(),
  ];

  final List<String> pageNames = [
    'Login',
    'Student Profile',
    'Tutor Profile',
    'Admin Profile',
  ];

  void _goToPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Hub - ${pageNames[currentPageIndex]}'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _goToPage(0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPageIndex == 0
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () => _goToPage(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPageIndex == 1
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text('Student'),
                ),
                ElevatedButton(
                  onPressed: () => _goToPage(2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPageIndex == 2
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text('Tutor'),
                ),
                ElevatedButton(
                  onPressed: () => _goToPage(3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPageIndex == 3
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text('Admin'),
                ),
              ],
            ),
          ),
          Expanded(child: pages[currentPageIndex]),
        ],
      ),
    );
  }
}
