import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/category_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/repo_providers.dart';

class CategoryData {
  List<Category> categories;
  Category? selectedCategory;

  CategoryData({required this.categories, this.selectedCategory});
}

class CategoryNotifier extends AsyncNotifier<CategoryData> {
  late final CategoryRepository categoryRepo;

  @override
  Future<CategoryData> build() async {
    categoryRepo = await ref.read(categoryRepoProvider.future);
    categoryRepo.observeCategories().listen((categories) {
      state = AsyncData(
        CategoryData(
          categories: categories,
          selectedCategory: state.value?.selectedCategory,
        ),
      );
    });
    return CategoryData(categories: []);
  }

  /// Adds a new category to the repository and updates state
  Future<void> addCategory(Category category) async {
    try {
      await categoryRepo.addCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  /// Updates an existing category in the repository and updates state
  Future<void> updateCategory(Category category) async {
    try {
      await categoryRepo.updateCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes a category from the repository and updates state
  Future<void> deleteCategory(Category category) async {
    try {
      await categoryRepo.deleteCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the selected category in state
  void updateSelectedCategory(Category? category) {
    state = AsyncData(
      CategoryData(
        categories: state.value?.categories ?? [],
        selectedCategory: category,
      ),
    );
  }

  /// Clears the selected category
  void clearSelectedCategory() {
    state = AsyncData(
      CategoryData(
        categories: state.value?.categories ?? [],
        selectedCategory: null,
      ),
    );
  }

  /// Gets a category by its ID
  Future<Category?> getCategoryById(int id) async {
    return await categoryRepo.getCategoryById(id);
  }
}

final categoryNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, CategoryData>(
      () => CategoryNotifier(),
    );
