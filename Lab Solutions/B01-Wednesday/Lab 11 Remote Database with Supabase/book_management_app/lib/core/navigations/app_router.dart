import 'package:go_router/go_router.dart';
import 'package:book_management_app/features/dashboard/domain/entities/book.dart';
import 'package:book_management_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:book_management_app/features/dashboard/presentation/screens/books_by_category_screen.dart';
import 'package:book_management_app/features/dashboard/presentation/screens/add_edit_book_screen.dart';

class AppRouter {
  static final home = (path: "/", name: "dashboard", screen: DashboardScreen());

  static final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: home.path,
        name: home.name,
        builder: (context, state) => home.screen,
      ),
      GoRoute(
        path: '/books/:categoryId',
        name: 'books_by_category',
        builder: (context, state) {
          final categoryId =
              int.parse(state.pathParameters['categoryId'] ?? '1');
          final extra = state.extra as Map<String, dynamic>?;
          final categoryName = extra?['categoryName'] ?? 'Books';

          return BooksByCategoryScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          );
        },
      ),
      GoRoute(
        path: '/book/add',
        name: 'add_book',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final categoryId = extra?['categoryId'] as int?;
          return AddEditBookScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/book/edit',
        name: 'edit_book',
        builder: (context, state) {
          final book = state.extra as Book;
          return AddEditBookScreen(book: book);
        },
      ),
    ],
  );
}
