import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/category.dart';
import 'package:dio/dio.dart';

/// Category Repository implementation
/// Currently reads from JSON file - you'll switch to API calls
class CategoryRepoApi implements CategoryRepository {
  final Dio _dio;
  static const String _baseUrl =
      'https://cmps312-books-api.vercel.app/api/categories';

  CategoryRepoApi(this._dio);

  @override
  Future<List<Category>> getCategories() async {
    final response = await _dio.get(_baseUrl);

    // check the status
    if (response.statusCode != 200) {
      throw ("We are not able to read the categories from the server");
    }

    final List<dynamic> jsonList = response.data;
    return jsonList.map((json) => Category.fromJson(json)).toList();
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    try {
      final response = await _dio.get("$_baseUrl/$id");

      // check the status
      if (response.statusCode != 200) {
        throw ("We are not able to read the categories from the server");
      }
      return Category.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCategory(Category category) async {
    _dio.post(_baseUrl, data: category.toJson());
  }

  @override
  Future<void> updateCategory(Category category) async {
    _dio.put("$_baseUrl/${category.id}", data: category.toJson());
  }

  @override
  Future<void> deleteCategory(Category category) async {
    _dio.delete("$_baseUrl/${category.id}");
  }
}
