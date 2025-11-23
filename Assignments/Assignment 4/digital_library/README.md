# Assignment 4: Digital Library - Web API Integration

**Due Date:** November 22, 2024
**Points:** 100

---

## Overview

Transform your Digital Library application from using local JSON file storage to consuming a **real REST Web API**. The backend is already deployed and ready - your task is to integrate it into your Flutter app using **DIO** for HTTP requests.

### What You're Given

- **Working JSON-based Flutter app**
  - 7 screens (Login, Home, Library Items, Members, Transactions)
  - Repository implementations using JSON file storage
  - Riverpod state management with AsyncNotifier pattern
  - All UI components working perfectly
- **Deployed REST API** with full CRUD operations for all entities
  - Authors, Books, Members, Transactions
  - API documentation:  `https://digital-library-api.vercel.app/docs`

### What You'll Build

Replace all JSON file operations with HTTP requests to the live API. **The UI layer stays exactly the same - only the data layer changes.**

**IMPORTANT: You must implement ALL API operations (GET, POST, PUT, DELETE) available in the API documentation. The app must work exactly as it is currently working with full CRUD functionality.**

### Test Credentials

- `admin` / `admin123`

---

## Requirements

### 1. Update Repository Implementations (90 points)

Replace JSON file operations with DIO HTTP calls in 4 repositories. **You must implement ALL CRUD operations** (Create, Read, Update, Delete) for each repository.

**Note**: Authentication is already implemented with hardcoded credentials (`admin`/`admin123`). You do NOT need to modify `AuthRepositoryImpl`.

#### Files to Update:

1. `lib/features/library_items/data/repositories/author_repository_impl.dart`
2. `lib/features/library_items/data/repositories/library_repository_impl.dart`
3. `lib/features/members/data/repositories/member_repository_impl.dart`
4. `lib/features/borrowing/data/repositories/transaction_repository_impl.dart`

#### What to Do:

1. Remove JSON helper methods (like `_loadAuthorsFromJson()`)
2. Add base URL constant for each repository
3. Replace JSON loading with DIO HTTP calls (`_dio.get()`, `_dio.post()`, `_dio.put()`, `_dio.delete()`)
4. Parse response data appropriately
5. Keep all method signatures identical
6. Implement Stream methods by wrapping Futures
7. **Implement ALL CRUD operations** - no more `UnimplementedError`

**Base URL**: `https://digital-library-api.vercel.app`

---

#### AuthorRepositoryImpl

**Base URL:** `/api/authors`

| Method | Endpoint             | Description       |
| ------ | -------------------- | ----------------- |
| GET    | `/api/authors`     | Get all authors   |
| GET    | `/api/authors/:id` | Get author by ID  |
| POST   | `/api/authors`     | Create new author |
| PUT    | `/api/authors/:id` | Update author     |
| DELETE | `/api/authors/:id` | Delete author     |

**Methods to implement:** `getAllAuthors()`, `getAuthor(id)`, `searchAuthors(query)`, `addAuthor()`, `updateAuthor()`, `deleteAuthor()`

---

#### LibraryRepositoryImpl

**Base URL:** `/api/books`

| Method | Endpoint           | Description                                    |
| ------ | ------------------ | ---------------------------------------------- |
| GET    | `/api/books`     | Get all books (supports `?authorId=` filter) |
| GET    | `/api/books/:id` | Get book by ID                                 |
| POST   | `/api/books`     | Add new book                                   |
| PUT    | `/api/books/:id` | Update book                                    |
| DELETE | `/api/books/:id` | Delete book                                    |

**Methods to implement:** `getAllItems()`, `getItem(id)`, `searchItems(query)`, `getItemsByCategory()`, `getAvailableItems()`, `getItemsByAuthor()`, `addItem()`, `updateItem()`, `deleteItem()`

---

#### MemberRepositoryImpl

**Base URL:** `/api/members`

