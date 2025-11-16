# Lab 11: Remote Database with Supabase - Complete Solution

This document shows you the complete implementation for both repository classes using Supabase. Use this as a reference if you get stuck, but try to implement it yourself first.

## CategoryRepoApi - Complete Implementation

Here's the complete category repository with all six methods:

```dart
import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepoApi implements CategoryRepository {
  final SupabaseClient _client;

  CategoryRepoApi(this._client);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _client.from('categories').select();
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .eq('id', id)
          .single();
      return Category.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCategory(Category category) async {
    try {
      await _client.from('categories').insert({
        'name': category.name,
        'description': category.description,
      });
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  @override
  Future<void> updateCategory(Category category) async {
    if (category.id == null) {
      throw Exception('Category ID is required for update');
    }

    try {
      await _client
          .from('categories')
          .update({
            'name': category.name,
            'description': category.description,
          })
          .eq('id', category.id!);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory(Category category) async {
    if (category.id == null) {
      throw Exception('Category ID is required for deletion');
    }

    try {
      await _client.from('categories').delete().eq('id', category.id!);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  @override
  Stream<List<Category>> watchCategories() {
    return _client
        .from('categories')
        .stream(primaryKey: ['id'])
        .order('name')
        .map((data) => data.map((json) => Category.fromJson(json)).toList());
  }
}
```

## BookRepoApi - Complete Implementation

Here's the complete book repository with all seven methods:

```dart
import 'package:book_management_app/features/dashboard/domain/contracts/book_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/book.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookRepoApi implements BookRepository {
  final SupabaseClient _client;

  BookRepoApi(this._client);

  @override
  Future<List<Book>> getBooks() async {
    try {
      final response = await _client.from('books').select();
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }

  @override
  Future<Book?> getBookById(int id) async {
    try {
      final response = await _client
          .from('books')
          .select()
          .eq('id', id)
          .single();
      return Book.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Book>> getBooksByCategory(int categoryId) async {
    try {
      final response = await _client
          .from('books')
          .select()
          .eq('categoryId', categoryId);
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch books by category: $e');
    }
  }

  @override
  Future<void> addBook(Book book) async {
    try {
      await _client.from('books').insert(book.toJson());
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  @override
  Future<void> updateBook(Book book) async {
    if (book.id == null) {
      throw Exception('Book ID is required for update');
    }

    try {
      await _client
          .from('books')
          .update(book.toJson())
          .eq('id', book.id!);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  @override
  Future<void> deleteBook(Book book) async {
    if (book.id == null) {
      throw Exception('Book ID is required for deletion');
    }

    try {
      await _client.from('books').delete().eq('id', book.id!);
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  @override
  Stream<List<Book>> watchBooks() {
    return _client
        .from('books')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((json) => Book.fromJson(json)).toList());
  }
}
```

## Understanding the Code

### Supabase Operation Mapping

Each CRUD operation uses a specific Supabase method:

| Operation      | Supabase Method         | Example                                                    |
| -------------- | ----------------------- | ---------------------------------------------------------- |
| Create         | `.insert()`             | `_client.from('categories').insert({...})`                 |
| Read All       | `.select()`             | `_client.from('categories').select()`                      |
| Read One       | `.select().eq().single()` | `_client.from('categories').select().eq('id', id).single()` |
| Update         | `.update().eq()`        | `_client.from('categories').update({...}).eq('id', id)`    |
| Delete         | `.delete().eq()`        | `_client.from('categories').delete().eq('id', id)`         |
| Filter         | `.select().eq()`        | `_client.from('books').select().eq('categoryId', 1)`       |
| Real-time Stream | `.stream()`           | `_client.from('books').stream(primaryKey: ['id'])`         |

### Making Supabase Queries

**SELECT all rows:**
```dart
final response = await _client.from('categories').select();
```
This fetches all rows from the table.

**SELECT with filter:**
```dart
final response = await _client
    .from('categories')
    .select()
    .eq('id', id)
    .single();
```
The `.eq()` method filters rows where the column equals a value. The `.single()` expects exactly one row.

**SELECT with multiple filters:**
```dart
final response = await _client
    .from('books')
    .select()
    .eq('categoryId', categoryId);
```
You can chain multiple filters together.

**INSERT data:**
```dart
await _client.from('categories').insert({
  'name': category.name,
  'description': category.description,
});
```
Send data as a Map. The database auto-generates the ID and timestamps.

**INSERT using toJson():**
```dart
await _client.from('books').insert(book.toJson());
```
You can use `toJson()` if your entity already has all the right fields. Supabase ignores null values like `id`.

**UPDATE data:**
```dart
await _client
    .from('categories')
    .update({
      'name': category.name,
      'description': category.description,
    })
    .eq('id', category.id!);
```
Update requires two parts: the new data and a filter to specify which row(s) to update.

**DELETE data:**
```dart
await _client.from('categories').delete().eq('id', category.id!);
```
Delete only needs a filter to specify which row(s) to remove.

**STREAM (real-time):**
```dart
return _client
    .from('categories')
    .stream(primaryKey: ['id'])
    .order('name')
    .map((data) => data.map((json) => Category.fromJson(json)).toList());
```
Streams emit new data whenever the table changes. You must specify the primary key.

### Processing Responses

**Converting a list:**
```dart
final response = await _client.from('books').select();
final List<dynamic> data = response as List<dynamic>;
return data.map((json) => Book.fromJson(json)).toList();
```
`.select()` returns `List<dynamic>`. Cast it, then map each item through `fromJson()`.

**Converting a single object:**
```dart
final response = await _client
    .from('books')
    .select()
    .eq('id', id)
    .single();
return Book.fromJson(response);
```
`.single()` returns `Map<String, dynamic>`, so pass it directly to `fromJson()`.

