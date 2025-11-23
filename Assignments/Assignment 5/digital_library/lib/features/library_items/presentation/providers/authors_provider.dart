import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repo_providers.dart';
import '../../domain/entities/author.dart';

// Provider to get all authors
final authorsProvider = FutureProvider<List<Author>>((ref) async {
  final repository = await ref.watch(authorRepositoryProvider.future);
  return await repository.getAllAuthors();
});

// Provider to get a map of authorId -> Author for quick lookup
final authorsMapProvider = FutureProvider<Map<String, Author>>((ref) async {
  final authors = await ref.watch(authorsProvider.future);
  return {for (var author in authors) author.id: author};
});

// Provider to get a specific author by ID
final authorByIdProvider =
    FutureProvider.autoDispose.family<Author?, String>((ref, authorId) async {
  final repository = await ref.read(authorRepositoryProvider.future);
  try {
    return await repository.getAuthor(authorId);
  } catch (e) {
    return null;
  }
});
