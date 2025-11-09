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

  // In-memory storage for JSON-based implementation
  List<Category> _categories = [];
  int _nextId = 1;

  /// Load categories from JSON file
  Future<void> _loadCategories() async {
    if (_categories.isEmpty) {
      final String jsonString =
          await rootBundle.loadString('assets/data/categories.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _categories = jsonList.map((json) => Category.fromJson(json)).toList();
      _nextId = _categories.isEmpty
          ? 1
          : _categories.map((c) => c.id ?? 0).reduce((a, b) => a > b ? a : b) +
              1;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadCategories();
    return _categories;

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadCategories();
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<void> addCategory(Category category) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadCategories();
    final newCategory = Category(
      id: _nextId++,
      name: category.name,
      description: category.description,
    );
    _categories.add(newCategory);

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<void> updateCategory(Category category) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadCategories();
    if (category.id == null) {
      throw Exception('Category ID is required for update');
    }

    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }

  @override
  Future<void> deleteCategory(Category category) async {
    // ========== CURRENT IMPLEMENTATION: JSON FILE ==========
    await _loadCategories();
    if (category.id == null) {
      throw Exception('Category ID is required for deletion');
    }

    _categories.removeWhere((c) => c.id == category.id);

    // ========== TODO: SWITCH TO API ==========
    // Replace the JSON code above with API implementation
  }
}
