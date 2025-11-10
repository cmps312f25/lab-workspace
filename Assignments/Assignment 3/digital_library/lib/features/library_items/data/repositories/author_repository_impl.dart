import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/contracts/author_repository.dart';
import '../../domain/entities/author.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  List<Author>? _authors;

  /// Load authors from JSON file
  Future<List<Author>> _loadAuthors() async {
    if (_authors != null) return _authors!;

    try {
      final String authorsJson =
          await rootBundle.loadString('assets/data/authors_json.json');
      final List<dynamic> authorsData = json.decode(authorsJson);
      _authors = authorsData.map((json) => Author.fromJson(json)).toList();
      return _authors!;
    } catch (e) {
      throw Exception('Failed to load authors: $e');
    }
  }

  @override
  Future<List<Author>> getAllAuthors() async {
    return await _loadAuthors();
  }

  @override
  Future<Author> getAuthor(String id) async {
    final authors = await _loadAuthors();
    try {
      return authors.firstWhere((author) => author.id == id);
    } catch (e) {
      throw Exception('Author with ID $id not found');
    }
  }

  @override
  Future<List<Author>> searchAuthors(String query) async {
    final authors = await _loadAuthors();
    final lowerQuery = query.toLowerCase();

    return authors.where((author) {
      if (author.name.toLowerCase().contains(lowerQuery)) return true;
      if (author.biography != null &&
          author.biography!.toLowerCase().contains(lowerQuery)) {
        return true;
      }
      return false;
    }).toList();
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

  // ==================== CRUD operations ====================

  @override
  Future<void> addAuthor(Author author) async {
    final authors = await _loadAuthors();
    if (authors.any((a) => a.id == author.id)) {
      throw Exception('Author with ID ${author.id} already exists');
    }
    _authors!.add(author);
  }

  @override
  Future<void> updateAuthor(Author author) async {
    final authors = await _loadAuthors();
    final index = authors.indexWhere((a) => a.id == author.id);
    if (index == -1) {
      throw Exception('Author with ID ${author.id} not found');
    }
    _authors![index] = author;
  }

  @override
  Future<void> deleteAuthor(String id) async {
    final authors = await _loadAuthors();
    final index = authors.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Author with ID $id not found');
    }
    _authors!.removeAt(index);
  }

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    _authors = null;
  }
}
