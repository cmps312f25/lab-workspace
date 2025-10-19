import 'package:state_management_tut/core/data/database/daos/categories_dao.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/category_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';

class CategoryRepoLocalDb implements CategoryRepository {
  final CategoryDao _categoryDao;

  CategoryRepoLocalDb(this._categoryDao);

  @override
  Future<void> addCategory(Category category) =>
      _categoryDao.addCategory(category);

  @override
  Future<void> deleteCategory(Category category) =>
      _categoryDao.deleteCategory(category);

  @override
  Stream<List<Category>> getCategories() => _categoryDao.observeCategories();

  @override
  Future<Category?> getCategoryById(int id) => _categoryDao.getCategoryById(id);

  @override
  Future<void> updateCategory(Category category) =>
      _categoryDao.updateCategory(category);
}
