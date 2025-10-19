# Lab 8 - Riverpod AsyncNotifierProvider Solutions

This document contains the complete solutions for all 21 TODOs in Lab 8 using AsyncNotifierProvider for proper async state management.

---

## Phase 1: AsyncNotifier Infrastructure (TODOs 1-4)

### TODO 1: Extend SessionNotifier Class

**File:** `session_notifier.dart`

```dart
class SessionNotifier extends AsyncNotifier<SessionData> {
  late SessionRepository sessionRepository;
  // ... rest of the class
}
```

**Key Point:** We use `AsyncNotifier` instead of `Notifier` because all our data loading operations are asynchronous.

---

### TODO 2: Override build() in SessionNotifier

**File:** `session_notifier.dart`

```dart
@override
Future<SessionData> build() async {
  await _initializeRepository();
  return SessionData();
}
```

**Key Points:**
- The method is `async` and returns `Future<SessionData>`
- This is different from regular Notifier which returns `SessionData` directly
- The repository initialization is now awaited

**Also TODO 1-2 for BookingNotifier:**

**File:** `booking_notifier.dart`

```dart
class BookingNotifier extends AsyncNotifier<BookingData> {
  late BookingRepository bookingRepository;

  @override
  Future<BookingData> build() async {
    await _initializeRepository();
    return BookingData();
  }
  // ... rest of class
}
```

---

### TODO 3: Create sessionNotifierProvider

**File:** `session_notifier.dart` (at the bottom)

```dart
final sessionNotifierProvider = AsyncNotifierProvider<SessionNotifier, SessionData>(
  () => SessionNotifier(),
);
```

**Key Point:** Use `AsyncNotifierProvider` instead of `NotifierProvider`.

---

### TODO 4: Create bookingNotifierProvider

**File:** `booking_notifier.dart` (at the bottom)

```dart
final bookingNotifierProvider = AsyncNotifierProvider<BookingNotifier, BookingData>(
  () => BookingNotifier(),
);
```

---

## Phase 2: State Updates with AsyncValue (TODOs 5-12)

### TODO 5: loadAllSessions()

**File:** `session_notifier.dart`

**Solution (Recommended):**
```dart
Future<void> loadAllSessions() async {
  state = const AsyncValue.loading();
  try {
    final sessions = await sessionRepository.getAllSessions();
    state = AsyncData(SessionData(sessions: sessions));
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}
```

**Key Points:**
- Set state to loading before starting async operation with `AsyncValue.loading()`
- Wrap the result in `AsyncData()` when successful
- Wrap errors in `AsyncError()` in the catch block
- This pattern gives you explicit control over state updates

---

### TODO 6: loadAvailableSessions()

**File:** `session_notifier.dart`

```dart
Future<void> loadAvailableSessions() async {
  state = const AsyncValue.loading();
  try {
    final sessions = await sessionRepository.getAllSessions();
    final availableSessions = sessions.where((s) => s.isOpen).toList();
    state = AsyncData(SessionData(sessions: availableSessions));
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}
```

---

### TODO 7: loadSessionsByTutor()

**File:** `session_notifier.dart`

```dart
Future<void> loadSessionsByTutor(String tutorId) async {
  state = const AsyncValue.loading();
  try {
    final sessions = await sessionRepository.getSessionsByTutor(tutorId);
    state = AsyncData(SessionData(sessions: sessions));
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}
```

---

### TODO 8: loadSessionById()

**File:** `session_notifier.dart`

```dart
Future<void> loadSessionById(String sessionId) async {
  state = const AsyncValue.loading();
  try {
    final session = await sessionRepository.getSessionById(sessionId);
    state = AsyncData(SessionData(
      sessions: state.value?.sessions ?? [],
      selectedSession: session,
    ));
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}
```

**Key Point:** Use `state.value?.sessions ?? []` to preserve existing sessions while adding the selected session.

---

### TODO 9: loadAllBookings()

**File:** `booking_notifier.dart`

```dart
Future<void> loadAllBookings() async {
  state = const AsyncValue.loading();
  try {
    final bookings = await bookingRepository.getAllBookings();
    state = AsyncData(BookingData(bookings: bookings));
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}
```

---

### TODO 10: loadBookingsByStudent()

**File:** `booking_notifier.dart`

```dart
Future<void> loadBookingsByStudent(String studentId) async {
  state = const AsyncValue.loading();
  try {
    final bookings = await bookingRepository.getBookingsByStudent(studentId);
    state = AsyncData(BookingData(bookings: bookings));
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}
```

---

### TODO 11: loadBookingsBySession()

**File:** `booking_notifier.dart`

