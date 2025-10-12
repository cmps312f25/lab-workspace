import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/book_provider.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/selected_book_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(bookProvider);
    final selectedBook = ref.watch(selectedBookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: selectedBook != null
            ? [
                Chip(
                  label: Text(selectedBook.title),
                  onDeleted: ref.read(selectedBookProvider.notifier).clear,
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final isSelected = selectedBook?.id == book.id;

          return Card(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : null,
            child: ListTile(
              title: Text(book.title),
              subtitle: Text('Author: ${book.author}'),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () => ref.read(selectedBookProvider.notifier).select(book),
            ),
          );
        },
      ),
    );
  }
}
