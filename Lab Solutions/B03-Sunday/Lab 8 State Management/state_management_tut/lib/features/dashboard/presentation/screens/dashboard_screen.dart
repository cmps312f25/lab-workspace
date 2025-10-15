import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/book_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(bookNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: booksAsync.when(
          data: (books) => booksListView(books),
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => CircularProgressIndicator(),
        ),
      ),
    );
  }
}

Widget booksListView(List<Book> books) {
  return ListView.builder(
    itemCount: books.length,
    itemBuilder: (context, index) {
      final book = books[index];
      return ListTile(
        title: Text(book.title),
        subtitle: Text('${book.author} (${book.year})'),
      );
    },
  );
}
