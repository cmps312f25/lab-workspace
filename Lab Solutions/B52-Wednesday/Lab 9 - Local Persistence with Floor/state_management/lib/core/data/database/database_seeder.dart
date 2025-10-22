import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../features/dashboard/domain/entities/book.dart';
import '../../../features/dashboard/domain/entities/category.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase(AppDatabase database) async {
    try {
      // ✅ Check if database is already seeded
      final categoryCount = await database.categoryDao.getAllCategories();

      if (categoryCount.isNotEmpty) {
        return; // Already seeded, skip
      }

      // ✅ Seed Categories
      await _seedCategories(database);

      // ✅ Seed Books
      await _seedBooks(database);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _seedCategories(AppDatabase database) async {
    // ✅ Load JSON file
    final jsonString = await rootBundle.loadString(
      'assets/data/categories.json',
    );

    // ✅ Parse JSON
    final List<dynamic> jsonData = json.decode(jsonString);

    // ✅ Convert to Category objects
    final categories = jsonData.map((json) => Category.fromJson(json)).toList();

    // ✅ Insert into database
    await database.categoryDao.insertCategories(categories);
  }

  static Future<void> _seedBooks(AppDatabase database) async {
    // ✅ Load JSON file
    final jsonString = await rootBundle.loadString('assets/data/books.json');

    // ✅ Parse JSON
    final List<dynamic> jsonData = json.decode(jsonString);

    // ✅ Convert to Book objects
    final books = jsonData.map((json) => Book.fromJson(json)).toList();

    // ✅ Insert into database
    await database.bookDao.insertBooks(books);
  }

  // Utility method to clear database (useful for testing)
  static Future<void> clearDatabase(AppDatabase database) async {
    await database.bookDao.deleteAllBooks();
    await database.categoryDao.deleteAllCategories();
  }
}
