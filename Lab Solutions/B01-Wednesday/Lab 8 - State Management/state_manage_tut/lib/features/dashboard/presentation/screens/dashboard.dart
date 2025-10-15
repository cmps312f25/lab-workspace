import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_manage_tut/core/navigation/app_router.dart';
import 'package:state_manage_tut/features/dashboard/domain/entities/book.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    List<String> items = ["Skating 1", "Item 2", "Item 3", "Item4"];
    return myList(items);
  }

  Widget myList(List<Book> books) {
    return ListView.builder(
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text("$index: ${books[index].title}"),
          subtitle: Text(books[index].author),
          leading: Icon(Icons.book),
          trailing: Text(books[index].year.toString()),
        ),
      ),
      itemCount: books.length,
    );
  }
}
