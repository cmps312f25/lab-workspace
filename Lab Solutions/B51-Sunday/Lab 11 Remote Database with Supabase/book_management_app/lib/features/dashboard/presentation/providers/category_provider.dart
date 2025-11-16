import 'dart:async';

import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/category.dart';
import 'package:book_management_app/features/dashboard/presentation/providers/repo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryData {
  List<Category> categories;
  Category? selectedCategory;

  CategoryData({required this.categories, this.selectedCategory});
}

class CategoryNotifier extends AsyncNotifier<CategoryData> {
  CategoryRepository get _categoryRepo => ref.read(categoryRepoProvider);
  late StreamSubscription _streamSubscription;

  @override
  Future<CategoryData> build() async {
    _streamSubscription = _categoryRepo.watchCategories().listen((categories) {
      state = AsyncData(CategoryData(categories: categories));
    });

    ref.onDispose(() {
      _streamSubscription.cancel();
    });

    final categories = await _categoryRepo.getCategories();
    return CategoryData(categories: categories);
  }

  Future<void> addCategory(Category category) async {
    try {
      await _categoryRepo.addCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _categoryRepo.updateCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(Category category) async {
    try {
      await _categoryRepo.deleteCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  void updateSelectedCategory(Category? category) {
    if (state.value != null) {
      state = AsyncData(
        CategoryData(
          categories: state.value!.categories,
          selectedCategory: category,
        ),
      );
    }
  }

  Future<Category?> getCategoryById(int id) async {
    return await _categoryRepo.getCategoryById(id);
  }
}

final categoryNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, CategoryData>(
      () => CategoryNotifier(),
    );
