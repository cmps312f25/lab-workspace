import 'package:flutter/material.dart';
import 'features/user_management/presentation/pages/page_selector.dart';

void main() {
  runApp(const CampusHubApp());
}

class CampusHubApp extends StatelessWidget {
  const CampusHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PageSelector(),
      debugShowCheckedModeBanner: false,
      // TODO: Replace with GoRouter implementation
      // routerConfig: AppRouter.router,
    );
  }
}
