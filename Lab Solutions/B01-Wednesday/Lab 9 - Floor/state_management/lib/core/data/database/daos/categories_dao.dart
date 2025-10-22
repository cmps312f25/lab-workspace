import 'package:floor/floor.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';

@dao
abstract class CategoryDao {
  @Query("SELECT * FROM categories")
  Stream<List<Category>> observeCategories();

  @Query("SELECT * FROM categories WHERE id =:id")
  Future<Category?> getCategoryById(int id);

  @insert
  Future<void> addCategory(Category category);

  @update
  Future<void> updateCategory(Category category);

  @delete
  Future<void> deleteCategory(Category category);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertCategory(Category category);

  @Query("SELECT * FROM categories")
  Future<List<Category>> getAllCategories();

  @insert
  Future<void> insertCategories(List<Category> categories);

  @Query("DELETE FROM categories")
  Future<void> deleteAllCategories();
}
