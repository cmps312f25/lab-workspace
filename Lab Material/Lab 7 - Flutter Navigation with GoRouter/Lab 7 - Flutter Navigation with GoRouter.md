# Lab 7 - Flutter Navigation with GoRouter

## Overview

This is **Lab 7**, building on [Lab 6 Flutter Data-Driven UI Development with Clean Architecture](https://github.com/cmps312f25/lab-workspace/blob/main/Lab%20Material/Lab%206%20-%20Flutter%20Data-Driven%20UI%20Development%20with%20Clean%20Architecture/campus_hub/Lab%206%20-%20Flutter%20Data-Driven%20UI%20Development%20with%20Clean%20Architecture.md).

You'll implement a complete navigation system using **GoRouter** with **bottom navigation**, **authentication flows**, and **role-based routing** - essential skills for professional Flutter development.

## What You'll Learn

By completing Lab 7, you'll have a solid understanding of:

- **GoRouter implementation** for complex navigation patterns
- **Authentication flow** with role-based routing
- **Scaffold-based navigation** with shared UI components
- **Professional routing architecture** in Flutter applications

## What's Already Implemented

### From Lab 6 (Your Previous Work)

- **Complete UI Implementation**: All profile pages with beautiful designs
- **Data Integration**: Full repository pattern with JSON data loading
- **Common Widgets**: ProfileAvatar, InfoCard, StatItem, ListItem, ProfileHeader
- **Role-Based Theming**: Blue (Student), Green (Tutor), Orange (Admin)
- **Material Design 3**: Complete implementation with proper theming

## Current App State

The app currently starts with a **normal MaterialApp** that displays the PageSelector from Lab 6. This gives you a working baseline before implementing GoRouter navigation.

**What you'll see when you run the app:**

- PageSelector with role selection buttons
- All profile pages accessible through basic navigation
- No authentication flow (yet)
- No GoRouter implementation (yet)

## Lab 7 Challenge

Transform your Lab 6 app into a professional Flutter application with:

1. **GoRouter Implementation** - Industry-standard routing with authentication
2. **Bottom Navigation** - Role-based tab navigation for each user type
3. **Authentication Flow** - Secure login with role detection and routing
4. **Professional Architecture** - Scalable navigation patterns used in real apps

## Implementation

### What You Need to Do

1. **Implement GoRouter** - Create complete routing system from scratch
2. **Add Route Parameters** - Pass user ID through routes (`/student/:userId`)
3. **Update Login Page** - Integrate with GoRouter navigation and pass user ID
4. **Create Scaffold System** - Build MainScaffold with user data access from route parameters
5. **Update main.dart** - Replace MaterialApp with MaterialApp.router and add routerConfig
6. **Test Complete Flow** - Login → Profile with user data → Logout

### Implementation Details

#### 1. GoRouter Setup (`lib/core/navigation/app_router.dart`)

**Current State**: Empty file with TODO comments

**Requirements**: Implement a complete GoRouter system with:

- Authentication flow (login → role-based redirect with user data)
- Scaffold-based navigation for profile pages
- Route parameters to pass user information
- Role-based theming and app bar customization
- Logout functionality with confirmation dialog

**Key Features**:

- `ShellRoute` for shared scaffold across profile pages
- Route parameters: `/student/:userId`, `/tutor/:userId`, `/admin/:userId`
- Dynamic app bar titles and colors based on user role
- Clean separation between login and authenticated routes

#### 2. Authentication Integration (`lib/features/user_management/presentation/pages/login_page.dart`)

**Current State**: Basic login form (from Lab 6)

**Requirements**: Enhance the login page with:

- Integration with GoRouter navigation
- Role-based redirection with user ID parameter
- Proper error handling and user feedback
- Seamless transition to appropriate profile page

**Available Data**:

- `users`: All users from repository (students, tutors, admins)
- `password`: New password field in user entities
- `role`: UserRole enum for navigation decisions

#### 3. Scaffold Navigation System

**Current State**: Individual profile pages (from Lab 6)

**Requirements**: Wrap profile pages with professional scaffold:

- **App Bar**: Dynamic title and role-based theming
- **User Data**: Access user information from route parameters
- **Logout Button**: Easy access with confirmation dialog
- **Consistent Layout**: Shared structure across all profile pages
- **Role-Based Colors**: Blue (Student), Green (Tutor), Orange (Admin)

**Navigation Flow with Parameters**:

```
/login (No scaffold - standalone)
├── /student/:userId (With MainScaffold - Blue theme)
├── /tutor/:userId (With MainScaffold - Green theme)
└── /admin/:userId (With MainScaffold - Orange theme)
```

### Key Implementation Concepts

- **Route Parameters**: Use `state.pathParameters['userId']` to access user data
- **Navigation with Data**: Use `context.go('/student/${user.id}')` to pass user ID
- **ShellRoute**: Wrap profile routes with shared scaffold
- **Dynamic UI**: Show user information in app bar and throughout the app
- **MaterialApp.router**: Replace MaterialApp with MaterialApp.router for GoRouter integration
- **routerConfig**: Add `routerConfig: AppRouter.router` to connect GoRouter to MaterialApp

### Files to Implement

- `lib/core/navigation/app_router.dart` - Complete GoRouter implementation
- `lib/features/user_management/presentation/pages/login_page.dart` (Update for GoRouter)
- `lib/main.dart` (Update to use GoRouter - currently uses normal MaterialApp)

## Testing

1. Run `flutter run` (app starts with PageSelector - normal MaterialApp)
2. Implement GoRouter and update main.dart to use MaterialApp.router
3. Test login with different user roles
4. Verify navigation with user data works correctly
5. Check that user ID appears in app bar and throughout the app
6. Test logout functionality

## Demo Credentials

- **Student**: `ah2205001@student.qu.edu.qa` / `password123`
- **Tutor**: `sa2205023@student.qu.edu.qa` / `password123`
- **Admin**: `admin@qu.edu.qa` / `admin123`

## Success Criteria

Your implementation should demonstrate:

- Complete GoRouter setup with proper route definitions
- Working authentication flow with user data passing
- Dynamic UI that shows user information from route parameters
- Professional scaffold with role-based theming
- Smooth navigation experience with proper error handling
