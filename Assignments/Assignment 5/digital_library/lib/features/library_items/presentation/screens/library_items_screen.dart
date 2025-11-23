import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/library_items_provider.dart';
import '../providers/authors_provider.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/author.dart';

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

  void _showAddBookDialog() {
    final authorsAsync = ref.read(authorsProvider);
    authorsAsync.whenData((authors) {
      showDialog(
        context: context,
        builder: (context) => BookFormDialog(
          authors: authors,
          onSave: (book) async {
            final success = await ref.read(libraryItemsProvider.notifier).addItem(book);
            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'Book added successfully' : 'Failed to add book'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            }
          },
        ),
      );
    });
  }

  void _showEditBookDialog(Book book) {
    final authorsAsync = ref.read(authorsProvider);
    authorsAsync.whenData((authors) {
      showDialog(
        context: context,
        builder: (context) => BookFormDialog(
          book: book,
          authors: authors,
          onSave: (updatedBook) async {
            final success = await ref.read(libraryItemsProvider.notifier).updateItem(updatedBook);
            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'Book updated successfully' : 'Failed to update book'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            }
          },
        ),
      );
    });
  }

  void _showDeleteConfirmation(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Are you sure you want to delete "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final success = await ref.read(libraryItemsProvider.notifier).deleteItem(book.id);
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Book deleted successfully' : 'Failed to delete book'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch the library items provider
    final libraryItemsAsync = ref.watch(libraryItemsProvider);

    // Watch the authors map provider for quick lookup
    final authorsMapAsync = ref.watch(authorsMapProvider);

    return Scaffold(
      body: Column(
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
                        onEdit: () => _showEditBookDialog(book),
                        onDelete: () => _showDeleteConfirmation(book),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        tooltip: 'Add Book',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _LibraryItemCard extends StatelessWidget {
  final Book book;
  final String authorName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LibraryItemCard({
    required this.book,
    required this.authorName,
    required this.onEdit,
    required this.onDelete,
  });

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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                book.isAvailable ? 'Available' : 'Unavailable',
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: book.isAvailable
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: book.isAvailable ? Colors.green[700] : Colors.red[700],
              ),
              visualDensity: VisualDensity.compact,
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => context.push('/library-items/${book.id}'),
      ),
    );
  }
}

/// Dialog for adding/editing a book
class BookFormDialog extends StatefulWidget {
  final Book? book;
  final List<Author> authors;
  final Function(Book) onSave;

  const BookFormDialog({
    super.key,
    this.book,
    required this.authors,
    required this.onSave,
  });

  @override
  State<BookFormDialog> createState() => _BookFormDialogState();
}

class _BookFormDialogState extends State<BookFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _isbnController;
  late final TextEditingController _publisherController;
  late final TextEditingController _publishedYearController;
  late final TextEditingController _categoryController;
  late final TextEditingController _pageCountController;
  late final TextEditingController _descriptionController;
  late String? _selectedAuthorId;
  late bool _isAvailable;
  bool _isLoading = false;

  bool get isEditing => widget.book != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _isbnController = TextEditingController(text: widget.book?.isbn ?? '');
    _publisherController = TextEditingController(text: widget.book?.publisher ?? '');
    _publishedYearController = TextEditingController(
      text: widget.book?.publishedYear.toString() ?? '',
    );
    _categoryController = TextEditingController(text: widget.book?.category ?? '');
    _pageCountController = TextEditingController(
      text: widget.book?.pageCount.toString() ?? '',
    );
    _descriptionController = TextEditingController(text: widget.book?.description ?? '');
    _selectedAuthorId = widget.book?.authorId ?? (widget.authors.isNotEmpty ? widget.authors.first.id : null);
    _isAvailable = widget.book?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _publishedYearController.dispose();
    _categoryController.dispose();
    _pageCountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAuthorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an author')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final book = Book(
      id: widget.book?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      authorId: _selectedAuthorId!,
      publishedYear: int.tryParse(_publishedYearController.text) ?? DateTime.now().year,
      category: _categoryController.text.trim(),
      isAvailable: _isAvailable,
      coverImageUrl: widget.book?.coverImageUrl,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      pageCount: int.tryParse(_pageCountController.text) ?? 0,
      isbn: _isbnController.text.trim(),
      publisher: _publisherController.text.trim(),
    );

    widget.onSave(book);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Book' : 'Add Book'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedAuthorId,
                  decoration: const InputDecoration(
                    labelText: 'Author *',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.authors.map((author) {
                    return DropdownMenuItem(
                      value: author.id,
                      child: Text(author.name),
                    );
                  }).toList(),
                  onChanged: _isLoading ? null : (value) {
                    setState(() => _selectedAuthorId = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an author';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _isbnController,
                  decoration: const InputDecoration(
                    labelText: 'ISBN *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter ISBN';
                    }
                    return null;
                  },
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _publisherController,
                  decoration: const InputDecoration(
                    labelText: 'Publisher *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter publisher';
                    }
                    return null;
                  },
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _publishedYearController,
                        decoration: const InputDecoration(
                          labelText: 'Year *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid';
                          }
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _pageCountController,
                        decoration: const InputDecoration(
                          labelText: 'Pages *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid';
                          }
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter category';
                    }
                    return null;
                  },
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Available'),
                  value: _isAvailable,
                  onChanged: _isLoading ? null : (value) {
                    setState(() => _isAvailable = value);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
