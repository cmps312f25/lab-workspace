# Floor Database with Clean Architecture - Complete Setup Guide

**One-to-Many Relationship Example: Category (1) → Books (many)**
**Using Clean Architecture + Riverpod AsyncNotifier + Streams**

---

## Step 1: Add Dependencies to `pubspec.yaml`

```yaml
dependencies:
  floor: ^1.5.0
  sqflite: ^2.4.1
  path: ^1.9.0
  flutter_riverpod: ^2.6.1

dev_dependencies:
  floor_generator: ^1.5.0
  build_runner: ^2.4.13
```

Run: `flutter pub get`

---

## Step 2: Create Domain Layer

### **Entities with Foreign Keys**

**`lib/features/dashboard/domain/entities/category.dart`** (Parent)

```dart
import 'package:floor/floor.dart';

@Entity(tableName: 'categories')
class Category {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String description;

  Category({this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  Category copyWith({int? id, String? name, String? description}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
```

**`lib/features/dashboard/domain/entities/book.dart`** (Child with FK)

```dart
import 'package:floor/floor.dart';
import 'category.dart';

@Entity(
  tableName: 'books',
  foreignKeys: [
    ForeignKey(
      childColumns: ['categoryId'],
      parentColumns: ['id'],
      entity: Category,
    ),
  ],
)
class Book {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String author;
  final int year;
  final int categoryId;  // Foreign key

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.categoryId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      title: json['title'] as String,
      author: json['author'] as String,
      year: json['year'] as int,
      categoryId: json['categoryId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'categoryId': categoryId,
    };
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    int? year,
    int? categoryId,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
```

### **Repository Interfaces (Contracts)**

**`lib/features/dashboard/domain/contracts/category_repo.dart`**

```dart
import '../entities/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> getCategories();  // Stream for real-time updates
  Future<Category?> getCategoryById(int id);
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(Category category);
}
```

**`lib/features/dashboard/domain/contracts/book_repo.dart`**

```dart
import '../entities/book.dart';

abstract class BookRepository {
  Stream<List<Book>> getBooks();  // Stream for real-time updates
  Future<Book?> getBookById(int id);
  Future<void> addBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(Book book);
  Future<List<Book?>> getBooksByCategory(int categoryId);
}
```

---

## Step 3: Create Data Layer

### **DAOs (Database Access Objects)**

**`lib/core/data/database/daos/categories_dao.dart`**

```dart
import 'package:floor/floor.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM categories')
  Stream<List<Category>> getCategories();  // Stream for reactive UI

  @Query('SELECT * FROM categories')
  Future<List<Category>> getAllCategories();  // One-time fetch

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<Category?> getCategoryById(int id);

  @insert
  Future<void> addCategory(Category category);

  @update
  Future<void> updateCategory(Category category);

  @delete
  Future<void> deleteCategory(Category category);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertCategory(Category category);

  @insert
  Future<void> insertCategories(List<Category> categories);

  @Query('DELETE FROM categories')
  Future<void> deleteAllCategories();
}
```

**`lib/core/data/database/daos/book_dao.dart`**

```dart
import 'package:floor/floor.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

@dao
abstract class BookDao {
  @Query('SELECT * FROM books')
  Stream<List<Book>> getBooks();  // Stream for reactive UI

  @Query('SELECT * FROM books WHERE id = :id')
  Future<Book?> getBookById(int id);

  @Query('SELECT * FROM books WHERE categoryId = :categoryId')
  Future<List<Book?>> getBooksByCategory(int categoryId);

  @insert
  Future<void> addBook(Book book);

  @update
  Future<void> updateBook(Book book);

  @delete
  Future<void> deleteBook(Book book);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertBook(Book book);

  @insert
  Future<void> insertBooks(List<Book> books);

  @Query('DELETE FROM books')
  Future<void> deleteAllBooks();
}
```

### **AppDatabase**

**`lib/core/data/database/app_database.dart`**

```dart
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';
import 'package:state_management_tut/core/data/database/daos/book_dao.dart';
import 'package:state_management_tut/core/data/database/daos/categories_dao.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';

part 'app_database.g.dart';  // Generated code

@Database(version: 1, entities: [Category, Book])
abstract class AppDatabase extends FloorDatabase {
  BookDao get bookDao;
  CategoryDao get categoryDao;
}
```

### **Repository Implementations**

**`lib/features/dashboard/data/repository/category_repo_local_db.dart`**

```dart
import 'package:state_management_tut/core/data/database/daos/categories_dao.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/category_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';

class CategoryRepoLocalDB implements CategoryRepository {
  final CategoryDao _categoriesDao;

  CategoryRepoLocalDB(this._categoriesDao);

  @override
  Stream<List<Category>> getCategories() => _categoriesDao.getCategories();

  @override
  Future<Category?> getCategoryById(int id) =>
      _categoriesDao.getCategoryById(id);

  @override
  Future<void> addCategory(Category category) =>
      _categoriesDao.addCategory(category);

  @override
  Future<void> updateCategory(Category category) =>
      _categoriesDao.updateCategory(category);

  @override
  Future<void> deleteCategory(Category category) =>
      _categoriesDao.deleteCategory(category);
}
```

