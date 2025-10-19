import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/core/data/database/database_provider.dart';
import 'package:state_management_tut/features/dashboard/data/repository/book_repo_local_db.dart';
import 'package:state_management_tut/features/dashboard/data/repository/category_repo_local_db.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/book_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/category_repo.dart';

















// // Return interface types, not concrete implementations
// final bookRepoProvider = FutureProvider<BookRepository>((ref) async {
//   final database = await ref.watch(databaseProvider.future);
//   return BookRepoLocalDB(database.bookDao);
// });

// final categoryRepoProvider = FutureProvider<CategoryRepository>((ref) async {
//   final database = await ref.watch(databaseProvider.future);
//   return CategoryRepoLocalDB(database.categoryDao);
// });
