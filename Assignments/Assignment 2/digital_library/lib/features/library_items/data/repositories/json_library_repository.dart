import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/contracts/library_repository.dart';
import '../../domain/entities/audiobook.dart';
import '../../domain/entities/author.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/library_item.dart';

class JsonLibraryRepository implements LibraryRepository {
  List<Author>? _authors;
  List<LibraryItem>? items;

  /// Load authors from JSON file
  Future<List<Author>> _loadAuthors() async {
    if (_authors != null) return _authors!;

    try {
      final String authorsJson =
          await rootBundle.loadString('assets/data/authors_json.json');
      final List<dynamic> authorsData = json.decode(authorsJson);
      _authors =
          authorsData.map((json) => Author.fromJson(json)).toList();
      return _authors!;
    } catch (e) {
      throw Exception('Failed to load authors: $e');
    }
  }

  /// Load library items from JSON file
  Future<List<LibraryItem>> _loadItems() async {
    if (items != null) return items!;

    try {
      // Load authors first
      final authors = await _loadAuthors();

      // Load library catalog
      final String catalogJson =
          await rootBundle.loadString('assets/data/library_catalog_json.json');
      final List<dynamic> catalogData = json.decode(catalogJson);

      // Create appropriate LibraryItem subclasses
      items = catalogData.map((itemJson) {
        final type = itemJson['type'] as String;
        if (type == 'Book') {
          return Book.fromJson(itemJson, authors);
        } else if (type == 'AudioBook') {
          return AudioBook.fromJson(itemJson, authors);
        } else {
          throw Exception('Unknown library item type: $type');
        }
      }).toList();

      return items!;
    } catch (e) {
      throw Exception('Failed to load library items: $e');
    }
  }

  @override
  Future<List<LibraryItem>> getAllItems() async {
    return await _loadItems();
  }

  @override
  Future<LibraryItem> getItem(String id) async {
    final items = await _loadItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      throw Exception('Library item with ID $id not found');
    }
  }

  @override
  Future<List<LibraryItem>> searchItems(String query) async {
    final items = await _loadItems();
    final lowerQuery = query.toLowerCase();

    return items.where((item) {
      // Search in title
      if (item.title.toLowerCase().contains(lowerQuery)) return true;

      // Search in authors
      if (item.authors
          .any((author) => author.name.toLowerCase().contains(lowerQuery))) {
        return true;
      }

      // Search in description
      if (item.description != null &&
          item.description!.toLowerCase().contains(lowerQuery)) {
        return true;
      }

      return false;
    }).toList();
  }

  @override
  Future<List<LibraryItem>> getItemsByCategory(String category) async {
    final items = await _loadItems();
    final lowerCategory = category.toLowerCase();
    return items
        .where((item) => item.category.toLowerCase() == lowerCategory)
        .toList();
  }

  @override
  Future<List<LibraryItem>> getAvailableItems() async {
    final items = await _loadItems();
    return items.where((item) => item.isAvailable).toList();
  }

  @override
  Future<List<LibraryItem>> getItemsByAuthor(String authorId) async {
    final items = await _loadItems();
    return items
        .where((item) => item.authors.any((author) => author.id == authorId))
        .toList();
  }

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    _authors = null;
    items = null;
  }
}
