import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/core/navigations/app_router.dart';
import 'package:state_management_tut/core/data/database/database_provider.dart';
import 'package:state_management_tut/core/data/database/database_seeder.dart';

void main() async {
  // Ensure Flutter bindings are initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Create a ProviderContainer to access providers during initialization
  final container = ProviderContainer();

  try {
    // Get the database instance
    final database = await container.read(databaseProvider.future);

    // Seed the database (will only seed if empty)
    await DatabaseSeeder.seedDatabase(database);

    debugPrint('Database initialized and seeded successfully');
  } catch (e) {
    debugPrint('Error initializing database: $e');
  }

  // Run the app with the provider container
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
