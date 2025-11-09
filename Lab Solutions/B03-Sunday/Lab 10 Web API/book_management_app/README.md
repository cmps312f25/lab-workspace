# Books Management App - Student Version

**Lab 10: Web APIs - From JSON to API**

This is the student starter project. The app already works—it reads from JSON files. Your job is to switch it to use a real REST API!

## Quick Start

1. **Run the app** (it works out of the box!)
   ```bash
   flutter pub get
   flutter run
   ```

2. **Read the instructions**
   - Open **[Lab 10 - Instructions.md](Lab%2010%20-%20Instructions.md)**
   - Follow the step-by-step guide

3. **Switch from JSON to API**
   - Work on `category_repo_api.dart` (5 methods)
   - Work on `book_repo_api.dart` (6 methods)
   - Comment out JSON code, uncomment API code

## What's Different?

**Current State (JSON):**
- ✅ App works offline
- ✅ Fast (no network delays)
- ❌ Data doesn't persist after restart

**After Your Changes (API):**
- ✅ Data syncs with server
- ✅ Changes persist forever
- ✅ Multiple users can share data

## Your Task

Each repository file has working JSON code with API code commented out below it.

**For each method:**
1. Comment out the JSON implementation
2. Uncomment the API implementation
3. Test the app

**Files to modify:**
- `lib/features/dashboard/data/repository/category_repo_api.dart`
- `lib/features/dashboard/data/repository/book_repo_api.dart`

## Testing Strategy

Switch methods incrementally:
1. Start with `getCategories()` and `getBooks()`
2. Then do `addBook()` and `addCategory()`
3. Finally do update/delete methods

**Test after each change!**

## Need Help?

- **Instructions:** [Lab 10 - Instructions.md](Lab%2010%20-%20Instructions.md)
- **Solution:** [Lab 10 - Solution.md](Lab%2010%20-%20Solution.md)
- **API Docs:** <https://cmps312-books-api.vercel.app>

---

**CMPS312 Mobile App Development • Qatar University**
