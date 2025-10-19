# Lab 8 - Riverpod Implementation Solutions

This document contains the complete solutions for all 21 TODOs in Lab 8.

---

## Phase 1: Notifier Infrastructure (TODOs 1-4)

### TODO 1: Extend SessionNotifier Class

**File:** `session_notifier.dart`

```dart
class SessionNotifier extends Notifier<SessionData> {
  late SessionRepository sessionRepository;
  // ... rest of the class
}
```

### TODO 2: Override build() in SessionNotifier

**File:** `session_notifier.dart`

```dart
@override
SessionData build() {
  _initializeRepository();
  return SessionData();
}
```

**Also TODO 1-2 for BookingNotifier:**

**File:** `booking_notifier.dart`

```dart
class BookingNotifier extends Notifier<BookingData> {
  late BookingRepository bookingRepository;

  @override
  BookingData build() {
    _initializeRepository();
    return BookingData();
  }
  // ... rest of class
}
```

---

### TODO 3: Create sessionNotifierProvider

**File:** `session_notifier.dart` (at the bottom)

```dart
final sessionNotifierProvider = NotifierProvider<SessionNotifier, SessionData>(
  () => SessionNotifier(),
);
```

---

### TODO 4: Create bookingNotifierProvider

**File:** `booking_notifier.dart` (at the bottom)

```dart
final bookingNotifierProvider = NotifierProvider<BookingNotifier, BookingData>(
  () => BookingNotifier(),
);
```

---

## Phase 2: State Updates (TODOs 5-12)

### TODO 5: loadAllSessions()

**File:** `session_notifier.dart`

```dart
Future<void> loadAllSessions() async {
  try {
    final sessions = await sessionRepository.getAllSessions();
    state = SessionData(sessions: sessions);
  } catch (e) {
    print('Error loading sessions: $e');
  }
}
```

---

### TODO 6: loadAvailableSessions()

**File:** `session_notifier.dart`

```dart
Future<void> loadAvailableSessions() async {
  try {
    final sessions = await sessionRepository.getAllSessions();
    final availableSessions = sessions.where((s) => s.isOpen).toList();
    state = SessionData(sessions: availableSessions);
  } catch (e) {
    print('Error loading sessions: $e');
  }
}
```

---

### TODO 7: loadSessionsByTutor()

**File:** `session_notifier.dart`

```dart
Future<void> loadSessionsByTutor(String tutorId) async {
  try {
    final sessions = await sessionRepository.getSessionsByTutor(tutorId);
    state = SessionData(sessions: sessions);
  } catch (e) {
    print('Error loading tutor sessions: $e');
  }
}
```

---

### TODO 8: loadSessionById()

**File:** `session_notifier.dart`

```dart
Future<void> loadSessionById(String sessionId) async {
  try {
    final session = await sessionRepository.getSessionById(sessionId);
    state = SessionData(
      sessions: state.sessions,
      selectedSession: session,
    );
  } catch (e) {
    print('Error loading session: $e');
  }
}
```

---

### TODO 9: loadAllBookings()

**File:** `booking_notifier.dart`

```dart
Future<void> loadAllBookings() async {
  try {
    final bookings = await bookingRepository.getAllBookings();
    state = BookingData(bookings: bookings);
  } catch (e) {
    print('Error loading bookings: $e');
  }
}
```

---

### TODO 10: loadBookingsByStudent()

**File:** `booking_notifier.dart`

```dart
Future<void> loadBookingsByStudent(String studentId) async {
  try {
    final bookings = await bookingRepository.getBookingsByStudent(studentId);
    state = BookingData(bookings: bookings);
  } catch (e) {
    print('Error loading bookings: $e');
  }
}
```

---

### TODO 11: loadBookingsBySession()

**File:** `booking_notifier.dart`

```dart
Future<void> loadBookingsBySession(String sessionId) async {
  try {
    final bookings = await bookingRepository.getBookingsBySession(sessionId);
    state = BookingData(bookings: bookings);
  } catch (e) {
    print('Error loading bookings: $e');
  }
}
```

---

### TODO 12: loadBookingById()

