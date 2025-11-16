import 'package:book_management_app/features/dashboard/data/repository/book_repo_api.dart';
import 'package:book_management_app/features/dashboard/data/repository/category_repo_api.dart';
import 'package:book_management_app/features/dashboard/domain/contracts/book_repo.dart';
import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Providers
final bookRepoProvider = Provider<BookRepository>((ref) {
  return BookRepoApi(Dio());
});

final categoryRepoProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepoApi(Dio());
});
