import 'package:campus_hub/core/navigation/app_router.dart';
import 'package:campus_hub/core/data/database/database_provider.dart';
import 'package:campus_hub/core/data/database/database_seeder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Ensure Flutter bindings are initialized before using async operations
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: CampusHubApp(),
    ),
  );
}

// Database Initialization Provider
final databaseInitializationProvider = FutureProvider<void>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  await DatabaseSeeder.seedDatabase(database);
});

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
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
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
