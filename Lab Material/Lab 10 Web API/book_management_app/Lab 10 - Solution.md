# Lab 10: Web APIs - Complete Solution

This document shows you the complete implementation for both repository classes. Use this as a reference if you get stuck, but try to implement it yourself first.

## CategoryRepoApi - Complete Implementation

Here's the complete category repository with all five methods:

```dart
import 'package:book_management_app/features/dashboard/domain/contracts/category_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/category.dart';
import 'package:dio/dio.dart';

class CategoryRepoApi implements CategoryRepository {
  final Dio _dio;
  static const String _baseUrl =
      'https://cmps312-books-api.vercel.app/api/categories';

  CategoryRepoApi(this._dio);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get(_baseUrl);
      final List<dynamic> data = response.data as List;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');
      return Category.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCategory(Category category) async {
    try {
      await _dio.post(
        _baseUrl,
        data: {
          'name': category.name,
          'description': category.description,
        },
      );
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
      await _dio.put(
        '$_baseUrl/${category.id}',
        data: {
          'name': category.name,
          'description': category.description,
        },
      );
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
      await _dio.delete('$_baseUrl/${category.id}');
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
```

## BookRepoApi - Complete Implementation

Here's the complete book repository with all six methods:

```dart
import 'package:book_management_app/features/dashboard/domain/contracts/book_repo.dart';
import 'package:book_management_app/features/dashboard/domain/entities/book.dart';
import 'package:dio/dio.dart';

class BookRepoApi implements BookRepository {
  final Dio _dio;
  static const String _baseUrl =
      'https://cmps312-books-api.vercel.app/api/books';

  BookRepoApi(this._dio);

  @override
  Future<List<Book>> getBooks() async {
    try {
      final response = await _dio.get(_baseUrl);
      final List<dynamic> data = response.data as List;
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }

  @override
  Future<Book?> getBookById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');
      return Book.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Book>> getBooksByCategory(int categoryId) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'categoryId': categoryId},
      );
      final List<dynamic> data = response.data as List;
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch books by category: $e');
    }
  }

  @override
  Future<void> addBook(Book book) async {
    try {
      await _dio.post(_baseUrl, data: book.toJson());
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
      await _dio.put('$_baseUrl/${book.id}', data: book.toJson());
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
      await _dio.delete('$_baseUrl/${book.id}');
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }
}
```

## Understanding the Code

### HTTP Method Mapping

Each CRUD operation uses a specific HTTP method:

| Operation | HTTP Method | Example |
|-----------|-------------|---------|
| Create    | POST        | `_dio.post(_baseUrl, data: {...})` |
| Read All  | GET         | `_dio.get(_baseUrl)` |
| Read One  | GET         | `_dio.get('$_baseUrl/$id')` |
| Update    | PUT         | `_dio.put('$_baseUrl/$id', data: {...})` |
| Delete    | DELETE      | `_dio.delete('$_baseUrl/$id')` |

### Making Dio Requests

**GET request (no parameters):**
```dart
final response = await _dio.get(_baseUrl);
```
This hits the base URL and returns all resources.

**GET request (with ID in URL):**
```dart
final response = await _dio.get('$_baseUrl/$id');
```
This fetches a specific resource by ID. Notice how we interpolate the ID into the URL.

**GET request (with query parameters):**
```dart
final response = await _dio.get(
  _baseUrl,
  queryParameters: {'categoryId': categoryId},
);
```
Dio converts this to `/api/books?categoryId=1`. Use query parameters for filtering, not URL params.

**POST request (create):**
```dart
await _dio.post(
  _baseUrl,
  data: {
    'name': category.name,
    'description': category.description,
  },
);
```
Send data in the body. For categories, we manually build the data object.

**POST request (using toJson):**
```dart
await _dio.post(_baseUrl, data: book.toJson());
```
For books, we use `toJson()` since the Book entity has all the right fields.

**PUT request (update):**
```dart
await _dio.put(
  '$_baseUrl/${category.id}',
  data: {
    'name': category.name,
    'description': category.description,
  },
);
```
PUT is similar to POST, but includes the ID in the URL.

**DELETE request:**
```dart
await _dio.delete('$_baseUrl/${category.id}');
```
DELETE only needs the URL with the ID—no data body.

### Processing Responses

**Converting a list:**
```dart
final List<dynamic> data = response.data as List;
return data.map((json) => Category.fromJson(json)).toList();
```
The API returns a JSON array, which Dio gives us as `List<dynamic>`. We cast it, then map each item through `fromJson()` to convert to our entity type.

**Converting a single object:**
```dart
return Category.fromJson(response.data);
```
For a single resource, `response.data` is already a Map, so we just pass it to `fromJson()`.

### Error Handling

**Throw exceptions for failures:**
```dart
try {
  await _dio.post(_baseUrl, data: {...});
} catch (e) {
  throw Exception('Failed to add category: $e');
}
```
Use this pattern for create, update, and delete operations. If something goes wrong, the app should know.

**Return null for "not found":**
```dart
try {
  final response = await _dio.get('$_baseUrl/$id');
  return Category.fromJson(response.data);
} catch (e) {
  return null;
}
```
Use this for get-by-id operations. If the resource doesn't exist, just return null—it's not really an error.

### Null Safety

Always validate IDs before update/delete:
```dart
if (category.id == null) {
  throw Exception('Category ID is required for update');
}
```
This prevents trying to call `PUT /api/categories/null`, which would fail anyway. Better to catch it early.

## Why toJson() for Books but not Categories?

Look at how we create categories:
```dart
data: {
  'name': category.name,
  'description': category.description,
}
```

And how we create books:
```dart
data: book.toJson()
```

Both work fine. We use `toJson()` for books because it includes all fields (title, author, year, categoryId). For categories, we only have two fields, so it's just as easy to write them out.

You could use `toJson()` for both—it would work. But when you're only sending a couple fields, writing them explicitly makes it clear what you're sending to the API.

## Common Mistakes

**Forgetting to cast the list:**
```dart
// Wrong
return response.data.map((json) => Book.fromJson(json)).toList();

// Right
final List<dynamic> data = response.data as List;
return data.map((json) => Book.fromJson(json)).toList();
```
Dart needs to know the type before you can map it.

**Using URL params instead of query params:**
```dart
// Wrong
final response = await _dio.get('$_baseUrl/$categoryId');

// Right
final response = await _dio.get(
  _baseUrl,
  queryParameters: {'categoryId': categoryId},
);
```
The first makes the request to `/api/books/1` (looking for a book with ID 1). The second makes the request to `/api/books?categoryId=1` (filtering books by category 1). Very different things.

**Not handling errors:**
```dart
// Wrong
Future<List<Category>> getCategories() async {
  final response = await _dio.get(_baseUrl);
  final List<dynamic> data = response.data as List;
  return data.map((json) => Category.fromJson(json)).toList();
}
```
If the request fails (no internet, server down, etc.), this will crash. Always wrap API calls in try-catch.

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
- [ ] Error handling works (turn off WiFi and try to refresh)

## Differences from JSON Version

The JSON version stored everything in memory and lost data on restart. Your API version:
- Persists data on the server
- Syncs across all users
- Requires internet connection
- Has slight network delays

Both return the same data types and follow the same contract (the repository interface). That's the beauty of the repository pattern—swapping implementations doesn't break anything.

---

*CMPS312 Mobile Application Development • Qatar University*
