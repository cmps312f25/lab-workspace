import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/library_items_provider.dart';
import '../providers/authors_provider.dart';
import '../../domain/entities/book.dart';

class LibraryItemsScreen extends ConsumerStatefulWidget {
  const LibraryItemsScreen({super.key});

  @override
  ConsumerState<LibraryItemsScreen> createState() => _LibraryItemsScreenState();
}

class _LibraryItemsScreenState extends ConsumerState<LibraryItemsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    // Use the notifier to search
    ref.read(libraryItemsProvider.notifier).searchItems(query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch the library items provider
    final libraryItemsAsync = ref.watch(libraryItemsProvider);

    // Watch the authors map provider for quick lookup
    final authorsMapAsync = ref.watch(authorsMapProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by title...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _handleSearch('');
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: libraryItemsAsync.when(
            data: (state) {
              final books = state.items;
              if (books.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_books_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No books found',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Wait for authors map to load
              return authorsMapAsync.when(
                data: (authorsMap) => ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final author = authorsMap[book.authorId];
                    return _LibraryItemCard(
                      book: book,
                      authorName: author?.name ?? 'Unknown Author',
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading authors: $error'),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      ],
    );
  }
}

class _LibraryItemCard extends StatelessWidget {
  final Book book;
  final String authorName;

  const _LibraryItemCard({required this.book, required this.authorName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: book.isAvailable ? Colors.teal : Colors.red,
          child: const Icon(
            Icons.menu_book,
            color: Colors.white,
          ),
        ),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(authorName),
            const SizedBox(height: 2),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      book.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  book.getItemType(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            book.isAvailable ? 'Available' : 'Unavailable',
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: book.isAvailable
              ? Colors.green.withValues(alpha:0.2)
              : Colors.red.withValues(alpha:0.2),
          labelStyle: TextStyle(
            color: book.isAvailable ? Colors.green[700] : Colors.red[700],
          ),
        ),
        onTap: () => context.push('/library-items/${book.id}'),
      ),
    );
  }
}
