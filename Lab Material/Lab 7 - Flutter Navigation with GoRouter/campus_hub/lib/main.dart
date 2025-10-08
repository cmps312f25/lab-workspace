import 'package:campus_hub/core/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'features/user_management/presentation/pages/page_selector.dart';

void main() {
  runApp(const CampusHubApp());
}

class CampusHubApp extends StatelessWidget {
  const CampusHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CampusHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: const PageSelector(),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      // TODO: Replace with GoRouter implementation
      // routerConfig: AppRouter.router,
    );
  }
}

class MyWidget extends StatefulWidget {
  final String title;
  const MyWidget({super.key, required this.title});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.title);
  }
}
