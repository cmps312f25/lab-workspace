import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/category.dart';
import 'package:dio/dio.dart';

class CategoryRepoApi implements CategoryRepository {
  final Dio _dio;
  static const String _baseUrl =
      'https://cmps312-books-api.vercel.app/api/categories';

  CategoryRepoApi(this._dio);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get(_baseUrl);
      final List<dynamic> data = response.data as List;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');
      return Category.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCategory(Category category) async {
    try {
      await _dio.post(
        _baseUrl,
        data: {
          'name': category.name,
          'description': category.description,
        },
      );
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  @override
  Future<void> updateCategory(Category category) async {
    if (category.id == null) {
      throw Exception('Category ID is required for update');
    }

    try {
      await _dio.put(
        '$_baseUrl/${category.id}',
        data: {
          'name': category.name,
          'description': category.description,
        },
      );
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory(Category category) async {
    if (category.id == null) {
      throw Exception('Category ID is required for deletion');
    }

    try {
      await _dio.delete('$_baseUrl/${category.id}');
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
