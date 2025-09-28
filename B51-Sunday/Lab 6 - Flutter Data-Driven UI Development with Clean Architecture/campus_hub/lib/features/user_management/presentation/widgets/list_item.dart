import 'package:flutter/material.dart';

/// A reusable widget for displaying list items with consistent styling
///
/// This widget can be used for courses, bookings, sessions, permissions, etc.
/// Should provide consistent padding, colors, and layout.
class ListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final Widget? trailing;

  const ListItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the list item widget here
    // Requirements:
    // - Create a container with padding (12px all around) and margin bottom (8px)
    // - Add background color using backgroundColor or light shade of iconColor (e.g., iconColor.shade50)
    // - Add border with rounded corners (8px radius)
    // - Create a row with icon, content, and optional trailing widget
    // - Display title in bold text using iconColor
    // - Display subtitle below title in smaller, grey text (if provided)
    // - Use Expanded for the content column to take available space
    // - Display trailing widget on the right if provided

    return Placeholder(fallbackHeight: 60, fallbackWidth: 300);
  }
}
