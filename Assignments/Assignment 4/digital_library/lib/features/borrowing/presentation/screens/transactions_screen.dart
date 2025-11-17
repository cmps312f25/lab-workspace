import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../library_items/presentation/providers/library_items_provider.dart';
import '../../../members/presentation/providers/members_provider.dart';
import '../providers/transactions_provider.dart';
import '../../domain/entities/transaction.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  TransactionFilter _currentFilter = TransactionFilter.all;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', TransactionFilter.all, theme),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active', TransactionFilter.active, theme),
                  const SizedBox(width: 8),
                  _buildFilterChip('Overdue', TransactionFilter.overdue, theme),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed', TransactionFilter.completed, theme),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Transactions list
          Expanded(
            child: transactionsAsync.when(
              data: (state) {
                final transactions = state.filteredTransactions;

                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(transactionsProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionCard(transaction, theme);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, TransactionFilter filter, ThemeData theme) {
    final isSelected = _currentFilter == filter;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentFilter = filter;
          });
          ref.read(transactionsProvider.notifier).setFilter(filter);
        }
      },
      selectedColor: theme.colorScheme.primary.withValues(alpha:0.2),
      checkmarkColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.primary : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction, ThemeData theme) {
    final booksAsync = ref.watch(libraryItemsProvider);
    final membersAsync = ref.watch(membersProvider);

    // Get book and member info - handle cases where they might not be found
    final book = booksAsync.value?.items.cast<dynamic>().firstWhere(
      (b) => b.id == transaction.bookId,
      orElse: () => null,
    );

    final member = membersAsync.value?.members.cast<dynamic>().firstWhere(
      (m) => m.id == transaction.memberId,
      orElse: () => null,
    );

    final isOverdue = transaction.isOverdue();
    final statusColor = transaction.isReturned
        ? Colors.green
        : isOverdue
            ? Colors.red
            : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOverdue && !transaction.isReturned
            ? BorderSide(color: Colors.red[300]!, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showTransactionDetails(transaction, book?.title, member?.name),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      transaction.isReturned
                          ? 'Returned'
                          : isOverdue
                              ? 'Overdue'
                              : 'Active',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    transaction.id,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Book title
              Row(
                children: [
                  Icon(Icons.book, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      book?.title ?? 'Unknown Book',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Member name
              Row(
                children: [
                  Icon(Icons.person, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      member?.name ?? 'Unknown Member',
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Dates
              Row(
                children: [
                  Expanded(
                    child: _buildDateInfo(
                      'Borrowed',
                      transaction.borrowDate,
                      Icons.calendar_today,
                      theme,
                    ),
                  ),
                  Expanded(
                    child: _buildDateInfo(
                      'Due',
                      transaction.dueDate,
                      Icons.event,
                      theme,
                    ),
                  ),
                ],
              ),

              // Return date or overdue info
              if (transaction.isReturned && transaction.returnDate != null) ...[
                const SizedBox(height: 8),
                _buildDateInfo(
                  'Returned',
                  transaction.returnDate!,
                  Icons.check_circle,
                  theme,
                ),
              ] else if (isOverdue) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${transaction.getDaysOverdue()} days overdue (QR ${transaction.calculateLateFee().toStringAsFixed(2)} fee)',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Return button for active transactions
              if (!transaction.isReturned) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showReturnDialog(transaction, book?.title),
                    icon: const Icon(Icons.keyboard_return),
                    label: const Text('Return Book'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date, IconData icon, ThemeData theme) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              dateFormat.format(date),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showTransactionDetails(Transaction transaction, String? bookTitle, String? memberName) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction ${transaction.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Book', bookTitle ?? 'Unknown'),
            const SizedBox(height: 8),
            _buildDetailRow('Member', memberName ?? 'Unknown'),
            const SizedBox(height: 8),
            _buildDetailRow('Borrow Date', dateFormat.format(transaction.borrowDate)),
            const SizedBox(height: 8),
            _buildDetailRow('Due Date', dateFormat.format(transaction.dueDate)),
            if (transaction.returnDate != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow('Return Date', dateFormat.format(transaction.returnDate!)),
            ],
            if (transaction.isOverdue() && !transaction.isReturned) ...[
              const SizedBox(height: 8),
              _buildDetailRow('Days Overdue', '${transaction.getDaysOverdue()} days'),
              const SizedBox(height: 8),
              _buildDetailRow('Late Fee', 'QR ${transaction.calculateLateFee().toStringAsFixed(2)}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  void _showReturnDialog(Transaction transaction, String? bookTitle) {
    final lateFee = transaction.calculateLateFee();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Return Book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to return this book?'),
            const SizedBox(height: 16),
            Text(
              bookTitle ?? 'Unknown Book',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (lateFee > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Late Fee',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'QR ${lateFee.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                    Text(
                      '(${transaction.getDaysOverdue()} days overdue)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(transactionsProvider.notifier).returnBook(transaction.id);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        lateFee > 0
                            ? 'Book returned. Late fee: QR ${lateFee.toStringAsFixed(2)}'
                            : 'Book returned successfully',
                      ),
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
            child: const Text('Confirm Return'),
          ),
        ],
      ),
    );
  }
}
