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

  @override
  Future<CategoryData> build() async {
    final categories = await _categoryRepo.getCategories();
    return CategoryData(categories: categories);
  }

  Future<void> refreshCategories() async {
    state = const AsyncLoading();
    try {
      final categories = await _categoryRepo.getCategories();
      state = AsyncData(CategoryData(
        categories: categories,
        selectedCategory: state.value?.selectedCategory,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await _categoryRepo.addCategory(category);
      await refreshCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _categoryRepo.updateCategory(category);
      await refreshCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(Category category) async {
    try {
      await _categoryRepo.deleteCategory(category);
      await refreshCategories();
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