**Mapping streams:**
```dart
.map((data) => data.map((json) => Category.fromJson(json)).toList())
```
Stream data arrives as `List<Map>`. Map each Map to an entity, then convert to List.

### Error Handling

**Throw exceptions for failures:**
```dart
try {
  await _client.from('categories').insert({...});
} catch (e) {
  throw Exception('Failed to add category: $e');
}
```
Use this for create, update, and delete. If something fails, the app should know.

**Return null for "not found":**
```dart
try {
  final response = await _client
      .from('categories')
      .select()
      .eq('id', id)
      .single();
  return Category.fromJson(response);
} catch (e) {
  return null;
}
```
Use this for get-by-id. If the resource doesn't exist, return null—it's not an error.

### Null Safety

Always validate IDs before update/delete:
```dart
if (category.id == null) {
  throw Exception('Category ID is required for update');
}
```
This prevents malformed queries and provides clear error messages.

## Real-time Streams Explained

The `watch*()` methods are unique to Supabase:

```dart
@override
Stream<List<Category>> watchCategories() {
  return _client
      .from('categories')
      .stream(primaryKey: ['id'])
      .order('name')
      .map((data) => data.map((json) => Category.fromJson(json)).toList());
}
```

**What this does:**
- Creates a stream that listens to the `categories` table
- Whenever data changes (insert, update, delete), the stream emits new data
- The `.order('name')` keeps the data sorted
- The `.map()` converts raw data to `List<Category>`

**Using it in a provider:**
```dart
@override
Future<DashBoardData> build() async {
  final subscription = _categoryRepo.watchCategories().listen((categories) {
    state = AsyncData(DashBoardData(categories: categories));
  });

  ref.onDispose(() {
    subscription.cancel(); // Prevent memory leaks!
  });

  final categories = await _categoryRepo.getCategories();
  return DashBoardData(categories: categories);
}
```

**Key points:**
- Always cancel subscriptions in `onDispose()`
- Load initial data with a regular query, then let the stream handle updates
- The UI rebuilds automatically when data changes

## Differences from Web API Version

### Web API (Lab 10):
```dart
// HTTP GET request
final response = await _dio.get('$baseUrl/categories');
final List<dynamic> data = response.data as List;

// HTTP POST request
await _dio.post(baseUrl, data: {...});

// URL construction
final response = await _dio.get('$baseUrl/$id');
```

### Supabase (Lab 11):
```dart
// Database SELECT query
final response = await _client.from('categories').select();
final List<dynamic> data = response as List<dynamic>;

// Database INSERT query
await _client.from('categories').insert({...});

// Query builder with filter
final response = await _client
    .from('categories')
    .select()
    .eq('id', id)
    .single();
```

**Key differences:**
- No HTTP methods (GET, POST, PUT, DELETE)
- No URL construction with IDs
- Uses method chaining for queries
- Direct database access instead of API endpoints
- Built-in real-time capabilities
- Response format is slightly different

## Common Mistakes

**Forgetting to cast the response:**
```dart
// Wrong
return response.map((json) => Category.fromJson(json)).toList();

// Right
final List<dynamic> data = response as List<dynamic>;
return data.map((json) => Category.fromJson(json)).toList();
```

**Using .single() without a filter:**
```dart
// Wrong - this will fail if there are multiple rows
final response = await _client.from('categories').select().single();

// Right - filter first, then get single
final response = await _client
    .from('categories')
    .select()
    .eq('id', id)
    .single();
```

**Not specifying primaryKey for streams:**
```dart
// Wrong
_client.from('books').stream()

// Right
_client.from('books').stream(primaryKey: ['id'])
```

**Forgetting to cancel stream subscriptions:**
```dart
// Wrong - memory leak!
final subscription = repo.watchBooks().listen((books) { ... });

// Right
final subscription = repo.watchBooks().listen((books) { ... });
ref.onDispose(() {
  subscription.cancel();
});
```

**Sending null IDs in queries:**
```dart
// Wrong - will create malformed query
await _client.from('categories').update({...}).eq('id', category.id);

// Right - validate first
if (category.id == null) {
  throw Exception('Category ID is required');
}
await _client.from('categories').update({...}).eq('id', category.id!);
```

## Testing Checklist

After implementing everything, make sure:
- [ ] Categories load when you open the app
- [ ] Books load when you open the app
- [ ] You can create a new category
- [ ] You can create a new book
- [ ] You can edit a category
- [ ] You can edit a book
- [ ] You can delete a category (without books)
- [ ] You can delete a book
- [ ] The category filter works
- [ ] Real-time updates work (test with two devices/windows)
- [ ] Error handling works (turn off WiFi and try to refresh)

## Advantages of Supabase Over Web API

**No Backend Code:**
- With Web API, you need to build and deploy a server
- With Supabase, the backend is already done

**Real-time Built-in:**
- Web API requires manual polling or WebSockets
- Supabase has real-time out of the box

**Less Code:**
- No URL construction
- No HTTP method selection
- Direct database queries

**Automatic Features:**
- Authentication built-in
- Row-level security
- Automatic API generation
- Admin dashboard

## When to Use Each Approach

**Use Web API when:**
- You need full control over the backend
- You have complex business logic on the server
- You're working with an existing API
- You want to avoid vendor lock-in

**Use Supabase when:**
- You want to build quickly
- You need real-time features
- You don't want to manage a backend
- You're building a new app from scratch

---

**Both approaches achieve the same result—the repository pattern means your app doesn't care which one you use!**

*CMPS312 Mobile Application Development • Qatar University*
