import '../entities/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> observeCategories();
  Future<Category?> getCategoryById(int id);
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(Category category);
}
