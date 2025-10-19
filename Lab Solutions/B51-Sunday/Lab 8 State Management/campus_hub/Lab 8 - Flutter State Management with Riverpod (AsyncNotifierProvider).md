# Lab 8 - State Management with Riverpod

## What's This About?

Remember the campus hub app you built last week with GoRouter? It looks great, but there's a problem - all the lists are using static data . That's because we haven't hooked up state management yet. This week, you'll fix that using Riverpod.

Right now, the app compiles and runs fine. You can navigate around, but you won't see any sessions or bookings. By the end of this lab, everything will actually work.

## What You're Learning

This lab is focused on Riverpod with asynchronous operations. You'll learn how to:

- Create AsyncNotifier classes for handling async data loading
- Set up AsyncNotifierProvider for data that requires asynchronous operations
- Handle loading, data, and error states automatically
- Update state properly with async/await
- Use `ref.read()` and `ref.watch()` with AsyncValue

## Why AsyncNotifierProvider?

Your app loads data from repositories (and later, from APIs and databases). All these operations are asynchronous. Using `AsyncNotifierProvider` instead of regular `NotifierProvider` gives you:

- Automatic loading states (no manual `isLoading` flags needed)
- Built-in error handling
- Better pattern for async operations
- Type-safe state management

Think of it this way: if your data requires `await`, you should use `AsyncNotifierProvider`.

## How This Lab Works

I've set up 21 TODOs in the code. You'll complete them in order, and the cool thing is the app will start working progressively. After the first 4 TODOs, your app will compile. After TODO 17, the Sessions tab will be fully functional. After all 21, you're done!

Don't try to jump around - the order matters.

---

## Phase 1: Get the Infrastructure Working (TODOs 1-4)

**Files to edit:**

- `lib/features/session_management/presentation/providers/session_notifier.dart`
- `lib/features/booking/presentation/providers/booking_notifier.dart`

**What you need to do:**

Start by opening both notifier files. You'll see that the classes are incomplete - they don't extend anything yet, and the providers aren't declared.

**TODO 1-2:** Make your notifier classes work with async operations

- Both `SessionNotifier` and `BookingNotifier` need to extend `AsyncNotifier<StateType>`
- Then override the `build()` method to return `Future<StateType>` with initial empty state
- The hints in the code will show you exactly how

**Key difference from regular Notifier:**

```dart
// Regular Notifier (synchronous)
class SessionNotifier extends Notifier<SessionData> {
  @override
  SessionData build() {  // Returns SessionData directly
    return SessionData();
  }
}

// AsyncNotifier (asynchronous) - What you'll use!
class SessionNotifier extends AsyncNotifier<SessionData> {
  @override
  Future<SessionData> build() async {  // Returns Future<SessionData>
    await _initializeRepository();
    return SessionData();
  }
}
```

**TODO 3-4:** Declare the providers

- At the bottom of each file, create a global provider using `AsyncNotifierProvider`
- This is what makes your notifiers accessible throughout the app

Once you finish these 4 TODOs, try running the app. It should compile! You won't see any data yet, but that's expected.

---

## Phase 2: Make State Updates Work (TODOs 5-12)

**Files:** Same files as Phase 1

Now that your notifiers are set up, you need to make them actually update state when data loads.

**TODO 5-8:** Open `session_notifier.dart` and find the 4 load methods. Each one has a TODO telling you to update state. Your job is to figure out how to assign the new state.

**TODO 9-12:** Do the same thing in `booking_notifier.dart`. Another 4 methods.

Here's the thing about AsyncNotifier - updating state is different from regular Notifier:

```dart
Future<void> loadAllSessions() async {
  // Set state to loading
  state = const AsyncValue.loading();

  try {
    final sessions = await sessionRepository.getAllSessions();
    // Set state to data using AsyncData
    state = AsyncData(SessionData(sessions: sessions));
  } catch (error, stackTrace) {
    // Set state to error using AsyncError
    state = AsyncError(error, stackTrace);
  }
}
```

**Key Pattern:**
- Start with `AsyncValue.loading()`
- Wrap successful data in `AsyncData()`
- Wrap errors in `AsyncError()`
- Use try-catch to handle errors explicitly

After this phase, data will load in the background, but your UI still won't show it properly. That's next.

---

