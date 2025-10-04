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

    return Column(
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
        SizedBox(height: 20),
        Text('Tutoring Platform', style: TextStyle(color: Colors.grey[600])),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: Icon(Icons.lock),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        SizedBox(height: 20),
        // Text("Select Role"),
        ElevatedButton(
          onPressed: () {},
          child: SizedBox(
            width: 100,
            child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ),
        // Spacer(),
      ],
    );
  }
}
