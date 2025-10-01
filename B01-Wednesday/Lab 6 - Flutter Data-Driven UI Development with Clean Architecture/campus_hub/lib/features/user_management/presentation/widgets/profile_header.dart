import 'package:flutter/material.dart';

/// A reusable profile header widget with avatar and user information
///
/// This widget should provide a consistent header design for all profile pages
/// with gradient background, avatar, and user details.
class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? subtitle;
  final String? avatarUrl;
  final Color themeColor;
  final Color? textColor;
  final Widget? additionalInfo;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.subtitle,
    this.avatarUrl,
    required this.themeColor,
    this.additionalInfo,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the profile header widget here
    // Requirements:
    // - Create a Card widget with elevation 4 and rounded corners (12px radius)
    // - Add gradient background using themeColor with different opacities
    // - Create a row with ProfileAvatar on the left and user info on the right
    // - Display name in large, bold text using themeColor
    // - Display email below name in smaller, grey text
    // - Display subtitle below email if provided (using themeColor)
    // - Display additionalInfo widget if provided
    // - Add proper spacing between elements
    // - Use Expanded for the text column to take available space

    return Card(
      color: themeColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                avatarUrl ??
                    'https://www.gravatar.com/avatar/placeholder?d=mp&s=200',
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                if (additionalInfo != null) additionalInfo!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
