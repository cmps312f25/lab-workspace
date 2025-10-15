import 'package:flutter/material.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class BookList extends StatelessWidget {
  final List<Book> books;
  const BookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text(books[index].title),
          subtitle: Text(books[index].genre),
          leading: Icon(Icons.book),
          trailing: Text("${books[index].year}"),
        ),
      ),
      itemCount: books.length,
    );
  }
}
