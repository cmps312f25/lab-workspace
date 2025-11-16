import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepoApi implements CategoryRepository {
  final SupabaseClient _client;
  final String categoryTable = "categories";

  CategoryRepoApi(this._client);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _client.from(categoryTable).select();

      final List<dynamic> data = response as List;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    try {
      final response = await _client
          .from(categoryTable)
          .select()
          .eq("id", id)
          .single();

      return Category.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCategory(Category category) async {
    try {
      await _client.from(categoryTable).insert({
        'name': category.name,
        'description': category.description,
      });
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
      await _client
          .from(categoryTable)
          .update({'name': category.name, 'description': category.description})
          .eq("id", category.id!);
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
      await _client.from(categoryTable).delete().eq("id", category.id!);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
