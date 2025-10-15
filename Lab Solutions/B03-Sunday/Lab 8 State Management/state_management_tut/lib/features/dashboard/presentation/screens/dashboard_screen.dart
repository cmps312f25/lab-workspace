import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/book_provider.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/selected_book_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final DashBoardData state = ref.watch(bookNotifierProvider);
    final List<Book> books = state.books;

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) => Card(
            child: InkWell(
              onTap: () =>
                  ref.read(bookNotifierProvider.notifier).addBook(books[index]),
              child: ListTile(title: Text(books[index].title)),
            ),
          ),
          itemCount: books.length,
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