| Method | Endpoint             | Description                              |
| ------ | -------------------- | ---------------------------------------- |
| GET    | `/api/members`     | Get all members                          |
| GET    | `/api/members/:id` | Get member by ID (includes transactions) |
| POST   | `/api/members`     | Register new member                      |
| PUT    | `/api/members/:id` | Update member                            |
| DELETE | `/api/members/:id` | Delete member                            |

**Methods to implement:** `getAllMembers()`, `getMember(id)`, `searchMembers(query)`, `addMember()`, `updateMember()`, `deleteMember()`

---

#### TransactionRepositoryImpl

**Base URL:** `/api/transactions`

| Method | Endpoint                  | Description                                                             |
| ------ | ------------------------- | ----------------------------------------------------------------------- |
| GET    | `/api/transactions`     | Get all transactions (supports `?memberId=` and `?bookId=` filters) |
| GET    | `/api/transactions/:id` | Get transaction by ID                                                   |
| POST   | `/api/transactions`     | Create borrowing transaction                                            |
| PUT    | `/api/transactions/:id` | Update transaction (return book, etc.)                                  |
| DELETE | `/api/transactions/:id` | Delete transaction                                                      |

**Methods to implement:** `getAllTransactions()`, `getTransaction(id)`, `getTransactionsByMember()`, `getTransactionsByBook()`, `getActiveTransactions()`, `getOverdueTransactions()`, `addTransaction()`, `updateTransaction()`, `deleteTransaction()`

---

**Notes**:

- All filtering (search, category, availability) is done client-side after fetching data
- Stream methods wrap Future results: `Stream<T> watchX() async* { yield await getX(); }`
- The API supports query parameters for some filters (e.g., `?authorId=`, `?memberId=`, `?bookId=`)
- **If a method exists in the repository but is not currently used in the app, you must still implement it with the API call.**

---

### 2. Testing Documentation (10 points)

Create a Word document with screenshots and explanations demonstrating:

#### Required Test Scenarios:

1. **API Data Loading** (2 pts)

   - Screenshot: App launching and loading books from API
   - Screenshot: Members list loading from API
   - Screenshot: Transactions list loading from API
2. **Search Functionality** (2 pts)

   - Screenshot: Searching books by title
   - Screenshot: Searching members by name or email
3. **Filter Operations** (2 pts)

   - Screenshot: Filtering transactions by status (All/Active/Overdue)
   - Screenshot: Available books filter working
4. **CRUD Operations** (4 pts)

   - Screenshot: Adding a new item (book, member, or transaction)
   - Screenshot: Editing an existing item
   - Screenshot: Deleting an item
   - Screenshot: Confirmation of successful operation

---

## Grading Rubric

| Component                           | Points        | Requirements                                         |
| ----------------------------------- | ------------- | ---------------------------------------------------- |
| **AuthorRepositoryImpl**      | 22            | All CRUD operations and search work with API         |
| **LibraryRepositoryImpl**     | 23            | All CRUD operations and filters work with API        |
| **MemberRepositoryImpl**      | 22            | All CRUD operations and search work with API         |
| **TransactionRepositoryImpl** | 23            | All CRUD operations and filters work with API        |
| **Testing Documentation**     | 10            | Complete testing sheet with all required screenshots |
| **TOTAL**                     | **100** |                                                      |

---

## Submission

Submit to your **private repository** under `Assignments/Assignment4/`:

### Required Files:

1. **Project Code** - Complete Flutter project
2. **Testing Sheet** - Word document with:
   - Screenshots of all test scenarios
   - Brief explanation of each test
   - Evidence that all requirements work correctly

### Submission Structure:

```
your-repo/
└── Assignments/
    └── Assignment4/
        ├── digital_library/          (complete project folder)
        │   ├── lib/
        │   ├── assets/
        │   ├── pubspec.yaml
        │   └── ...
        └── Testing_Sheet.docx        (screenshots + explanations)
```

**Important**:

- Do NOT zip files
- Push directly to your private repository
- Test on a fresh installation before submitting
- Verify all API calls work correctly (GET, POST, PUT, DELETE)
- Test error scenarios (network errors, invalid data)

---

*CMPS312 Mobile Application Development • Qatar University*
