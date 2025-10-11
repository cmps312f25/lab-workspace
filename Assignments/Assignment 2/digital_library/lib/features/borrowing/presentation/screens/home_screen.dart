import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Build home screen with welcome message and 2 navigation cards
    // Navigate to library items and members screens

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome to Digital Library'),
            Text('Manage your library items and members'),
            SizedBox(height: 20),
            Text('[Library Items Card]'),
            Text('[Members Card]'),
          ],
        ),
      ),
    );
  }
}
