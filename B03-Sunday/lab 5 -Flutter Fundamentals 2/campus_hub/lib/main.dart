import 'package:campus_hub/widgets/base_app_bar.dart';
import 'package:campus_hub/widgets/profile_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "Tutors Profile",
        icon: Icon(Icons.settings, color: Colors.white),
        bgColor: Colors.purple,
      ),
      body: Column(
        children: [
          ProfileCard(
            imageUrl:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKjt-wJHUohkYzR9JdPWjvLciHL68iZG_cA5UMqIKbacGrQlrzjxYN5Vlf-ss-BOvdoQM&usqp=CAU",
            name: "Mohamed Waleed",
            department: "department",
            role: "role",
            status: "status",
          ),
          Wrap(
            children: [
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
              Chip(label: Text("Flutter"), backgroundColor: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}
