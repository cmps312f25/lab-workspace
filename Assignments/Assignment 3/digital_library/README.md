# Assignment 2: Digital Library UI & Navigation

**Due Date:** 16 October 2025
**Points:** 100

---

## Overview

Build the complete UI and navigation for a Digital Library app. All backend (domain, data, services) is **provided** - you only implement the presentation layer.

---

## What You Get (Pre-Built)

**Domain Layer:**

- Entities: LibraryItem, Book, AudioBook, Member, StudentMember, FacultyMember, etc.
- All business logic methods

**Data Layer:**

- JSON files with sample data
- DataService singleton with all methods

**You Must Build:**

- All screen UIs (7 screens)
- Navigation with go_router

---

## DataService API

```dart
final service = DataService();

// Authentication
service.authenticate(username, password)  // Returns Staff?

// Library Items
service.getAllItems()           // Returns List<LibraryItem>
service.searchItems(query)      // Returns List<LibraryItem>
service.getItem(itemId)         // Returns LibraryItem?

// Members
service.getAllMembers()         // Returns List<Member>
service.searchMembers(query)    // Returns List<Member>
service.getMember(memberId)     // Returns Member?
```

All methods are **synchronous** (no async/await except initialize()).

---

## Implementation Requirements

Follow this step-by-step approach to build the app incrementally and see your progress at each stage:

1. **Setup Routing (app_router.dart)**

   - Create the basic GoRouter structure with `/login` route
   - Hook up LoginScreen
   - Set `initialLocation: '/login'`
   - Update `main.dart` to use `MaterialApp.router`
   - **Test:** App should launch and show login screen
2. **Build Login Screen**

   - Add username/password TextFields with validation
   - Add login button that calls `DataService().authenticate()`
   - Add navigation to home
   - **Test:** Login with admin/admin123 (will crash until home route exists)

   <img src="screenshots/login_screen.png" width="200">

3. **Add Home Route and Build Home Screen**

   - Add `/` route in router (outside shell for now)
   - Build home screen with welcome message and 2 cards
   - Add navigation to library items and members
   - **Test:** Login should navigate to home, see welcome message

   <img src="screenshots/home_screen.png" width="200">
4. **Setup Shell with Bottom Navigation**

   - Build `ShellScaffold` with AppBar, BottomNavigationBar, and logout
   - Create ShellRoute wrapping `/`, `/library-items`, `/members`
   - **Test:** Bottom navigation should work, logout should go back to login

   <img src="screenshots/logout_dialog.png" width="200">
5. **Build Library Items Screen**

   - Display list of all items from `DataService().getAllItems()`
   - Add search bar with `searchItems(query)`
   - Add navigation to details (will crash until route exists)
   - **Test:** See list of books, search should filter results

   <img src="screenshots/library_items_screen.png" width="200">
6. **Add Item Details Route and Screen**

   - Add `/library-items/:id` route (outside shell)
   - Build details screen showing all item info
   - Use type checking for Book vs AudioBook
   - **Test:** Click on item should show details, back button returns to list

   <img src="screenshots/item_detail_top.png" width="200"> <img src="screenshots/item_detail_bottom.png" width="200">

7. **Build Members Screen**

   - Display list of members with statistics
   - Add search functionality
   - Add navigation to member details
   - **Test:** See members list with stats, search should filter

   <img src="screenshots/members_screen.png" width="200">

   <img src="screenshots/members_search.png" width="200">

8. **Build Member Details Screen**

   - Add `/members/:id` route (outside shell)
   - Show all member info, borrowed items, and fees
   - **Test:** Click on member shows details with complete information

   <img src="screenshots/members_detail_screen.png" width="200">

**Key Tip:** After each step, run the app and verify that feature works before moving to the next!

---

## Routes Configuration

**Routes Table:**

| Route Path             | Screen Component         | Inside Shell? | Parameters | File Location                                                                        |
| ---------------------- | ------------------------ | ------------- | ---------- | ------------------------------------------------------------------------------------ |
| `/login`             | LoginScreen              | No            | -          | `lib/features/auth/presentation/screens/login_screen.dart`                         |
| `/`                  | HomeScreen               | Yes           | -          | `lib/features/borrowing/presentation/screens/home_screen.dart`                     |
| `/library-items`     | LibraryItemsScreen       | Yes           | -          | `lib/features/library_items/presentation/screens/library_items_screen.dart`        |
| `/library-items/:id` | LibraryItemDetailsScreen | No            | itemId     | `lib/features/library_items/presentation/screens/library_item_details_screen.dart` |
| `/members`           | MembersScreen            | Yes           | -          | `lib/features/members/presentation/screens/members_screen.dart`                    |
| `/members/:id`       | MemberDetailsScreen      | No            | memberId   | `lib/features/members/presentation/screens/member_details_screen.dart`             |

**shell_scaffold.dart Requirements:**

- AppBar with logout button
- BottomNavigationBar (3 items)
- Logout dialog

---

## Design

**Color Scheme:**

| Usage                    | Color       | Material Design       | Hex Code    |
| ------------------------ | ----------- | --------------------- | ----------- |
| Library items, Available | Teal        | `Colors.teal`       | `#009688` |
| Students, Members        | Deep Purple | `Colors.deepPurple` | `#673AB7` |
| Faculty                  | Orange      | `Colors.orange`     | `#FF9800` |
| Unavailable, Overdue     | Red         | `Colors.red`        | `#F44336` |

**Theme Setup:**

```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
useMaterial3: true,
```

**Reference:** See screenshots in `screenshots/` folder for exact design.

---

## Grading

| Criteria                  | Weight |
| ------------------------- | ------ |
| Login                     | 10     |
| Routing                   | 20     |
| Home                      | 10     |
| LibraryItem with Search   | 20     |
| Item Details              | 10     |
| Members with Search       | 20     |
| Members Details           | 10     |
| **TOTAL**                 | **100**|

**Functionality Grading:**
- **Complete and Working** (get 70% of the assigned weight)
- **Complete and Not Working** (lose 40% of assigned weight)
- **Not done** (get 0%)
- The remaining grade is assigned to the quality of implementation.

---

## Testing

1. **Login:** Valid/invalid credentials, validation
2. **Navigation:** Bottom nav, back buttons, detail screens
3. **Search:** Filter by title/author/name/email
4. **Data:** Items/members load correctly, type-specific fields shown

**Demo Credentials:** admin / admin123

---

## Deliverables

Submit **Assignment2_[YourID].zip** containing:

- Complete Flutter project
- All implemented screens dcoumented inside the testing sheet

---

## Key Hints

**Route Parameters:**

```dart
GoRoute(
  path: '/library-items/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return LibraryItemDetailsScreen(itemId: id);
  },
)
```

**Type Checking:**

```dart
if (item is Book) {
  print(item.isbn);
}
if (member is Payable) {
  final fees = (member as Payable).calculateFees();
}
```

**Search:**

```dart
void _search(String query) {
  setState(() {
    items = query.isEmpty
      ? service.getAllItems()
      : service.searchItems(query);
  });
}
```

---

**Focus on replicating the screenshots! All backend is done - just build the UI.**
