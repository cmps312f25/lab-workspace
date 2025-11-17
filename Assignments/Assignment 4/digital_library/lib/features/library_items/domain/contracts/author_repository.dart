import '../entities/author.dart';

abstract class AuthorRepository {
  // ==================== Future-based methods (for JSON repos) ====================

  /// Get all authors (one-time fetch)
  Future<List<Author>> getAllAuthors();

  /// Get a specific author by ID (one-time fetch)
  Future<Author> getAuthor(String id);

  /// Search authors by name (one-time fetch)
  Future<List<Author>> searchAuthors(String query);

  // ==================== Stream-based methods (for DB repos) ====================

  /// Watch all authors (reactive - auto-updates UI)
  Stream<List<Author>> watchAllAuthors();

  /// Watch a specific author by ID (reactive - auto-updates UI)
  Stream<Author?> watchAuthor(String id);

  /// Watch authors filtered by search query (reactive - auto-updates UI)
  Stream<List<Author>> watchSearchResults(String query);

  // ==================== CRUD operations ====================

  /// Add a new author
  Future<void> addAuthor(Author author);

  /// Update an existing author
  Future<void> updateAuthor(Author author);

  /// Delete an author
  Future<void> deleteAuthor(String id);
}