## Phase 3: Hook Up the Sessions UI (TODOs 13-17)

**Files:**

- `lib/features/session_management/presentation/pages/sessions_list_page.dart`
- `lib/features/session_management/presentation/pages/session_detail_page.dart`

Now we're getting to the UI. This is where you'll learn how to work with AsyncValue in the UI.

**TODO 13-15:** In `sessions_list_page.dart`:

- Use `ref.read()` in `initState()` to trigger loading (one-time action)
- Use `ref.watch()` in `build()` to listen for state changes (reactive)
- Handle the AsyncValue states using the `.when()` pattern
- In the filter toggle, use `ref.read()` to load different data based on the filter

**TODO 16-17:** In `session_detail_page.dart`, same pattern - read to load, watch to display.

**Working with AsyncValue in the UI:**

The state is now wrapped in AsyncValue, which has three possible states:

- Loading: `AsyncValue.loading()`
- Data: `AsyncValue.data(yourData)`
- Error: `AsyncValue.error(error, stackTrace)`

**Use the `.when()` pattern to handle these states:**

```dart
@override
Widget build(BuildContext context) {
  final sessionDataAsync = ref.watch(sessionNotifierProvider);

  return sessionDataAsync.when(
    data: (sessionData) {
      // Your UI with the data
      final sessions = sessionData.sessions;
      return ListView.builder(...);
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(child: Text('Error: $error')),
  );
}
```

**Important Notes:**
- Use meaningful variable names: `sessionDataAsync` or `bookingDataAsync` instead of just `asyncState`
- The `.when()` pattern is preferred as it forces you to handle all three states
- Each parameter in the `.when()` callbacks should also have meaningful names

**Quick tips:**

When you want to call a method on your notifier, you need `.notifier`:

```dart
// In initState
ref.read(sessionNotifierProvider.notifier).loadAvailableSessions();

// In button handlers
ref.read(sessionNotifierProvider.notifier).loadAllSessions();
```

When you just want to watch the state, you don't need `.notifier`:

```dart
final sessionDataAsync = ref.watch(sessionNotifierProvider);
```

After TODO 17, go run your app and play with the Sessions tab. It should fully work - you can see the list, toggle filters, click on sessions to see details. You'll even see loading indicators! Pretty cool, right?

---

## Phase 4: Finish with Bookings (TODOs 18-21)

**Files:**

- `lib/features/booking/presentation/pages/bookings_list_page.dart`
- `lib/features/booking/presentation/pages/booking_detail_page.dart`

This is just more practice. Same pattern as Sessions, but for bookings:

**TODO 18-19:** Bookings list page
**TODO 20-21:** Booking detail page

By now you should be getting the hang of it. If you get stuck, look at what you did in the Sessions pages - it's almost identical.

After TODO 21, your entire app works. Go ahead and test everything:

- Sessions list loads with a loading indicator
- Filter toggle works
- Session details show when you click
- Bookings list loads with a loading indicator
- Booking details show when you click
- Error states show if something goes wrong

---

## Important Concepts

### 1. AsyncNotifier vs Notifier

**Use AsyncNotifier when:**

- You need to load data asynchronously (API calls, database queries, file I/O)
- You want automatic loading and error states
- Your build method needs to be async

**Use regular Notifier when:**

- All your operations are synchronous
- You manually manage loading/error states
- Your build method returns data immediately

**For this app:** Since we're loading from repositories (and later from APIs/databases), AsyncNotifier is the right choice.

### 2. AsyncValue States

AsyncValue has three states:

```dart
// Loading state
const AsyncValue<SessionData>.loading()

// Data state
AsyncValue<SessionData>.data(SessionData(sessions: [...]))

// Error state
AsyncValue<SessionData>.error('Error message', stackTrace)
```

### 3. ref.watch() vs ref.read()

This trips people up, so pay attention:

**Use ref.watch() when:**

- You're in the `build()` method
- You want your UI to rebuild when state changes
- Example: `final asyncState = ref.watch(sessionNotifierProvider);`

**Use ref.read() when:**

- You're in `initState()`
- You're in a callback (like button onPressed)
- You just want to trigger an action once
- Example: `ref.read(sessionNotifierProvider.notifier).loadSessions();`

Never use `ref.watch()` outside the build method - it won't work and you'll get weird errors.

### 4. Updating State with AsyncNotifier

