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
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: radius * 0.6,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
