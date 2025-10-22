import 'package:floor/floor.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';

abstract class CategoryDao {
  Stream<List<Category>> getCategories();

  Future<Category?> getCategoryById(int id);

  Future<void> addCategory(Category category);

  Future<void> updateCategory(Category category);

  Future<void> deleteCategory(Category category);

  Future<void> upsertCategory(Category category);

  Future<List<Category>> getAllCategories();

  Future<void> insertCategories(List<Category> categories);

  Future<void> deleteAllCategories();
}