Pattern 1 (Manual):

```dart
Future<void> loadData() async {
  state = const AsyncValue.loading();
  try {
    final data = await repository.getData();
    state = AsyncValue.data(SessionData(sessions: data));
  } catch (error, stackTrace) {
    state = AsyncValue.error(error, stackTrace);
  }
}
```

Pattern 2 (With AsyncValue.guard - recommended):

```dart
Future<void> loadData() async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    final data = await repository.getData();
    return SessionData(sessions: data);
  });
}
```

Pattern 3 (Preserving previous data while loading):

```dart
Future<void> loadData() async {
  // Keep previous data, just set loading flag
  state = const AsyncValue.loading().copyWithPrevious(state);
  state = await AsyncValue.guard(() async {
    final data = await repository.getData();
    return SessionData(sessions: data);
  });
}
```

---

## Testing

**Login credentials:**

- Email: `ah2205001@student.qu.edu.qa`
- Password: `password123`

**What should work when you're done:**

- App compiles with zero errors
- Sessions tab shows loading indicator, then list of tutoring sessions
- Toggle between "Available Only" and "All Sessions" works
- Clicking a session shows its details
- Bookings tab shows loading indicator, then list of bookings
- Clicking a booking shows its details
- If there's an error loading data, you see an error message

**Debugging tips:**

- If the app won't compile after TODOs 1-4, check your class declarations (AsyncNotifier, not Notifier)
- If loading indicators don't appear, make sure you're using AsyncValue.loading()
- If UI doesn't show data, check that you're using .when() or checking asyncState.hasValue
- If UI doesn't update after TODOs 13-21, check ref.watch vs ref.read
- Check the console for any error messages
- Use the Flutter DevTools to inspect Riverpod providers

---

## Common Mistakes

I see these every semester:

1. **Using Notifier instead of AsyncNotifier** - If your data is async, use AsyncNotifier!
2. **Forgetting async/await in build()** - The build method must be async and return Future`<StateType>`:

   ```dart
   @override
   Future<SessionData> build() async {  // async and Future!
     await _initializeRepository();
     return SessionData();
   }
   ```
3. **Not wrapping state in AsyncValue** - You must use AsyncValue:

   ```dart
   // Wrong
   state = SessionData(sessions: sessions);

   // Correct
   state = AsyncValue.data(SessionData(sessions: sessions));
   ```
4. **Not handling AsyncValue in UI** - You can't just use the state directly:

   ```dart
   // Wrong
   final sessions = ref.watch(sessionNotifierProvider).sessions;

   // Correct
   final asyncState = ref.watch(sessionNotifierProvider);
   if (asyncState.hasValue) {
     final sessions = asyncState.value!.sessions;
   }
   ```
5. **Forgetting .notifier** - When you call a method, you need `.notifier`. When you just access state, you don't.
6. **Using ref.watch() in callbacks** - Don't do it. Use ref.read() instead.
7. **Skipping TODOs** - Work in order! Later TODOs depend on earlier ones.

---

## Quick Reference Card

### Provider Declaration

```dart
final sessionNotifierProvider =
  AsyncNotifierProvider<SessionNotifier, SessionData>(
    () => SessionNotifier(),
  );
```

### Class Declaration

```dart
class SessionNotifier extends AsyncNotifier<SessionData> {
  @override
  Future<SessionData> build() async {
    await _initializeRepository();
    return SessionData();
  }
}
```

### Loading Data

```dart
Future<void> loadData() async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    final data = await repository.getData();
    return SessionData(sessions: data);
  });
}
```

### Using in UI (.when pattern)

```dart
final asyncState = ref.watch(sessionNotifierProvider);

return asyncState.when(
  data: (sessionData) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### Using in UI (manual pattern)

```dart
final asyncState = ref.watch(sessionNotifierProvider);

if (asyncState.isLoading) return CircularProgressIndicator();
if (asyncState.hasError) return Text('Error: ${asyncState.error}');
if (asyncState.hasValue) {
  final sessions = asyncState.value!.sessions;
  return ListView(...);
}
```

### Calling Methods

```dart
// In initState or callbacks
ref.read(sessionNotifierProvider.notifier).loadSessions();
```

---

**Alright, that's it. Start with TODO 1 in session_notifier.dart and work through them in order. Good luck!**
