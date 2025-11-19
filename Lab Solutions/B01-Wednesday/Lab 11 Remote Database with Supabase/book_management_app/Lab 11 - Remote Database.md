# Lab 11: Remote Database with Supabase

## Overview

In this lab, you'll learn to use Supabase, a modern backend-as-a-service platform that provides a cloud-hosted PostgreSQL database with real-time capabilities. You'll build a book management app that performs CRUD operations on a remote database.

You'll learn to:

- Connect a Flutter app to a cloud database
- Perform CRUD operations on remote data
- Use real-time subscriptions for live data updates
- Handle async database operations
- Convert between Dart objects and database rows
- Work with cloud-based data storage

## Data Storage Evolution: From Local Files to Cloud Database

| Approach                | Capabilities                                   | Limitations                                                   |
| ----------------------- | ---------------------------------------------- | ------------------------------------------------------------- |
| **1. JSON Files** | Read from assets, parse data, works offline    | No queries, no relationships, read-only assets                |
| **2. Floor DB**   | CRUD operations, SQL queries, relationships    | Single device only, no sharing, no multi-user                 |
| **3. Web API**    | Multi-device, centralized data, multiple users | Backend development overhead, server deployment, no real-time |
| **4. Supabase**   | No backend code, real-time sync, built-in auth | Platform dependency, less control than custom backend         |

## Getting Started

### Step 1: Configure Supabase Database

Before working on the Flutter app, set up your database:

1. **Create Account** - Go to [supabase.com](https://supabase.com) and sign up for a free account.
2. **Create Project** - Click "New Project", choose a name, set a database password, and select a region (closest to you).
3. **Create Tables** - Use the SQL Editor or AI assistant to create two tables:

   - `categories` table: id, name, description
   - `books` table: id, title, author, year, categoryId
4. **Initialize Data** - Use the Table Editor to insert sample data, or import from JSON files to populate your tables.
5. **Enable Real-time** - Go to **Database** → **Publications**, find the `supabase_realtime` publication, and toggle on both `categories` and `books` tables. This allows live data synchronization.

### Step 2: Get Your Supabase Credentials

After creating your Supabase project, get your credentials:

1. Go to **Settings** → **API** in your Supabase dashboard
2. Copy the **Project URL** - This is your database endpoint
3. Copy the **anon** key - This allows client access to your database

**Why use .env files?** Never hardcode sensitive credentials in your code. Anyone with access to your repository can steal your keys. Use `.env` files (which are gitignored) and the `dotenv` package to load them securely.

**Create a `.env` file in your project root:**

```
SUPABASE_URL=your_project_url_here
SUPABASE_ANON_KEY=your_anon_key_here
```

**Note on Security:** For this lab, Row Level Security (RLS) is disabled on the database tables to simplify learning. You'll learn about RLS in a future lab when we cover authentication and authorization.

### Step 3: Initialize Supabase in main.dart

Load environment variables and initialize the Supabase client:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
}
```

This creates a singleton client accessible via `Supabase.instance.client`.

## Your Task

You'll implement repository classes that connect to Supabase:

- `lib/features/dashboard/data/repository/category_repo_api.dart`
- `lib/features/dashboard/data/repository/book_repo_api.dart`

Each repository will use the Supabase client to perform database operations.

### How Supabase Works

Supabase uses a client library to communicate with the database. Key concepts:

- Use `_client.from('table_name')` to specify which table to query
- Chain methods like `.select()`, `.insert()`, `.update()`, `.delete()`
- Parse JSON responses using your entity's `fromJson()` method
- All operations return Futures (async)
- Filter results using `.eq('column', value)`
- Get single results with `.single()`

## Implementation Guide

**Set up your repository classes** with the Supabase client:

```dart
class CategoryRepoApi implements CategoryRepository {
  final SupabaseClient _client;
  CategoryRepoApi(this._client);
}
```

**Connect everything with repository providers** (`lib/features/dashboard/presentation/providers/repo_providers.dart`):

```dart
final categoryRepoProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepoApi(Supabase.instance.client);
});

