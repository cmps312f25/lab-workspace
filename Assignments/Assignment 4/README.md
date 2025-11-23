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
- **Deployed REST API** with read operations for all entities
  - Authors, Books, Members, Transactions
  - API documentation:  `https://digital-library-api.vercel.app/docs`

### What You'll Build

Replace all JSON file operations with HTTP requests to the live API. **The UI layer stays exactly the same - only the data layer changes.**

**IMPORTANT: You must make the app work exactly as it is currently working. All functionalities should work correctly after the migration to the Web API.**

### Test Credentials

- `admin` / `admin123`

---

## Requirements

### 1. Update Repository Implementations (90 points)

Replace JSON file operations with DIO HTTP calls in 4 repositories.

**Note**: Authentication is already implemented with hardcoded credentials (`admin`/`admin123`). You do NOT need to modify `AuthRepositoryImpl`.

#### Files to Update

1. `lib/features/library_items/data/repositories/author_repository_impl.dart`
2. `lib/features/library_items/data/repositories/library_repository_impl.dart`
3. `lib/features/members/data/repositories/member_repository_impl.dart`
4. `lib/features/borrowing/data/repositories/transaction_repository_impl.dart`

#### What to Do

1. Remove JSON helper methods (like `_loadAuthorsFromJson()`)
2. Add base URL constant for each repository
3. Replace JSON loading with `_dio.get(url)` calls
4. Parse response data: `response.data as List`
5. Keep all method signatures identical
6. Implement Stream methods by wrapping Futures
7. You must make the app work exactly as it is currently working.

#### Repository Requirements

| Repository                          | Base URL              | Methods to Implement                                                                                                                                                    |
| ----------------------------------- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **AuthorRepositoryImpl**      | `/api/authors`      | `getAllAuthors()`, `getAuthor(id)`, `searchAuthors(query)` - filter by name                                                                                       |
| **LibraryRepositoryImpl**     | `/api/books`        | `getAllItems()`, `getItem(id)`, `searchItems(query)` - filter by title, `getItemsByCategory()`, `getAvailableItems()`, `getItemsByAuthor()`                 |
| **MemberRepositoryImpl**      | `/api/members`      | `getAllMembers()`, `getMember(id)`, `searchMembers(query)` - filter by name/email                                                                                 |
| **TransactionRepositoryImpl** | `/api/transactions` | `getAllTransactions()`, `getTransaction(id)`, `getTransactionsByMember()`, `getTransactionsByBook()`, `getActiveTransactions()`, `getOverdueTransactions()` |

**Base URL**: `https://digital-library-api.vercel.app`

**Notes**:

- All filtering (search, category, availability) is done client-side after fetching data
- Stream methods wrap Future results: `Stream<T> watchX() async* { yield await getX(); }`
- CRUD operations stay as `UnimplementedError`

---

### 2. Testing Documentation (10 points)

Create a Word document with screenshots and explanations demonstrating:

#### Required Test Scenarios

1. **API Data Loading** (3 pts)

   - Screenshot: App launching and loading books from API
   - Screenshot: Members list loading from API
   - Screenshot: Transactions list loading from API
2. **Search Functionality** (4 pts)

   - Screenshot: Searching books by title
   - Screenshot: Searching members by name or email
3. **Filter Operations** (3 pts)

   - Screenshot: Filtering transactions by status (All/Active/Overdue)
   - Screenshot: Available books filter working

---

## Grading Rubric

| Component                           | Points        | Requirements                                         |
| ----------------------------------- | ------------- | ---------------------------------------------------- |
| **AuthorRepositoryImpl**      | 22            | All read operations and search work with API         |
| **LibraryRepositoryImpl**     | 23            | All read operations and filters work with API        |
| **MemberRepositoryImpl**      | 22            | All read operations and search work with API         |
| **TransactionRepositoryImpl** | 23            | All read operations and filters work with API        |
| **Testing Documentation**     | 10            | Complete testing sheet with all required screenshots |
| **TOTAL**                     | **100** |                                                      |

---

## Submission

Submit to your **private repository** under `Assignments/Assignment4/`:

### Required Files

1. **Project Code** - Complete Flutter project
2. **Testing Sheet** - Word document with:
   - Screenshots of all test scenarios
   - Brief explanation of each test
   - Evidence that all requirements work correctly

### Submission Structure

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
- Verify all API calls work correctly
- Test error scenarios (network errors, invalid data)

---

*CMPS312 Mobile Application Development • Qatar University*
