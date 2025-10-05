import 'package:flutter/material.dart';
import 'profile_avatar.dart';

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
  final Widget? additionalInfo;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.subtitle,
    this.avatarUrl,
    required this.themeColor,
    this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [themeColor.withOpacity(0.1), themeColor.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ProfileAvatar(
              imageUrl: avatarUrl,
              name: name,
              backgroundColor: themeColor,
              radius: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (additionalInfo != null) ...[
                    const SizedBox(height: 8),
                    additionalInfo!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
