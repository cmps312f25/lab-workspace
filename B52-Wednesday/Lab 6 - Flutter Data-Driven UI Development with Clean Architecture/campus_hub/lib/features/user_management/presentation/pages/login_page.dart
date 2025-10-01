import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the login page design here
    // Available data: No user data needed for login
    // Requirements:
    // - Create a login form with email and password fields
    // - Add app branding/logo
    // - Include role selection (student/tutor/admin)
    // - Follow the design guidelines in DESIGN_GUIDELINES.md
    //
    // HINT: Use Material Design 3 components

    // - TextFormField for email and password inputs
    // - DropdownButtonFormField or RadioListTile for role selection
    // - ElevatedButton for the login button
    // - Card or Container for form layout
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Campus Hub',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          // SizedBox(height: 20),
          Text('Tutoring Platform', style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              // keyboardType: TextInputType.emailAddress,
            ),
          ),
          Text("Select Your Role :  "),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: DropdownButtonFormField<String>(
          //     decoration: InputDecoration(
          //       border: OutlineInputBorder(),
          //       prefixIcon: Icon(Icons.person),
          //     ),
          //     items: <String>['Student', 'Tutor', 'Admin'].map((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //     onChanged: (String? newValue) {},
          //   ),
          // ),
        ],
      ),
    );
  }
}
