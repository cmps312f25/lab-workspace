# User Management Design Guide

## Overview
This document provides design guidelines specifically for the user management features in the Campus Hub Flutter app, including colors, icons, and UI patterns for login and profile pages.

## Color Palette

### Primary Colors for User Roles
- **Student Blue**: `Colors.blue` (#2196F3)
- **Tutor Green**: `Colors.green` (#4CAF50) 
- **Admin Orange**: `Colors.orange` (#FF9800)

### Color Variations by Role

#### Student (Blue Theme)
- `Colors.blue[50]` - Very light blue for backgrounds
- `Colors.blue[100]` - Light blue for card backgrounds
- `Colors.blue[600]` - Medium blue for icons
- `Colors.blue[700]` - Dark blue for text
- `Colors.blue[800]` - Very dark blue for headers

#### Tutor (Green Theme)
- `Colors.green[50]` - Very light green for backgrounds
- `Colors.green[100]` - Light green for card backgrounds
- `Colors.green[600]` - Medium green for icons
- `Colors.green[700]` - Dark green for text
- `Colors.green[800]` - Very dark green for headers

#### Admin (Orange Theme)
- `Colors.orange[50]` - Very light orange for backgrounds
- `Colors.orange[100]` - Light orange for card backgrounds
- `Colors.orange[600]` - Medium orange for icons
- `Colors.orange[700]` - Dark orange for text
- `Colors.orange[800]` - Very dark orange for headers

### Supporting Colors
- `Colors.grey[600]` - Medium grey for secondary text
- `Colors.grey[700]` - Dark grey for primary text
- `Colors.red[600]` - Red for struggling courses/errors
- `Colors.amber[600]` - Amber for recommendations/ratings
- `Colors.purple[600]` - Purple for bookings/sessions

## Icon System

### Authentication Icons
- `Icons.email` - Email input field
- `Icons.lock` - Password input field
- `Icons.school` - Main app icon

### Profile Icons
- `Icons.person` - User avatar/profile
- `Icons.book` - Courses and academic content
- `Icons.lightbulb` - Course recommendations
- `Icons.event` - Sessions and bookings
- `Icons.history` - Booking history
- `Icons.analytics` - Statistics and analytics
- `Icons.star` - Ratings and reviews
- `Icons.trending_up` - Success rate
- `Icons.security` - Admin permissions
- `Icons.settings` - Admin actions

### Icon Sizes
- **Large Icons**: 24px (section headers)
- **Small Icons**: 20px (list items)
- **Micro Icons**: 16px (navigation arrows)

## UI Patterns

### Card Design
- **Elevation**: 3-4 for main cards
- **Border Radius**: 12px for all cards
- **Padding**: 20px for card content

### Avatar Design
- **Shape**: Circle
- **Size**: 70px diameter (radius: 35)
- **Background**: Role-specific colors (blue, green, orange)
- **Fallback**: First letter of name with white text

### Button Design
- **Style**: Elevated buttons
- **Active State**: Primary color (blue)
- **Inactive State**: `Colors.grey`
- **Padding**: 16px horizontal

### Text Styles
- **Headers**: 22px, bold, role-specific color
- **Subheaders**: 20px, bold, section-specific color
- **Body Text**: 16px, regular, `Colors.grey[600]`
- **Small Text**: 14px, regular, `Colors.grey[600]`

### Spacing System
- **Large Spacing**: 20px (between cards)
- **Medium Spacing**: 16px (card padding)
- **Small Spacing**: 12px (between list items)
- **Micro Spacing**: 8px (icon padding)

## Role-Based Theming

### Student Profile (Blue Theme)
- **Header Background**: `Colors.blue[50]`
- **Avatar Background**: `Colors.blue`
- **Section Icons**: Red (struggling courses), Amber (recommendations), Purple (bookings)

### Tutor Profile (Green Theme)
- **Header Background**: `Colors.green[50]`
- **Avatar Background**: `Colors.green`
- **Section Icons**: Blue (courses), Purple (statistics), Orange (sessions)

### Admin Profile (Orange Theme)
- **Header Background**: `Colors.orange[50]`
- **Avatar Background**: `Colors.orange`
- **Section Icons**: Blue (statistics), Red (permissions), Grey (actions)

## Background Patterns
- **Header Cards**: Use light shade variations (e.g., `Colors.blue[50]`)
- **Card Backgrounds**: Use solid colors or light shade variations
- **Consistency**: Use the same background approach across all similar components

## Border and Shadow System
- **Card Borders**: None (using elevation instead)
- **Item Borders**: 1px solid with light shade (e.g., `Colors.blue[200]`)
- **Background Colors**: Use light shades (e.g., `Colors.blue[50]`)
- **Border Colors**: Use medium shades (e.g., `Colors.blue[200]`)

## Implementation Notes

### Material Design 3

#### Theme Setup
The app uses Material Design 3 with a generated color scheme:
```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  ),
)
```

#### How to Use ColorScheme in Widgets

**Accessing theme colors in your widgets:**
```dart
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  
  return Container(
    color: colorScheme.primary,        // Blue (#2196F3)
    child: Text(
      'Hello',
      style: TextStyle(color: colorScheme.onPrimary), // White text
    ),
  );
}
```

**Available ColorScheme properties:**
- `colorScheme.primary` - Main blue color
- `colorScheme.onPrimary` - White text on blue
- `colorScheme.secondary` - Complementary color
- `colorScheme.surface` - Card backgrounds
- `colorScheme.onSurface` - Text on cards
- `colorScheme.outline` - Borders and dividers

#### Practical Examples

**For Cards:**
```dart
Card(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Card content',
    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  ),
)
```

**For Buttons:**
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  onPressed: () {},
  child: Text('Button'),
)
```

### Avatar Images
- **Service**: Pravatar (https://i.pravatar.cc/)
- **Size**: 150x150 pixels
- **Format**: PNG with face cropping
- **Fallback**: Letter avatars when images fail to load

This design guide ensures consistency across all user management interfaces while maintaining clear visual hierarchy and role-based theming.