final bookRepoProvider = Provider<BookRepository>((ref) {
  return BookRepoApi(Supabase.instance.client);
});
```

These providers use Riverpod to inject the Supabase client instance into your repositories. Your other providers (like `DashboardProvider`) can then access the repositories through `ref.watch(categoryRepoProvider)`.

### Methods to Implement

**CategoryRepoApi:**

| Method                       | What to Do                                            |
| ---------------------------- | ----------------------------------------------------- |
| `getCategories()`          | Query all categories from database                    |
| `getCategoryById(int id)`  | Fetch single category by ID, return null if not found |
| `addCategory(Category)`    | Insert new category (ID auto-generated)               |
| `updateCategory(Category)` | Update existing category by ID                        |
| `deleteCategory(Category)` | Delete category by ID                                 |
| `watchCategories()`        | Real-time stream of all categories                    |

**BookRepoApi:**

| Method                                 | What to Do                                        |
| -------------------------------------- | ------------------------------------------------- |
| `getBooks()`                         | Query all books from database                     |
| `getBookById(int id)`                | Fetch single book by ID, return null if not found |
| `getBooksByCategory(int categoryId)` | Filter books by category ID                       |
| `addBook(Book)`                      | Insert new book using `book.toJson()`           |
| `updateBook(Book)`                   | Update existing book by ID                        |
| `deleteBook(Book)`                   | Delete book by ID                                 |
| `watchBooks()`                       | Real-time stream of all books                     |

**Note:** For `watch*()` methods:
- Return type is `Stream<List<T>>` (not `Future`)
- Use `.stream(primaryKey: ['id'])` to create a stream
- Map the stream data to your entity objects
- Always cancel stream subscriptions in `onDispose()` to prevent memory leaks

**Hint:** Check the solution file for the complete stream implementation pattern.

## Key Concepts

### Supabase Operations

| Operation | Supabase Method                | Example                                          |
| --------- | ------------------------------ | ------------------------------------------------ |
| Read all  | `.select()`                  | `.from('books').select()`                      |
| Read one  | `.select().eq().single()`    | `.from('books').select().eq('id', 5).single()` |
| Create    | `.insert(data)`              | `.from('books').insert({...})`                 |
| Update    | `.update(data).eq()`         | `.from('books').update({...}).eq('id', 5)`     |
| Delete    | `.delete().eq()`             | `.from('books').delete().eq('id', 5)`          |
| Filter    | `.select().eq()`             | `.from('books').select().eq('categoryId', 2)`  |
| Stream    | `.stream(primaryKey: [...])` | `.from('books').stream(primaryKey: ['id'])`    |

### Query Building

Supabase uses a fluent API (method chaining). You can combine operations:
- Choose table: `.from('table_name')`
- Read: `.select()`
- Filter: `.eq('column', value)`
- Get one: `.single()`
- Sort: `.order('column')`

### Response Types

Important differences:
- `.select()` returns `List<dynamic>` (multiple rows)
- `.select().single()` returns `Map<String, dynamic>` (one row)
- `.insert()`, `.update()`, `.delete()` return void

You'll need to cast and map responses appropriately.

### Real-time Streams

Real-time is a key feature of Supabase:
- Use `.stream(primaryKey: ['id'])` on a table
- Returns a `Stream<List<Map>>` that emits when data changes
- Map stream data to your entities
- **Critical:** Cancel subscriptions in `onDispose()` to avoid memory leaks

When data changes in the database, all connected clients update automatically!

### Error Handling

Handle errors based on method return types:
- Methods returning `Future<Entity?>` → return `null` on error
- Methods returning `Future<void>` → throw exceptions on error
- Wrap operations in try-catch blocks

**Refer to Lab 11 Solution for complete error handling patterns.**

## Testing Strategy

Implement incrementally and test after each phase:

1. **Read operations** - Start with `getCategories()` and `getBooks()`. Verify data loads in the app.
2. **Create operations** - Implement `addCategory()` and `addBook()`. Check the Supabase dashboard to confirm data appears.
3. **Update & Delete** - Add `updateCategory()`, `deleteCategory()`, `updateBook()`, and `deleteBook()`. Test editing and deleting.
4. **Filtering** - Implement `getBooksByCategory()` and test the category filter.
5. **Real-time** - Implement `watchCategories()` and `watchBooks()`. Open the app on two devices and watch changes sync instantly!

## Common Issues

**"Categories aren't loading"**

Check the console for errors. Common issues:

- Supabase URL or anon key is wrong (check `.env` file)
- Table names don't match (use `categories` and `books` exactly)
- No internet connection

**"Streams aren't updating"**

Make sure you:

- Enabled real-time via Database → Publications → `supabase_realtime`
- Used `stream(primaryKey: ['id'])` correctly
- Set up the subscription in your provider's `build()` method
- Called `ref.onDispose()` to cancel the subscription

**Type errors**

Remember:

- `.select()` returns `List<dynamic>`
- `.select().single()` returns `Map<String, dynamic>`
- Cast them properly before mapping to your entity classes

**"Error: null is not a subtype of int"**

When inserting/updating, make sure you're not sending `null` values for non-nullable fields. Use `toJson()` carefully, or manually build the data map.

## Database Schema Best Practices

**1. Naming conventions:**

- Use snake_case in database: `category_id`
- OR use camelCase everywhere: `categoryId`
- Be consistent!

**2. Primary keys:**

- Always use `id` as primary key
- Use auto-increment (serial)
- Don't insert ID manually

**3. Foreign keys:**

- `categoryId` in `books` references `id` in `categories`
- This creates a relationship
- Prevents orphaned books (if you set up cascades)

## Need Help?

If you get stuck:

* Supabase Dart docs: https://supabase.com/docs/reference/dart/introduction