```dart
Future<void> loadBookingsBySession(String sessionId) async {
  state = const AsyncValue.loading();
  try {
    final bookings = await bookingRepository.getBookingsBySession(sessionId);
    state = AsyncData(BookingData(bookings: bookings));
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}
```

---

### TODO 12: loadBookingById()

**File:** `booking_notifier.dart`

```dart
Future<void> loadBookingById(String bookingId) async {
  state = const AsyncValue.loading();
  try {
    final booking = await bookingRepository.getBookingById(bookingId);
    state = AsyncData(BookingData(
      bookings: state.value?.bookings ?? [],
      selectedBooking: booking,
    ));
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}
```

---

## Phase 3: Sessions UI with AsyncValue (TODOs 13-17)

### TODO 13: Load Sessions in initState

**File:** `sessions_list_page.dart`

```dart
@override
void initState() {
  super.initState();
  ref.read(sessionNotifierProvider.notifier).loadAvailableSessions();
}
```

**Key Point:** Use `ref.read()` in initState to trigger one-time data loading

---

### TODO 14: Watch Session AsyncValue State in build()

**File:** `sessions_list_page.dart`

**Solution (Using .when() - Recommended):**
```dart
@override
Widget build(BuildContext context) {
  final sessionDataAsync = ref.watch(sessionNotifierProvider);

  return Column(
    children: [
      // Filter Toggle (same as before)
      // ...

      Expanded(
        child: asyncState.when(
          data: (sessionData) {
            final sessions = sessionData.sessions;

            if (sessions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      showAvailableOnly
                          ? 'No available sessions'
                          : 'No sessions found',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                // ... rest of the card UI (same as before)
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(sessionNotifierProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
```

**Alternative Solution (Manual pattern matching):**
```dart
@override
Widget build(BuildContext context) {
  final asyncState = ref.watch(sessionNotifierProvider);

  return Column(
    children: [
      // Filter Toggle
      // ...

      Expanded(
        child: asyncState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : asyncState.hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${asyncState.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(sessionNotifierProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : () {
                    final sessions = asyncState.value?.sessions ?? [];

                    if (sessions.isEmpty) {
                      return Center(
                        child: Text('No sessions found'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        // ... rest of the UI
                      },
                    );
                  }(),
      ),
    ],
  );
}
```

---

### TODO 15: Toggle Filter

**File:** `sessions_list_page.dart`

```dart
void _toggleFilter() {
  setState(() {
    showAvailableOnly = !showAvailableOnly;
  });

  if (showAvailableOnly) {
    ref.read(sessionNotifierProvider.notifier).loadAvailableSessions();
  } else {
    ref.read(sessionNotifierProvider.notifier).loadAllSessions();
  }
}
```

**Key Point:** No changes here - still use `ref.read()` in callbacks.

---

### TODO 16: Load Session by ID

**File:** `session_detail_page.dart`

```dart
@override
void initState() {
  super.initState();
  ref.read(sessionNotifierProvider.notifier).loadSessionById(widget.sessionId);
}
```

---

### TODO 17: Watch Selected Session

**File:** `session_detail_page.dart`

**Solution (Using .when()):**
```dart
@override
Widget build(BuildContext context) {
  final asyncState = ref.watch(sessionNotifierProvider);

  return asyncState.when(
    data: (data) {
      final session = data.selectedSession;

      if (session == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No session data'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            // ... (same UI as before)
          ],
        ),
      );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    ),
  );
}
```

**Alternative Solution (Manual pattern):**
```dart
@override
Widget build(BuildContext context) {
  final asyncState = ref.watch(sessionNotifierProvider);

  if (asyncState.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (asyncState.hasError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: ${asyncState.error}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  final session = asyncState.value?.selectedSession;

  if (session == null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No session data'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... (same UI as before)
      ],
    ),
  );
}
```

---

## Phase 4: Bookings UI (TODOs 18-21)

### TODO 18: Load Bookings in initState

**File:** `bookings_list_page.dart`

```dart
@override
void initState() {
  super.initState();
  if (widget.studentId != null) {
    ref.read(bookingNotifierProvider.notifier).loadBookingsByStudent(widget.studentId!);
  } else {
    ref.read(bookingNotifierProvider.notifier).loadAllBookings();
  }
}
```

---

### TODO 19: Watch Booking AsyncValue State

**File:** `bookings_list_page.dart`

```dart
@override
Widget build(BuildContext context) {
  final asyncState = ref.watch(bookingNotifierProvider);

  return asyncState.when(
    data: (data) {
      final bookings = data.bookings;

      if (bookings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book_online, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No bookings yet',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          // ... (same card UI as before)
        },
      );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(bookingNotifierProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );
}
```

