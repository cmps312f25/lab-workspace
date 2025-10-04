import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  String imageUrl;
  String name;
  String department;
  String role;
  String status;
  ProfileCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.department,
    required this.role,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 100,
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 40),
              SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(department),
                  Text(role),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
