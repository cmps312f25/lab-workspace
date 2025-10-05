import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nav_basics/data/datasource/local_datasource.dart';

class PageB extends StatelessWidget {
  final int id;
  final String name;
  const PageB({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    String user = LocalDatasource().getStudentById(id);

    return Container(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          // here we will navigate to page B
          // context.go("/");
          context.pop();
        },
        child: Center(
          child: Text(
            "I am Page B and you sent me id: $id and name: $user",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