---

### TODO 20: Load Booking by ID

**File:** `booking_detail_page.dart`

```dart
@override
void initState() {
  super.initState();
  ref.read(bookingNotifierProvider.notifier).loadBookingById(widget.bookingId);
}
```

---

### TODO 21: Watch Selected Booking

**File:** `booking_detail_page.dart`

```dart
@override
Widget build(BuildContext context) {
  final asyncState = ref.watch(bookingNotifierProvider);

  return asyncState.when(
    data: (data) {
      final booking = data.selectedBooking;
      final session = null; // Not implemented yet

      if (booking == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No booking data'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (same UI as before)
          ],
        ),
      );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    ),
  );
}
```

---

## Common Issues and Solutions

### Issue 1: "The type 'AsyncNotifier<SessionData>' doesn't extend 'Notifier<SessionData>'"

**Problem:** Student used NotifierProvider instead of AsyncNotifierProvider.

**Wrong:**
```dart
final sessionNotifierProvider = NotifierProvider<SessionNotifier, SessionData>(
  () => SessionNotifier(),
);
```

**Correct:**
```dart
final sessionNotifierProvider = AsyncNotifierProvider<SessionNotifier, SessionData>(
  () => SessionNotifier(),
);
```

---

### Issue 2: "build() must return Future<SessionData>"

**Problem:** Student forgot to make build() async or return a Future.

**Wrong:**
```dart
@override
SessionData build() {  // Missing Future and async
  _initializeRepository();
  return SessionData();
}
```

**Correct:**
```dart
@override
Future<SessionData> build() async {
  await _initializeRepository();
  return SessionData();
}
```

---

### Issue 3: "State update doesn't work"

**Problem:** Student forgot to wrap state in AsyncValue.

**Wrong:**
```dart
state = SessionData(sessions: sessions);  // Not wrapped in AsyncValue!
```

**Correct:**
```dart
state = AsyncData(SessionData(sessions: sessions));
```

---

### Issue 4: "UI doesn't show data"

**Problem:** Student tried to access state directly without handling AsyncValue.

**Wrong:**
```dart
final sessions = ref.watch(sessionNotifierProvider).sessions;  // Can't access directly!
```

**Correct:**
```dart
final asyncState = ref.watch(sessionNotifierProvider);
if (asyncState.hasValue) {
  final sessions = asyncState.value!.sessions;
}
```

**Even Better:**
```dart
final asyncState = ref.watch(sessionNotifierProvider);
return asyncState.when(
  data: (sessionData) => ListView.builder(...),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

---

### Issue 5: "AsyncValue doesn't have property 'sessions'"

**Problem:** Student tried to access the data properties directly on AsyncValue.

**Wrong:**
```dart
final asyncState = ref.watch(sessionNotifierProvider);
final sessions = asyncState.sessions;  // AsyncValue doesn't have .sessions!
```

**Correct:**
```dart
final asyncState = ref.watch(sessionNotifierProvider);
final sessions = asyncState.value?.sessions ?? [];  // Access through .value
```

---

## Quick Reference

### AsyncNotifier Pattern

| Component | Code |
|-----------|------|
| Class Declaration | `class SessionNotifier extends AsyncNotifier<SessionData>` |
| Build Method | `Future<SessionData> build() async { ... }` |
| Provider Declaration | `AsyncNotifierProvider<SessionNotifier, SessionData>(...)` |
| Set Loading | `state = const AsyncValue.loading()` |
| Set Data | `state = AsyncData(SessionData(...))` |
| Set Error | `state = AsyncError(error, stackTrace)` |

### AsyncValue in UI

| Pattern | Code |
|---------|------|
| .when() | `asyncState.when(data: ..., loading: ..., error: ...)` |
| Check Loading | `asyncState.isLoading` |
| Check Error | `asyncState.hasError` |
| Check Data | `asyncState.hasValue` |
| Get Value | `asyncState.value?.property ?? defaultValue` |
| Get Error | `asyncState.error` |

### When to use what

| Location | Use | Example |
|----------|-----|---------|
| initState | `ref.read()` | `ref.read(provider.notifier).loadData()` |
| build() | `ref.watch()` | `final state = ref.watch(provider)` |
| Button callback | `ref.read()` | `onPressed: () => ref.read(provider.notifier).save()` |
| Retry button | `ref.refresh()` | `onPressed: () => ref.refresh(provider)` |

---

**End of Solutions - Total: 21 TODOs**

**Remember:** AsyncNotifierProvider is the correct choice when your data loading is asynchronous. It gives you automatic loading states, error handling, and a clean pattern for async operations!
