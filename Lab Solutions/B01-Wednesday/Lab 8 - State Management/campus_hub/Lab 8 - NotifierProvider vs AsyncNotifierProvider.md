# NotifierProvider vs AsyncNotifierProvider - Migration Guide

## Why the Change?

The original Lab 8 used `NotifierProvider`, but the application performs asynchronous operations (loading data from repositories). When working with async operations, `AsyncNotifierProvider` is the correct and recommended pattern in Riverpod.

## Key Differences

### 1. Class Declaration

**NotifierProvider (Old):**
```dart
class SessionNotifier extends Notifier<SessionData> {
  @override
  SessionData build() {  // Synchronous
    _initializeRepository();
    return SessionData();
  }
}
```

**AsyncNotifierProvider (New):**
```dart
class SessionNotifier extends AsyncNotifier<SessionData> {
  @override
  Future<SessionData> build() async {  // Asynchronous
    await _initializeRepository();
    return SessionData();
  }
}
```

**Differences:**
- Extends `AsyncNotifier` instead of `Notifier`
- `build()` returns `Future<SessionData>` instead of `SessionData`
- `build()` is marked `async`
- Can properly await initialization

---

### 2. Provider Declaration

**NotifierProvider (Old):**
```dart
final sessionNotifierProvider = NotifierProvider<SessionNotifier, SessionData>(
  () => SessionNotifier(),
);
```

**AsyncNotifierProvider (New):**
```dart
final sessionNotifierProvider = AsyncNotifierProvider<SessionNotifier, SessionData>(
  () => SessionNotifier(),
);
```

**Difference:** Change `NotifierProvider` to `AsyncNotifierProvider`

---

### 3. State Updates

**NotifierProvider (Old):**
```dart
Future<void> loadAllSessions() async {
  try {
    final sessions = await sessionRepository.getAllSessions();
    state = SessionData(sessions: sessions);  // Direct assignment
  } catch (e) {
    print('Error: $e');  // Manual error handling
  }
}
```

**AsyncNotifierProvider (New):**
```dart
Future<void> loadAllSessions() async {
  state = const AsyncValue.loading();  // Automatic loading state
  state = await AsyncValue.guard(() async {
    final sessions = await sessionRepository.getAllSessions();
    return SessionData(sessions: sessions);
  });  // Automatic error handling
}
```

**Differences:**
- State is wrapped in `AsyncValue`
- Automatic loading states
- Automatic error handling with `AsyncValue.guard()`
- No need for manual try-catch

---

### 4. UI State Access

**NotifierProvider (Old):**
```dart
@override
Widget build(BuildContext context) {
  final sessionState = ref.watch(sessionNotifierProvider);
  final sessions = sessionState.sessions;  // Direct access

  if (sessions.isEmpty) {
    return Text('No data');
  }

  return ListView.builder(...);
}
```

**AsyncNotifierProvider (New - Using .when()):**
```dart
@override
Widget build(BuildContext context) {
  final asyncState = ref.watch(sessionNotifierProvider);

  return asyncState.when(
    data: (sessionData) {
      final sessions = sessionData.sessions;
      if (sessions.isEmpty) return Text('No data');
      return ListView.builder(...);
    },
    loading: () => CircularProgressIndicator(),  // Automatic loading UI
    error: (err, stack) => Text('Error: $err'),  // Automatic error UI
  );
}
```

**AsyncNotifierProvider (New - Manual Pattern):**
```dart
@override
Widget build(BuildContext context) {
  final asyncState = ref.watch(sessionNotifierProvider);

  if (asyncState.isLoading) {
    return CircularProgressIndicator();
  }

  if (asyncState.hasError) {
    return Text('Error: ${asyncState.error}');
  }

  final sessions = asyncState.value?.sessions ?? [];

  if (sessions.isEmpty) {
    return Text('No data');
  }

  return ListView.builder(...);
}
```

**Differences:**
- State is wrapped in `AsyncValue`
- Automatic handling of loading, data, and error states
- Can use `.when()` for declarative pattern or manual checks
- Access data through `asyncState.value`

---

### 5. Calling Methods (No Change!)

**Both versions use the same pattern:**
```dart
// In initState or callbacks
ref.read(sessionNotifierProvider.notifier).loadSessions();

// In build method for reactive updates
final state = ref.watch(sessionNotifierProvider);
```

---

## Benefits of AsyncNotifierProvider

