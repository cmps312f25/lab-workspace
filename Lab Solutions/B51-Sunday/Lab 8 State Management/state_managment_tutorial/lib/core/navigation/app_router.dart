import 'package:go_router/go_router.dart';
import 'package:state_managment_tutorial/features/home/presentation/screens/books_list_screen.dart';

class AppRouter {
  static final home = (path: "/", name: "home", screen: BooksListScreen());

  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: home.path,
        name: home.name,
        builder: (context, state) => home.screen,
      ),
    ],
  );
}
