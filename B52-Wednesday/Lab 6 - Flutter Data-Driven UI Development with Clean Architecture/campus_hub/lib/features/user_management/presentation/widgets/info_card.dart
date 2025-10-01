import 'package:flutter/material.dart';

/// A reusable card widget for displaying information sections
///
/// This widget should provide a consistent card design with optional header icon,
/// title, and content. Perfect for profile sections, statistics, etc.
class InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;
  final Color? iconColor;
  final Color? titleColor;
  final EdgeInsets? padding;

  const InfoCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.iconColor,
    this.titleColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the info card widget here
    // Requirements:
    // - Create a Card widget with elevation 3 and rounded corners (12px radius)
    // - Add a header row with optional icon and title
    // - Icon should be in a container with background color and rounded corners
    // - Title should be bold and appropriately sized
    // - Add spacing between header and content
    // - Display the child widget as content
    // - Use padding parameter or default to 20px all around

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  color: iconColor ?? Colors.blue.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(icon),
                  ),
                ),
                SizedBox(width: 20),
                Text(title),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }
}
