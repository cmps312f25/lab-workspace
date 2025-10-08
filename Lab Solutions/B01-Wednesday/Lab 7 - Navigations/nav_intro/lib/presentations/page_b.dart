import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageB extends StatelessWidget {
  final String name;
  final String age;
  const PageB({super.key, required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      child: InkWell(
        onTap: () => context.push("/"),
        child: Center(
          child: Text("""Page B -> Click Me to Navigate to A 
            \n Your Name is $name and Your age is $age"""),
        ),
      ),
    );
  }
}