**`lib/features/dashboard/data/repository/book_repo_local_db.dart`**

```dart
import 'package:state_management_tut/core/data/database/daos/book_dao.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/book_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class BookRepoLocalDB implements BookRepository {
  final BookDao _bookDao;

  BookRepoLocalDB(this._bookDao);

  @override
  Stream<List<Book>> getBooks() => _bookDao.getBooks();

  @override
  Future<void> addBook(Book book) => _bookDao.addBook(book);

  @override
  Future<void> deleteBook(Book book) => _bookDao.deleteBook(book);

  @override
  Future<Book?> getBookById(int id) => _bookDao.getBookById(id);

  @override
  Future<void> updateBook(Book book) => _bookDao.updateBook(book);

  @override
  Future<List<Book?>> getBooksByCategory(int categoryId) =>
      _bookDao.getBooksByCategory(categoryId);
}
```

---

## Step 4: Generate Database Code

Run this command:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

This creates `app_database.g.dart` with all the Floor implementation code.

---

## Step 5: Create Providers (Riverpod)

### **Database Provider**

**`lib/core/data/database/databse_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/core/data/database/app_database.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
});
```

### **Repository Providers**

**`lib/features/dashboard/presentation/providers/repo_providers.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/core/data/database/databse_provider.dart';
import 'package:state_management_tut/features/dashboard/data/repository/book_repo_local_db.dart';
import 'package:state_management_tut/features/dashboard/data/repository/category_repo_local_db.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/book_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/category_repo.dart';

// Return interface types for dependency injection
final bookRepoProvider = FutureProvider<BookRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return BookRepoLocalDB(database.bookDao);
});

final categoryRepoProvider = FutureProvider<CategoryRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return CategoryRepoLocalDB(database.categoryDao);
});
```

### **Presentation Providers (AsyncNotifier with Streams)**

**`lib/features/dashboard/presentation/providers/category_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/category_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/category.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/repo_providers.dart';

class CategoryData {
  List<Category> categories;
  Category? selectedCategory;

  CategoryData({required this.categories, this.selectedCategory});
}

class CategoryNotifier extends AsyncNotifier<CategoryData> {
  late final CategoryRepository _categoryRepo;

  @override
  Future<CategoryData> build() async {
    // Inject repository through provider
    _categoryRepo = await ref.watch(categoryRepoProvider.future);

    // Listen to category stream from repository
    _categoryRepo.getCategories().listen((categories) {
      state = AsyncData(
        CategoryData(
          categories: categories,
          selectedCategory: state.value?.selectedCategory,
        ),
      );
    });

    return CategoryData(categories: []);
  }

  Future<void> addCategory(Category category) async {
    await _categoryRepo.addCategory(category);
    // Stream automatically updates UI
  }

  Future<void> updateCategory(Category category) async {
    await _categoryRepo.updateCategory(category);
  }

  Future<void> deleteCategory(Category category) async {
    await _categoryRepo.deleteCategory(category);
  }

  void updateSelectedCategory(Category? category) {
    state = AsyncData(
      CategoryData(
        categories: state.value?.categories ?? [],
        selectedCategory: category,
      ),
    );
  }

  Future<Category?> getCategoryById(int id) async {
    return await _categoryRepo.getCategoryById(id);
  }
}

final categoryNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, CategoryData>(
  () => CategoryNotifier(),
);
```

**`lib/features/dashboard/presentation/providers/book_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/domain/contracts/book_repo.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';
import 'package:state_management_tut/features/dashboard/presentation/providers/repo_providers.dart';

class DashBoardData {
  List<Book> books;
  DashBoardData({required this.books});
}

class BookNotifier extends AsyncNotifier<DashBoardData> {
  late final BookRepository _bookRepo;

  @override
  Future<DashBoardData> build() async {
    _bookRepo = await ref.watch(bookRepoProvider.future);

    _bookRepo.getBooks().listen((books) {
      state = AsyncData(DashBoardData(books: books));
    });

    return DashBoardData(books: []);
  }

  Future<List<Book?>> getBooksByCategory(int categoryId) async {
    return await _bookRepo.getBooksByCategory(categoryId);
  }

  Future<void> addBook(Book book) async {
    await _bookRepo.addBook(book);
  }

  Future<void> updateBook(Book book) async {
    await _bookRepo.updateBook(book);
  }

  Future<void> deleteBook(Book book) async {
    await _bookRepo.deleteBook(book);
  }

  Future<Book?> getBookById(int id) async {
    return await _bookRepo.getBookById(id);
  }
}

final bookNotifierProvider = AsyncNotifierProvider<BookNotifier, DashBoardData>(
  () => BookNotifier(),
);
```

