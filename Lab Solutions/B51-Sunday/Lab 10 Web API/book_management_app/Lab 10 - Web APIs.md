# Lab 10: Web APIs 

## Overview

In this lab, you'll integrate a Flutter app with a REST API. The app already works it reads from local JSON files. Your task is to replace that with API calls.

You'll learn to:

- Work with RESTful APIs (GET, POST, PUT, DELETE)
- Use Dio for HTTP requests
- Handle async operations and errors
- Convert JSON responses to Dart objects
- Use query parameters

## The Backend API

I've deployed a REST API on Vercel for this lab:

**Base URL:** `https://cmps312-books-api.vercel.app`

**Documentation:** https://cmps312-books-api.vercel.app

### Endpoints

**Categories:**

- `GET /api/categories` - Get all categories
- `GET /api/categories/:id` - Get one category
- `POST /api/categories` - Create category
- `PUT /api/categories/:id` - Update category
- `DELETE /api/categories/:id` - Delete category

**Books:**

- `GET /api/books` - Get all books
- `GET /api/books?categoryId=1` - Filter by category
- `GET /api/books/:id` - Get one book
- `POST /api/books` - Create book
- `PUT /api/books/:id` - Update book
- `DELETE /api/books/:id` - Delete book

## Getting Started

### Step 1: Run the App

First, verify the app works:

```bash
flutter pub get
flutter run
```

Try these features:

- View books and categories
- Add a new book
- Edit an existing book
- Delete a book
- Filter books by category

Right now it's using local JSON files. You'll change that.

### Step 2: Test the API with Postman

Before coding, get familiar with the API using Postman.

**Install Postman:** https://www.postman.com/downloads/

**Test these requests:**

1. **Get all categories**

   - Method: `GET`
   - URL: `https://cmps312-books-api.vercel.app/api/categories`
2. **Get all books**

   - Method: `GET`
   - URL: `https://cmps312-books-api.vercel.app/api/books`
3. **Create a category**

   - Method: `POST`
   - URL: `https://cmps312-books-api.vercel.app/api/categories`
   - Body (JSON):

   ```json
   {
     "name": "Science",
     "description": "Scientific books"
   }
   ```
4. **Filter books by category**

   - Method: `GET`
   - URL: `https://cmps312-books-api.vercel.app/api/books?categoryId=1`

You can also test GET requests in your browser—just paste the URLs directly.

## Your Task

You'll modify two files:

- `lib/features/dashboard/data/repository/category_repo_api.dart`
- `lib/features/dashboard/data/repository/book_repo_api.dart`

Each method currently reads from JSON. Replace that with API calls using Dio.

### What Each Method Needs

Look at the JSON implementation to understand what data each method should return or accept. Then replace it with the equivalent API call.

**General approach:**

1. Remove or comment out the JSON code
2. Write a try-catch block
3. Make the appropriate Dio call
4. Process the response
5. Return the data in the expected format

## Implementation Guide

### CategoryRepoApi (5 methods)

File: `lib/features/dashboard/data/repository/category_repo_api.dart`

#### 1. `getCategories()` - Fetch all categories

Your implementation should:

- Make a GET request to the categories endpoint
- Parse the response into a list of Category objects
- Handle errors appropriately

Think about: What does the JSON version return? Your API version should return the same type.

#### 2. `getCategoryById(int id)` - Fetch one category

Your implementation should:

- Make a GET request with the ID in the URL
- Parse the response into a single Category object
- Return null if the category doesn't exist

Hint: Look at how the JSON version handles "not found" cases.

#### 3. `addCategory(Category category)` - Create new category

Your implementation should:

- Make a POST request with the category data
- Send only the necessary fields (name, description)
- Handle any errors

Question: Does this method return anything? Check the JSON version.

#### 4. `updateCategory(Category category)` - Update category

Your implementation should:

- Validate the category has an ID
- Make a PUT request with the updated data
- Include the ID in the URL

Look at the JSON version what validation does it do first?

#### 5. `deleteCategory(Category category)` - Delete category

Your implementation should:

- Validate the category has an ID
- Make a DELETE request
- Handle errors

Same question as update: what validation happens first?

### BookRepoApi (6 methods)

File: `lib/features/dashboard/data/repository/book_repo_api.dart`