### 1. Automatic Loading States
```dart
// You don't need to manually track isLoading
state = const AsyncValue.loading();  // UI automatically shows loading
```

### 2. Automatic Error Handling
```dart
// AsyncValue.guard() catches errors automatically
state = await AsyncValue.guard(() async {
  // Your async code here
  // Any error is automatically caught and wrapped in AsyncValue.error
});
```

### 3. Type-Safe State Management
```dart
// The type system ensures you handle all states
asyncState.when(
  data: (data) => ...,      // Must handle data
  loading: () => ...,       // Must handle loading
  error: (err, stack) => ...,  // Must handle error
);
```

### 4. Better UX
- Users see loading indicators automatically
- Errors are displayed properly
- No blank screens during data loading

### 5. Less Boilerplate
- No manual `isLoading` flags
- No manual `error` properties
- No manual try-catch blocks (when using `AsyncValue.guard`)

---

## Migration Checklist

If you have existing code using NotifierProvider and want to migrate:

### Step 1: Update Notifier Classes
- [ ] Change `extends Notifier<T>` to `extends AsyncNotifier<T>`
- [ ] Change `T build()` to `Future<T> build() async`
- [ ] Add `await` to initialization code in build()

### Step 2: Update Providers
- [ ] Change `NotifierProvider` to `AsyncNotifierProvider`

### Step 3: Update State Mutations
- [ ] Wrap state updates in `AsyncValue.loading()` first
- [ ] Wrap data in `AsyncValue.data()` or use `AsyncValue.guard()`
- [ ] Remove manual try-catch if using `AsyncValue.guard()`

### Step 4: Update UI
- [ ] Use `.when()` or manual pattern matching for AsyncValue
- [ ] Access data through `asyncState.value`
- [ ] Handle loading and error states

### Step 5: Test
- [ ] Verify loading indicators appear
- [ ] Verify data displays correctly
- [ ] Verify error states show properly
- [ ] Test all async operations

---

## Common Pitfalls During Migration

### 1. Forgetting to Wrap in AsyncValue
```dart
// Wrong
state = SessionData(sessions: sessions);

// Correct
state = AsyncValue.data(SessionData(sessions: sessions));
```

### 2. Not Handling AsyncValue in UI
```dart
// Wrong
final sessions = ref.watch(sessionNotifierProvider).sessions;

// Correct
final asyncState = ref.watch(sessionNotifierProvider);
final sessions = asyncState.value?.sessions ?? [];
```

### 3. Using NotifierProvider with AsyncNotifier
```dart
// Wrong - Type mismatch!
final provider = NotifierProvider<SessionNotifier, SessionData>(...);

// Correct
final provider = AsyncNotifierProvider<SessionNotifier, SessionData>(...);
```

### 4. Not Making build() Async
```dart
// Wrong
@override
Future<SessionData> build() {  // Missing async!
  _initializeRepository();
  return SessionData();
}

// Correct
@override
Future<SessionData> build() async {
  await _initializeRepository();
  return SessionData();
}
```

---

## When to Use Which?

### Use AsyncNotifierProvider When:
- ✅ You have async operations (API calls, database queries, file I/O)
- ✅ You want automatic loading states
- ✅ You want automatic error handling
- ✅ Your build method needs to be async
- ✅ **This is the case for most real-world apps!**

### Use NotifierProvider When:
- ✅ All operations are synchronous
- ✅ You manually manage loading/error states
- ✅ Your build method returns data immediately
- ✅ You're building simple calculators, counters, or pure state

### Rule of Thumb:
**If you see `await` in your notifier methods → use AsyncNotifierProvider!**

---

## Summary

| Feature | NotifierProvider | AsyncNotifierProvider |
|---------|------------------|----------------------|
| Use Case | Synchronous state | Asynchronous state |
| Build Method | `T build()` | `Future<T> build() async` |
| State Type | `T` | `AsyncValue<T>` |
| Loading States | Manual | Automatic |
| Error Handling | Manual | Automatic |
| UI Pattern | Direct access | `.when()` or pattern matching |
| Best For | Simple state | API calls, DB queries |

---

## Recommended Approach for This Course

**Use AsyncNotifierProvider** because:
1. Your app loads data from repositories
2. Future labs will add API calls
3. Future labs will add database operations
4. Students learn proper async patterns from the start
5. Better UX with automatic loading/error states

**Start students with the right pattern immediately rather than teaching an anti-pattern first!**
