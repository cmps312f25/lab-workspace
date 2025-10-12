import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_managment_tutorial/features/home/presentation/providers/book_notifier.dart';

class BooksListScreen extends ConsumerStatefulWidget {
  const BooksListScreen({super.key});

  @override
  ConsumerState<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends ConsumerState<BooksListScreen> {
  @override
  Widget build(BuildContext context) {
    final books = ref.watch(bookNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text("My Books")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      ref.read(bookNotifierProvider.notifier).addBook(book);
                      //     title: "New Book",
                    },
                    child: ListTile(
                      title: Text(book.title),
                      leading: Icon(Icons.book),
                    ),
                  ),
                );
              },
              itemCount: books.length,
            ),
          ),
        ],
      ),
    );
  }
}
