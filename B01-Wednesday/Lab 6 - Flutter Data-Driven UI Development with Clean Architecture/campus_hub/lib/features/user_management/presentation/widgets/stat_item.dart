import 'package:flutter/material.dart';

/// A reusable widget for displaying statistics in a card format
///
/// This widget should be perfect for showing metrics like ratings, counts, percentages
/// with consistent styling across the app.
class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the stat item widget here
    // Requirements:
    // - Create a container with padding (16px all around)
    // - Add background color using light shade of the provided color (e.g., color.shade50)
    // - Add border with rounded corners (8px radius)
    // - Display icon at the top with the provided color and size 24
    // - Display value in large, bold text using the provided color
    // - Display label below in smaller, grey text
    // - Center everything vertically in a column

    return Placeholder(fallbackHeight: 120, fallbackWidth: 100);
  }
}
