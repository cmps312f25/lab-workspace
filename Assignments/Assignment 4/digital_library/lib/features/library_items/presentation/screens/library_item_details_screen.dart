import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_items_provider.dart';
import '../providers/authors_provider.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/author.dart';
import '../../../borrowing/presentation/providers/transactions_provider.dart';
import '../../../members/presentation/providers/members_provider.dart';

// Provider for fetching a specific book by ID
final libraryItemProvider = FutureProvider.autoDispose.family<Book?, String>((ref, itemId) async {
  final notifier = ref.read(libraryItemsProvider.notifier);
  return await notifier.getItem(itemId);
});

class LibraryItemDetailsScreen extends ConsumerWidget {
  final String itemId;

  const LibraryItemDetailsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch the book provider
    final bookAsync = ref.watch(libraryItemProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: bookAsync.when(
        data: (book) {
          if (book == null) {
            return const Center(child: Text('Book not found'));
          }

          // Fetch author separately
          final authorAsync = ref.watch(authorByIdProvider(book.authorId));

          return authorAsync.when(
            data: (author) => _buildItemDetails(context, ref, theme, book, author),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error loading author: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildItemDetails(BuildContext context, WidgetRef ref, ThemeData theme, Book book, Author? author) {
    final authorName = author?.name ?? 'Unknown Author';

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: book.isAvailable
                        ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
                        : [const Color(0xFFFF5722), const Color(0xFFE64A19)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu_book,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    book.getItemType(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    book.isAvailable ? 'Available' : 'Unavailable',
                                    style: TextStyle(
                                      color: book.isAvailable
                                          ? const Color(0xFF388E3C)
                                          : const Color(0xFFE64A19),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        authorName,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section Title
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            // Info grouped in one card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(
                        context, 'Category', book.category, Icons.category),
                    const Divider(height: 24),
                    _buildInfoRow(context, 'Published Year',
                        book.publishedYear.toString(), Icons.calendar_today),
                    const Divider(height: 24),
                    _buildInfoRow(
                        context, 'ISBN', book.isbn, Icons.qr_code),
                    const Divider(height: 24),
                    _buildInfoRow(context, 'Pages',
                        book.pageCount.toString(), Icons.book),
                    const Divider(height: 24),
                    _buildInfoRow(context, 'Publisher', book.publisher,
                        Icons.business),
                  ],
                ),
              ),
            ),

            // Description
            if (book.description != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  'Description',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    book.description!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ],

            // Borrow Button
            const SizedBox(height: 24),
            if (book.isAvailable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showBorrowDialog(context, ref, book),
                  icon: const Icon(Icons.library_add),
                  label: const Text('Borrow Book'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'This book is currently unavailable',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Check the Transactions tab for return date',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBorrowDialog(BuildContext context, WidgetRef ref, Book book) {
    final membersAsync = ref.watch(membersProvider);

    showDialog(
      context: context,
      builder: (dialogContext) {
        String? selectedMemberId;

        return AlertDialog(
          title: const Text('Borrow Book'),
          content: membersAsync.when(
            data: (state) {
              final members = state.members;

              if (members.isEmpty) {
                return const Text('No members available');
              }

              return StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select member to borrow "${book.title}":'),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedMemberId,
                        decoration: const InputDecoration(
                          labelText: 'Member',
                          border: OutlineInputBorder(),
                        ),
                        items: members.map((member) {
                          return DropdownMenuItem(
                            value: member.id,
                            child: Text('${member.name} (${member.memberType})'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMemberId = value;
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Text('Error loading members: $error'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate that a member is selected
                if (selectedMemberId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a member'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Close dialog
                Navigator.of(dialogContext).pop();

                // Perform borrow operation
                try {
                  await ref.read(transactionsProvider.notifier).borrowBook(selectedMemberId!, book.id);

                  // Refresh data immediately
                  await ref.read(libraryItemsProvider.notifier).refresh();
                  await ref.read(transactionsProvider.notifier).refresh();
                  ref.invalidate(libraryItemProvider(book.id));

                  if (context.mounted) {
                    // Navigate back to library items page
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Book borrowed successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Borrow'),
            ),
          ],
        );
      },
    );
  }
}
