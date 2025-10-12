import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/core/navigations/app_router.dart';
import 'package:state_management_tut/features/dashboard/data/repository/book_repo_json.dart';


void main() async {
  // Ensure Flutter bindings are initialized before 
  // any async operations like asset loading
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the BookRepoJson to load and cache books
  await BookRepoJson.initialize();
  runApp(ProviderScope(child: const MyApp()));
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
