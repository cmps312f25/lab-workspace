// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BookDao? _bookDaoInstance;

  CategoryDao? _categoryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `books` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `author` TEXT NOT NULL, `year` INTEGER NOT NULL, `categoryId` INTEGER NOT NULL, FOREIGN KEY (`categoryId`) REFERENCES `categories` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BookDao get bookDao {
    return _bookDaoInstance ??= _$BookDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }
}

class _$BookDao extends BookDao {
  _$BookDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _bookInsertionAdapter = InsertionAdapter(
            database,
            'books',
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'author': item.author,
                  'year': item.year,
                  'categoryId': item.categoryId
                },
            changeListener),
        _bookUpdateAdapter = UpdateAdapter(
            database,
            'books',
            ['id'],
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'author': item.author,
                  'year': item.year,
                  'categoryId': item.categoryId
                },
            changeListener),
        _bookDeletionAdapter = DeletionAdapter(
            database,
            'books',
            ['id'],
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'author': item.author,
                  'year': item.year,
                  'categoryId': item.categoryId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Book> _bookInsertionAdapter;

  final UpdateAdapter<Book> _bookUpdateAdapter;

  final DeletionAdapter<Book> _bookDeletionAdapter;

  @override
  Stream<List<Book>> getBooks() {
    return _queryAdapter.queryListStream('SELECT * FROM books',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            title: row['title'] as String,
            author: row['author'] as String,
            year: row['year'] as int,
            categoryId: row['categoryId'] as int),
        queryableName: 'books',
        isView: false);
  }

  @override
  Future<Book?> getBookById(int id) async {
    return _queryAdapter.query('SELECT * FROM books WHERE id =?1',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            title: row['title'] as String,
            author: row['author'] as String,
            year: row['year'] as int,
            categoryId: row['categoryId'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllBooks() async {
    await _queryAdapter.queryNoReturn('DELETE FROM books');
  }

  @override
  Future<List<Book?>> getBooksByCategory(int categoryId) async {
    return _queryAdapter.queryList('SELECT * FROM books WHERE categoryId =?1',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            title: row['title'] as String,
            author: row['author'] as String,
            year: row['year'] as int,
            categoryId: row['categoryId'] as int),
        arguments: [categoryId]);
  }

  @override
  Future<void> addBook(Book book) async {
    await _bookInsertionAdapter.insert(book, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertBook(Book book) async {
    await _bookInsertionAdapter.insert(book, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertBooks(List<Book> books) async {
    await _bookInsertionAdapter.insertList(books, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateBook(Book book) async {
    await _bookUpdateAdapter.update(book, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBook(Book book) async {
    await _bookDeletionAdapter.delete(book);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'categories',
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                },
            changeListener),
        _categoryUpdateAdapter = UpdateAdapter(
            database,
            'categories',
            ['id'],
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                },
            changeListener),
        _categoryDeletionAdapter = DeletionAdapter(
            database,
            'categories',
            ['id'],
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  final UpdateAdapter<Category> _categoryUpdateAdapter;

  final DeletionAdapter<Category> _categoryDeletionAdapter;

  @override
  Stream<List<Category>> observeCategories() {
    return _queryAdapter.queryListStream('SELECT * FROM categories',
        mapper: (Map<String, Object?> row) => Category(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String),
        queryableName: 'categories',
        isView: false);
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    return _queryAdapter.query('SELECT * FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Category(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    return _queryAdapter.queryList('SELECT * FROM categories',
        mapper: (Map<String, Object?> row) => Category(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String));
  }

  @override
  Future<void> deleteAllCategories() async {
    await _queryAdapter.queryNoReturn('DELETE FROM categories');
  }

  @override
  Future<void> addCategory(Category category) async {
    await _categoryInsertionAdapter.insert(category, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertCategory(Category category) async {
    await _categoryInsertionAdapter.insert(
        category, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertCategories(List<Category> categories) async {
    await _categoryInsertionAdapter.insertList(
        categories, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateCategory(Category category) async {
    await _categoryUpdateAdapter.update(category, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCategory(Category category) async {
    await _categoryDeletionAdapter.delete(category);
  }
}
