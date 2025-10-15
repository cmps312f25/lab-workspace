import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manage_tut/features/dashboard/domain/entities/book.dart';
import 'package:state_manage_tut/features/dashboard/presentation/providers/book_provider.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

// ref
// read , watch
//read - one time
//watch - listen to changes [never use watch outside build method]
class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final bookList = ref.watch(bookNotifierProvider);
    // List<String> items = ["Skating 1", "Item 2", "Item 3", "Item4"];
    return bookList.when(
      data: (books) => myList(books),
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => CircularProgressIndicator(),
    );
  }

  Widget myList(List<Book> books) {
    return ListView.builder(
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.all(10),
        child: InkWell(
          onTap: () =>
              ref.read(bookNotifierProvider.notifier).addBook(books[index]),
          child: ListTile(
            title: Text("$index: ${books[index].title}"),
            subtitle: Text(books[index].author),
            leading: Icon(Icons.book),
            trailing: Text(books[index].year.toString()),
          ),
        ),
      ),
      itemCount: books.length,
    );
  }
}
