import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:state_management_tut/features/dashboard/presentation/wigets/book_list.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // watch can only be called inside the build
    final booksList = ref.watch(bookProvider);

    return booksList.when(
      data: (books) => ListView.builder(
        itemBuilder: (context, index) => InkWell(
          onTap: () => ref.read(bookProvider.notifier).addBook(books[index]),
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(books[index].title),
              subtitle: Text(books[index].genre),
              leading: Icon(Icons.book),
              trailing: Text("${books[index].year}"),
            ),
          ),
        ),
        itemCount: books.length,
      ),
      error: (err, stackTrace) => Text("Error happened $err"),
      loading: () => CircularProgressIndicator(),
    );
  }
}
