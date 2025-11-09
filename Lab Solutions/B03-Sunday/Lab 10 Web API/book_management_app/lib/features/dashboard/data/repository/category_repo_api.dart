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
    // check if we have good response
    if (response.statusCode != 200) {
      throw ("Error happened");
    }

    final List<dynamic> categoriesMap = response.data;

    final categories = categoriesMap
        .map((json) => Category.fromJson(json))
        .toList();

    return categories;
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    final response = await _dio.get('$_baseUrl/$id');

    if (response.statusCode != 200) {
      throw ("Error happened");
    }

    return Category.fromJson(response.data);
  }

  @override
  Future<void> addCategory(Category category) async {
    _dio.post(_baseUrl, data: category.toJson());
  }

  @override
  Future<void> updateCategory(Category category) async {
    _dio.put('$_baseUrl/${category.id}', data: category.toJson());
  }

  @override
  Future<void> deleteCategory(Category category) async {
    _dio.delete('$_baseUrl/${category.id}');
  }
}