#### 1. `getBooks()` - Fetch all books

Follow the same pattern you used for `getCategories()`.

#### 2. `getBookById(int id)` - Fetch one book

Follow the same pattern you used for `getCategoryById()`.

#### 3. `getBooksByCategory(int categoryId)` - Filter books

This one is different you need to pass a query parameter.

Your implementation should:

- Make a GET request with a query parameter
- Parse the filtered list of books

Check the Dio documentation for how to send query parameters.

#### 4. `addBook(Book book)` - Create new book

Your implementation should:

- Make a POST request with the book data
- Use the `toJson()` method instead of manually building the data object

Why use `toJson()` here but not for categories? Compare the entity classes.

#### 5. `updateBook(Book book)` - Update book

Same pattern as `updateCategory()`, but use `toJson()`.

#### 6. `deleteBook(Book book)` - Delete book

Same pattern as `deleteCategory()`.

## Key Concepts

### HTTP Methods

- **GET**: Retrieve data (read-only)
- **POST**: Create new resources
- **PUT**: Update existing resources
- **DELETE**: Remove resources

### URL Structure

```
/api/categories          → All categories
/api/categories/5        → Category with ID 5
/api/books?categoryId=2  → Books filtered by category 2
```

### Response Processing

When you get a list from the API:

```dart
final response = await _dio.get(url);
// response.data is a List, but of what type?
// How do you convert it to List<Category>?
```

When you get a single item:

```dart
final response = await _dio.get(url);
// response.data is a Map, how do you convert it?
```

### Error Handling

Some methods should throw exceptions on failure:

```dart
catch (e) {
  throw Exception('Failed to ...: $e');
}
```

Others should return null:

```dart
catch (e) {
  return null;
}
```

When do you use which approach? Look at the return types and the JSON implementations.

## Testing Strategy

Don't try to implement everything at once. Go step by step:

**Phase 1: Read operations**

1. Implement `getCategories()`
2. Run the app, do categories load?
3. Implement `getBooks()`
4. Run the app, do books load?

If Phase 1 works, your app now loads data from the API!

**Phase 2: Create operations**
5. Implement `addCategory()`
6. Test by adding a category in the app
7. Implement `addBook()`
8. Test by adding a book

**Phase 3: Update and delete**
9. Implement `updateCategory()` and `deleteCategory()`
10. Test editing and deleting categories
11. Implement `updateBook()` and `deleteBook()`
12. Test editing and deleting books

**Phase 4: Filtering**
13. Implement `getBooksByCategory()`
14. Test the category filter dropdown

## Common Issues

**"Unreachable code" warning**
The JSON code returns a value, so anything after it is unreachable. Delete the JSON code completely.

**"Categories aren't loading"**
Check the console for errors. Common issues:

- No internet connection
- Wrong URL
- Forgot to wrap in try-catch
- Response not parsed correctly

**"Changes aren't persisting"**
If you can add a book but it disappears on refresh, you probably still have JSON code in your create methods.

**Type errors**
Make sure you're converting the response data to the right type. The API returns generic `dynamic` data—you need to cast it.

## Dio Basics

Here's what you'll need to know about Dio:

**Making requests:**

```dart
await _dio.get(url);          // GET
await _dio.post(url, data: ...);   // POST
await _dio.put(url, data: ...);    // PUT
await _dio.delete(url);       // DELETE
```

**Query parameters:**

```dart
await _dio.get(url, queryParameters: {'key': 'value'});
```

**Getting response data:**

```dart
final response = await _dio.get(url);
var data = response.data;  // The actual data from the API
```

## JSON vs API Trade-offs

**JSON (current):**

- Works offline
- Instant responses
- Data lost when app restarts

**API (your implementation):**

- Needs internet
- Slight delay for requests
- Data persists on server
- Multiple users see the same data

Production apps often use both: API for the source of truth, local storage for offline access.

## Need Help?

If you get stuck:

1. Check `Lab 10 - Solution.md` for the complete implementation
2. Test the API in Postman to understand the responses
3. Look at the Dio documentation: https://pub.dev/packages/dio
4. Compare your API implementation with the JSON version—they should return the same types

---

**Good luck! Start with the read operations and build from there.**

*CMPS312 Mobile Application Development • Qatar University*
