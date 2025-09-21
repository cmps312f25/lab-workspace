import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  Color? bgColor;
  MainAppBar({super.key, required this.title, required this.bgColor});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      centerTitle: true,
      title: Text(title, style: TextStyle(color: Colors.white)),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.settings, color: Colors.white),
        ),
      ],
    );
  }
}
