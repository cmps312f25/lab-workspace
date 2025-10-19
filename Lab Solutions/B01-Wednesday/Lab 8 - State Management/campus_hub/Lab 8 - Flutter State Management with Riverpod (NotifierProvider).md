# Lab 8 - State Management with Riverpod 

## What's This About?

Remember the campus hub app you built last week with GoRouter? It looks great, but there's a problem - all the lists are empty. That's because we haven't hooked up state management yet. This week, you'll fix that using Riverpod.

Right now, the app compiles and runs fine. You can navigate around, but you won't see any sessions or bookings. By the end of this lab, everything will actually work.

## What You're Learning

This lab is focused on Riverpod basics. You'll learn how to:

- Create Notifier classes
- Set up providers so your data is accessible throughout the app
- Update state (it's simpler than you think!)
- Use `ref.read()` and `ref.watch()` properly

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

**TODO 1-2:** Make your notifier classes work

- Both `SessionNotifier` and `BookingNotifier` need to extend `Notifier<StateType>`
- Then override the `build()` method to return an initial empty state
- The hints in the code will show you exactly how

**TODO 3-4:** Declare the providers

- At the bottom of each file, create a global provider using `NotifierProvider`
- This is what makes your notifiers accessible throughout the app

Once you finish these 4 TODOs, try running the app. It should compile! You won't see any data yet, but that's expected.

---

## Phase 2: Make State Updates Work (TODOs 5-12)

**Files:** Same files as Phase 1

Now that your notifiers are set up, you need to make them actually update state when data loads.

**TODO 5-8:** Open `session_notifier.dart` and find the 4 load methods. Each one has a TODO telling you to update state. Your job is to figure out how to assign the new state.

**TODO 9-12:** Do the same thing in `booking_notifier.dart`. Another 4 methods.

Here's the thing about Riverpod - updating state is really simple. You just assign to the `state` property. No copyWith, no complicated stuff:

```dart
final sessions = await sessionRepository.getAllSessions();
state = SessionData(sessions: sessions);  // That's it!
```

After this phase, data will load in the background, but your UI still won't show it. That's next.

---

## Phase 3: Hook Up the Sessions UI (TODOs 13-17)

**Files:**

- `lib/features/session_management/presentation/pages/sessions_list_page.dart`
- `lib/features/session_management/presentation/pages/session_detail_page.dart`

Now we're getting to the UI. This is where you'll learn the difference between `ref.read()` and `ref.watch()`.

**TODO 13-15:** In `sessions_list_page.dart`:

- Use `ref.read()` in `initState()` to trigger loading (one-time action)
- Use `ref.watch()` in `build()` to listen for state changes (reactive)
- In the filter toggle, use `ref.read()` to load different data based on the filter

**TODO 16-17:** In `session_detail_page.dart`, same pattern - read to load, watch to display.

Quick tip: When you want to call a method on your notifier, you need `.notifier`:

```dart
ref.read(sessionNotifierProvider.notifier).loadAvailableSessions();
```

When you just want to read the state, you don't:

```dart
final state = ref.watch(sessionNotifierProvider);
```

After TODO 17, go run your app and play with the Sessions tab. It should fully work - you can see the list, toggle filters, click on sessions to see details. Pretty cool, right?

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

- Sessions list loads
- Filter toggle works
- Session details show when you click
- Bookings list loads
- Booking details show when you click

---

## Important: ref.watch() vs ref.read()

This trips people up, so pay attention:

**Use ref.watch() when:**

- You're in the `build()` method
- You want your UI to rebuild when state changes
- Example: `final state = ref.watch(sessionNotifierProvider);`

**Use ref.read() when:**

- You're in `initState()`
- You're in a callback (like button onPressed)
- You just want to trigger an action once
- Example: `ref.read(sessionNotifierProvider.notifier).loadSessions();`

Never use `ref.watch()` outside the build method - it won't work and you'll get weird errors.

---

## Testing

**Login credentials:**

- Email: `ah2205001@student.qu.edu.qa`
- Password: `password123`

**What should work when you're done:**

- App compiles with zero errors
- Sessions tab shows a list of tutoring sessions
- Toggle between "Available Only" and "All Sessions" works
- Clicking a session shows its details
- Bookings tab shows a list of bookings
- Clicking a booking shows its details

**Debugging tips:**

- If the app won't compile after TODOs 1-4, check your class declarations
- If data doesn't show after TODO 12, check your state assignments
- If UI doesn't update after TODOs 13-21, check ref.watch vs ref.read
- Check the console for any error messages

---

## Common Mistakes

I see these every semester:

1. **Forgetting .notifier** - When you call a method, you need `.notifier`. When you just access state, you don't.
2. **Using ref.watch() in callbacks** - Don't do it. Use ref.read() instead.
3. **Not assigning to state** - You have to write `state = ...` to actually update the state.
4. **Skipping TODOs** - Work in order! Later TODOs depend on earlier ones.

---

**Alright, that's it. Start with TODO 1 in session_notifier.dart and work through them in order. Good luck!**
