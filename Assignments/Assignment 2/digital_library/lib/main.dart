import 'package:digital_library/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/services/data_service.dart';

void main() async {
  // Initialize the data service
  WidgetsFlutterBinding.ensureInitialized();
  await DataService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Digital Library',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
    );
  }
}