---

## Step 6: Database Seeding

### **Create DatabaseSeeder**

**`lib/core/data/database/database_seeder.dart`**

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../features/dashboard/domain/entities/book.dart';
import '../../../features/dashboard/domain/entities/category.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase(AppDatabase database) async {
    try {
      // Check if database is already seeded
      final categoryCount = await database.categoryDao.getAllCategories();

      if (categoryCount.isNotEmpty) {
        return; // Already seeded, skip
      }

      // Seed Categories first (parent)
      await _seedCategories(database);

      // Seed Books (child)
      await _seedBooks(database);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _seedCategories(AppDatabase database) async {
    final jsonString = await rootBundle.loadString('assets/data/categories.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final categories = jsonData.map((json) => Category.fromJson(json)).toList();
    await database.categoryDao.insertCategories(categories);
  }

  static Future<void> _seedBooks(AppDatabase database) async {
    final jsonString = await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final books = jsonData.map((json) => Book.fromJson(json)).toList();
    await database.bookDao.insertBooks(books);
  }

  static Future<void> clearDatabase(AppDatabase database) async {
    await database.bookDao.deleteAllBooks();
    await database.categoryDao.deleteAllCategories();
  }
}
```

### **Seed on App Startup**

**`lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/core/navigations/app_router.dart';
import 'package:state_management_tut/core/data/database/databse_provider.dart';
import 'package:state_management_tut/core/data/database/database_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create ProviderContainer to access providers during initialization
  final container = ProviderContainer();

  try {
    // Get the database instance
    final database = await container.read(databaseProvider.future);

    // Seed the database (will only seed if empty)
    await DatabaseSeeder.seedDatabase(database);

    print('Database initialized and seeded successfully');
  } catch (e) {
    print('Error initializing database: $e');
  }

  // Run the app with the provider container
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Floor Database Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
```

---

## Step 7: Usage in UI with .when()

**Example Screen:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsyncValue = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: categoryAsyncValue.when(
        data: (categoryData) {
          final categories = categoryData.categories;

          if (categories.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                subtitle: Text(category.description),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(categoryNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Architecture Flow

```
┌─────────────────────────────────────────────────┐
│ PRESENTATION LAYER                              │
│                                                 │
│ Widgets → Providers (AsyncNotifier)             │
│           └─ Uses: Repository Interfaces        │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│ DOMAIN LAYER                                    │
│                                                 │
│ • Entities (Category, Book)                     │
│ • Repository Interfaces (Contracts)             │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│ DATA LAYER                                      │
│                                                 │
│ Repository Implementations → DAOs → Database    │
└─────────────────────────────────────────────────┘
```

---

## Key Concepts

### **Clean Architecture Benefits**
- ✅ Presentation layer depends only on interfaces
- ✅ Easy to swap databases (Floor → Hive → Firebase)
- ✅ Testable with mock repositories
- ✅ Clear separation of concerns

### **Streams for Reactive UI**
- ✅ DAOs return `Stream<List<T>>` for real-time updates
- ✅ AsyncNotifier listens to streams
- ✅ UI automatically rebuilds on data changes
- ✅ No manual refresh needed after add/update/delete

### **Dependency Injection**
- ✅ Database injected into repositories via providers
- ✅ Repositories injected into notifiers via providers
- ✅ No tight coupling between layers

### **Auto-Generated IDs**
- ✅ Use `@PrimaryKey(autoGenerate: true)` with `int? id`
- ✅ Floor automatically generates IDs on insert
- ✅ No need for manual ID generation

---

## Common Issues & Solutions

### **Issue: "You are trying to change an object which is not an entity"**
**Solution:** Missing entity import in `app_database.dart`

### **Issue: "Database executor undefined"**
**Solution:** Wrong import - use `package:sqflite/sqflite.dart` not `package:sqlite3/sqlite3.dart`

### **Issue: Dropdown shows deprecated 'value' warning**
**Solution:** Use `initialValue:` instead of `value:` in DropdownButtonFormField

### **Issue: Data not updating in UI**
**Solution:** Make sure DAOs return `Stream<List<T>>` and providers listen to them

---

## JSON Sample Data

**`assets/data/categories.json`**
```json
[
  {
    "id": 1,
    "name": "Fiction",
    "description": "Fictional stories and novels"
  },
  {
    "id": 2,
    "name": "Science",
    "description": "Scientific books and research"
  }
]
```

**`assets/data/books.json`**
```json
[
  {
    "id": 1,
    "title": "1984",
    "author": "George Orwell",
    "year": 1949,
    "categoryId": 1
  },
  {
    "id": 2,
    "title": "A Brief History of Time",
    "author": "Stephen Hawking",
    "year": 1988,
    "categoryId": 2
  }
]
```

Don't forget to add to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/data/
```

---

**That's it! You now have a complete Floor database implementation following Clean Architecture principles with reactive streams and proper dependency injection!** 🎉
