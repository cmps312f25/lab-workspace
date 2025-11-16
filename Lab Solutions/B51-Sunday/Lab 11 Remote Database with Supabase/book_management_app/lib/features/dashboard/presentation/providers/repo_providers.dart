import 'package:book_management_app/features/dashboard/data/repository/book_repo_api.dart';
import 'package:book_management_app/features/dashboard/data/repository/category_repo_api.dart';
import 'package:book_management_app/features/dashboard/domain/contracts/book_repo.dart';
import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );
});

// Repository Providers
final bookRepoProvider = Provider<BookRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return BookRepoApi(dio);
});

final categoryRepoProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepoApi(Supabase.instance.client);
});
