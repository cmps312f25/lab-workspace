import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/data_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: Build login UI with form validation
    // Use DataService().authenticate(username, password)
    // Navigate to home on successful login

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Digital Library'),
            Text('Library Staff Portal'),
            Text('[Username Field]'),
            Text('[Password Field]'),
            Text('[Login Button]'),
            Text('Demo: admin / admin123'),
          ],
        ),
      ),
    );
  }
}
