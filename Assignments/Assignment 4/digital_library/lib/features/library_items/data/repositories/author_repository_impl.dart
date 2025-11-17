import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../../domain/contracts/author_repository.dart';
import '../../domain/entities/author.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final Dio _dio;

  // In-memory storage - loaded once from JSON and then modified in memory
  List<Author>? _cachedAuthors;

  AuthorRepositoryImpl(this._dio);

  // Helper method to load authors from JSON
  Future<List<Author>> _loadAuthorsFromJson() async {
    // Return cached data if already loaded
    if (_cachedAuthors != null) {
      return _cachedAuthors!;
    }

    final String jsonString = await rootBundle.loadString('assets/data/authors_json.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _cachedAuthors = jsonList.map((json) => Author.fromJson(json)).toList();
    return _cachedAuthors!;
  }

  @override
  Future<List<Author>> getAllAuthors() async {
    try {
      return await _loadAuthorsFromJson();
    } catch (e) {
      throw Exception('Failed to fetch authors: $e');
    }
  }

  @override
  Future<Author> getAuthor(String id) async {
    try {
      final authors = await _loadAuthorsFromJson();
      return authors.firstWhere(
        (author) => author.id == id,
        orElse: () => throw Exception('Author with ID $id not found'),
      );
    } catch (e) {
      throw Exception('Failed to fetch author: $e');
    }
  }

  @override
  Future<List<Author>> searchAuthors(String query) async {
    try {
      final authors = await _loadAuthorsFromJson();
      final lowerQuery = query.toLowerCase();

      return authors.where((author) {
        if (author.name.toLowerCase().contains(lowerQuery)) return true;
        if (author.biography != null &&
            author.biography!.toLowerCase().contains(lowerQuery)) {
          return true;
        }
        return false;
      }).toList();
    } catch (e) {
      throw Exception('Failed to search authors: $e');
    }
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Author>> watchAllAuthors() async* {
    yield await getAllAuthors();
  }

  @override
  Stream<Author?> watchAuthor(String id) async* {
    try {
      yield await getAuthor(id);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Author>> watchSearchResults(String query) async* {
    yield await searchAuthors(query);
  }

  // ==================== CRUD operations (In-Memory) ====================

  @override
  Future<void> addAuthor(Author author) async {
    try {
      final authors = await _loadAuthorsFromJson();
      authors.add(author);
      _cachedAuthors = authors;
    } catch (e) {
      throw Exception('Failed to add author: $e');
    }
  }

  @override
  Future<void> updateAuthor(Author author) async {
    try {
      final authors = await _loadAuthorsFromJson();
      final index = authors.indexWhere((a) => a.id == author.id);

      if (index == -1) {
        throw Exception('Author with ID ${author.id} not found');
      }

      authors[index] = author;
      _cachedAuthors = authors;
    } catch (e) {
      throw Exception('Failed to update author: $e');
    }
  }

  @override
  Future<void> deleteAuthor(String id) async {
    try {
      final authors = await _loadAuthorsFromJson();
      final initialLength = authors.length;
      authors.removeWhere((a) => a.id == id);

      if (authors.length == initialLength) {
        throw Exception('Author with ID $id not found');
      }

      _cachedAuthors = authors;
    } catch (e) {
      throw Exception('Failed to delete author: $e');
    }
  }
}
