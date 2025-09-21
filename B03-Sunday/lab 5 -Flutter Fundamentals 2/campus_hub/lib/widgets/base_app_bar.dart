import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  Icon? icon;
  Color? bgColor;
  BaseAppBar({super.key, required this.title, this.icon, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: bgColor,
      title: Text(title, style: TextStyle(color: Colors.white)),
      actions: [Padding(padding: const EdgeInsets.all(10.0), child: icon!)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
