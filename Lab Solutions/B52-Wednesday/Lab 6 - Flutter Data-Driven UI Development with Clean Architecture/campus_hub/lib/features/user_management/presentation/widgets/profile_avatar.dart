import 'package:flutter/material.dart';

/// A reusable avatar widget for user profiles
///
/// This widget should display either a network image or a fallback letter avatar
/// with role-specific background colors.
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final Color backgroundColor;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    required this.backgroundColor,
    this.radius = 35,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the avatar widget here
    // Requirements:
    // - Display network image if imageUrl is provided
    // - Fallback to letter avatar (first letter of name) if imageUrl is null
    // - Use backgroundColor for the avatar background
    // - Handle empty names gracefully
    // - Use radius for sizing

    return Placeholder(fallbackHeight: radius * 2, fallbackWidth: radius * 2);
  }
}
