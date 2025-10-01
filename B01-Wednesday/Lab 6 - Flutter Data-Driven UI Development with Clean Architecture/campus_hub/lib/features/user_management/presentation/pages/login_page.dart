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
          Text(
            'Login Page - Design Implementation Needed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'You should implement the login UI here',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
