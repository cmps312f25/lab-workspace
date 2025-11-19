import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/category.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepoApi implements CategoryRepository {
  final SupabaseClient _client;
  final String categoryTable = "category";

  // _client.from(tablename).de().eq().order().single()

  CategoryRepoApi(this._client);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final data = await _client.from(categoryTable).select();
      // final List<dynamic> data = response.data as List;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    try {
      final data = await _client
          .from(categoryTable)
          .select()
          .eq("id", id)
          .single();
      return Category.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCategory(Category category) async {
    try {
      await _client.from(categoryTable).insert(category.toJson());
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
          .update(category.toJson())
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

  @override
  Stream<List<Category>> watchCategories() {
    return _client
        .from(categoryTable)
        .stream(primaryKey: ["id"])
        .map((data) => data.map((json) => Category.fromJson(json)).toList());
  }
}
