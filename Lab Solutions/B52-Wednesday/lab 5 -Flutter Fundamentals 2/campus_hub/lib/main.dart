import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _pages = [StudentProfile(), TutorsProfile(), AdminProfile()];
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("I will let you do it")),
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Student Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Tutors Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Admin Profile",
          ),
        ],
      ),
    );
  }
}

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: Colors.red,
      child: Column(
        children: [
          Wrap(
            children: [
              Chip(label: Text("Student")),
              Chip(label: Text("Profile")),
              Chip(label: Text("Student")),
              Chip(label: Text("Profile")),
              Chip(label: Text("Student Profile")),
              Chip(label: Text("Student Profile")),
              Chip(label: Text("Student Profile")),
              Chip(label: Text("Student Profile")),
              Chip(label: Text("Student Profile")),
              Chip(label: Text("Student Profile")),
              Chip(label: Text("Student Profile")),
              Chip(label: Text("Student Profile")),
            ],
          ),

          Card(
            elevation: 10,
            child: ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  "https://media.istockphoto.com/id/1370949614/photo/midlle-eastern-woman-outdoors-wearing-a-black-hijab.jpg?s=612x612&w=0&k=20&c=RuwwAjhrU1bg1MPPDUAoywE2TKr0hF6ecnJ1VuztwQs=",
                ),
              ),
              title: Column(
                children: [
                  Text(
                    "The title you want to display",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "The title you want to display",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "The title you want to display",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              subtitle: Text("The sub title"),
              trailing: Icon(Icons.star, color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorsProfile extends StatelessWidget {
  const TutorsProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.yellow,
      child: Center(child: const Text("Tutors Profile")),
    );
  }
}

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
      child: Center(child: const Text("Admin Profile")),
    );
  }
}