**File:** `booking_notifier.dart`

```dart
Future<void> loadBookingById(String bookingId) async {
  try {
    final booking = await bookingRepository.getBookingById(bookingId);
    state = BookingData(
      bookings: state.bookings,
      selectedBooking: booking,
    );
  } catch (e) {
    print('Error loading booking: $e');
  }
}
```

---

## Phase 3: Sessions UI (TODOs 13-17)

### TODO 13: Load Sessions in initState

**File:** `sessions_list_page.dart`

```dart
@override
void initState() {
  super.initState();
  ref.read(sessionNotifierProvider.notifier).loadAvailableSessions();
}
```

---

### TODO 14: Watch Session State in build()

**File:** `sessions_list_page.dart`

```dart
@override
Widget build(BuildContext context) {
  final sessionState = ref.watch(sessionNotifierProvider);
  final sessions = sessionState.sessions;

  return Column(
    children: [
      // ... rest of the UI
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

```dart
@override
Widget build(BuildContext context) {
  final data = ref.watch(sessionNotifierProvider);
  final session = data.selectedSession;

  if (session == null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No session data'),
          // ... rest of error UI
        ],
      ),
    );
  }

  return SingleChildScrollView(
    // ... rest of the UI
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

### TODO 19: Watch Booking State

**File:** `bookings_list_page.dart`

```dart
@override
Widget build(BuildContext context) {
  final data = ref.watch(bookingNotifierProvider);
  final bookings = data.bookings;

  if (bookings.isEmpty) {
    return Center(
      child: Column(
        // ... empty state UI
      ),
    );
  }

  return ListView.builder(
    // ... rest of the UI
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
  final data = ref.watch(bookingNotifierProvider);
  final booking = data.selectedBooking;

  final session = null;  // Not implemented in this lab

  if (booking == null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No booking data'),
          // ... rest of error UI
        ],
      ),
    );
  }

  return SingleChildScrollView(
    // ... rest of the UI
  );
}
```

---

## Common Issues and Solutions

### Issue 1: "The getter 'notifier' isn't defined"

**Problem:** Student forgot to add `.notifier` when calling methods.

**Wrong:**
```dart
ref.read(sessionNotifierProvider).loadSessions();
```

**Correct:**
```dart
ref.read(sessionNotifierProvider.notifier).loadSessions();
```

---

### Issue 2: "Can't call ref.watch in a callback"

**Problem:** Student used `ref.watch()` outside the build method.

**Wrong:**
```dart
onPressed: () {
  ref.watch(sessionNotifierProvider).loadSessions();
}
```

**Correct:**
```dart
onPressed: () {
  ref.read(sessionNotifierProvider.notifier).loadSessions();
}
```

---

### Issue 3: "State doesn't update"

**Problem:** Student forgot to assign to `state`.

**Wrong:**
```dart
final sessions = await sessionRepository.getAllSessions();
SessionData(sessions: sessions);  // Missing assignment!
```

**Correct:**
```dart
final sessions = await sessionRepository.getAllSessions();
state = SessionData(sessions: sessions);  // Must assign to state
```

---

### Issue 4: "Type mismatch error"

**Problem:** Student didn't extend the correct Notifier type.

**Wrong:**
```dart
class SessionNotifier extends Notifier {  // Missing type!
```

**Correct:**
```dart
class SessionNotifier extends Notifier<SessionData> {
```

---

## Quick Reference

### When to use ref.read() vs ref.watch()

| Location | Use | Why |
|----------|-----|-----|
| `build()` method | `ref.watch()` | Need UI to rebuild on changes |
| `initState()` | `ref.read()` | One-time action, no rebuild needed |
| Button callbacks | `ref.read()` | One-time action |
| Any event handler | `ref.read()` | One-time action |

### State Update Pattern

```dart
// 1. Get data from repository
final data = await repository.getData();

// 2. Assign to state (triggers UI rebuild)
state = StateData(items: data);

// 3. To keep existing data and add new
state = StateData(
  items: state.items,        // Keep existing
  selectedItem: newItem,     // Add new
);
```

---

**End of Solutions - Total: 21 TODOs**
