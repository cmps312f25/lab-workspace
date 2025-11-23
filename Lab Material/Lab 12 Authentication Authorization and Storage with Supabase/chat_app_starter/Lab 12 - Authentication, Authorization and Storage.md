# Lab 12: Authentication, Authorization & Storage with Supabase

## Overview

In this lab, you'll extend your Supabase knowledge to build a real-time chat application with user authentication, row-level security, and image uploads. You'll learn to:

- Implement user authentication (Sign Up, Sign In, Sign Out)
- Secure your database with Row Level Security (RLS) policies
- Upload and retrieve files from Supabase Storage
- Build a multi-user chat application

## Prerequisites

You should be familiar with [(from Lab 11)](https://github.com/cmps312f25/lab-workspace/blob/main/Lab%20Material/Lab%2011%20Remote%20Database%20with%20Supabase/book_management_app/Lab%2011%20-%20Remote%20Database.md):

- Supabase project setup and credentials (.env file)
- CRUD operations with Supabase
- Real-time streams
- Clean architecture pattern

## What's Already Done For You

The chat app is almost complete! You have:

- All UI screens (Login, Signup, Rooms, Chat)
- All entities (AppUser, Room, Message)
- Room and Message CRUD operations
- Real-time message streaming
- Navigation with GoRouter

## Your Tasks (5 TODOs)

You only need to implement:

| File                       | TODO   | Description                          |
| -------------------------- | ------ | ------------------------------------ |
| `auth_repo_impl.dart`    | TODO 1 | Implement `signUp()`               |
| `auth_repo_impl.dart`    | TODO 2 | Implement `signIn()`               |
| `auth_repo_impl.dart`    | TODO 3 | Implement `signOut()`              |
| `message_repo_impl.dart` | TODO 4 | Implement `uploadImage()`          |
| `message_repo_impl.dart` | TODO 5 | Implement `sendMessageWithImage()` |

---

## Step 1: Supabase Project Setup

### 1.1 Create Tables with RLS

1. Open your Supabase project dashboard
2. Go to **SQL Editor** → **New Query**
3. Open the file `supabase/01_create_tables.sql` from this project
4. Copy and paste the entire SQL code into the SQL Editor
5. Click **Run** to execute

This creates three tables with Row Level Security policies:

- `profiles` - User profile information
- `rooms` - Chat rooms
- `messages` - Chat messages

> **Read the SQL file** - It contains detailed comments explaining what each RLS policy does!

### 1.2 Enable Real-time

1. Go to **Database** → **Publications**
2. Find `supabase_realtime`
3. Enable it for: `profiles`, `rooms`, `messages`

### 1.3 Create Storage Bucket

1. Go to **Storage** in Supabase dashboard
2. Click **New Bucket**
3. Name it: `chat-images`
4. Check **Public bucket** (so images can be viewed without authentication)
5. Click **Create bucket**

### 1.4 Set Storage Policies

1. Go to **SQL Editor** → **New Query**
2. Open the file `supabase/02_storage_policies.sql` from this project
3. Copy and paste the SQL code
4. Click **Run** to execute

### 1.5 Configure .env File

Create a `.env` file in the project root:

```
SUPABASE_URL=your_project_url_here
SUPABASE_ANON_KEY=your_anon_key_here
```

Get these from **Settings** → **API** in your Supabase dashboard.

---

## Step 2: Implement Authentication

Open `lib/features/auth/data/repository/auth_repo_impl.dart`

### TODO 1: Implement Sign Up

Implement the `signUp()` method that:

1. Calls `_client.auth.signUp()` with email, password, and user metadata (display_name)
2. Checks if a user was returned, throws exception if not
3. Creates an `AppUser` object with the user's info
4. Inserts the user profile into the `profiles` table
5. Returns the `AppUser`

**Hints:**

- Use `data: {'display_name': displayName}` to store the display name in user metadata
- Use `appUser.toJson()` when inserting into the database
- The response from signUp has a `.user` property

### TODO 2: Implement Sign In

Implement the `signIn()` method that:

1. Calls `_client.auth.signInWithPassword()` with email and password
2. Checks if a user was returned, throws exception if not
3. Creates and returns an `AppUser` with the user's info

**Hints:**

- User metadata is accessed via `user.userMetadata?['display_name']`
- Email is at `user.email`

### TODO 3: Implement Sign Out

Implement the `signOut()` method that:

1. Calls `_client.auth.signOut()`

This is the simplest one - just one line of code!

---

## Step 3: Implement Storage

Open `lib/features/chat/data/repository/message_repo_impl.dart`

### TODO 4: Implement Upload Image

Implement the `uploadImage()` method that:

1. Creates a unique filename using timestamp + original filename
2. Uploads the file to Supabase Storage
3. Gets the public URL of the uploaded file
4. Returns the public URL

**Hints:**

- Create filename: `'${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}'`
- Upload: `_client.storage.from(storageBucket).upload(fileName, imageFile, fileOptions: ...)`
- Get URL: `_client.storage.from(storageBucket).getPublicUrl(fileName)`
- Use `FileOptions(cacheControl: '3600', upsert: false)` for upload options

### TODO 5: Implement Send Message with Image

Implement the `sendMessageWithImage()` method that:

1. Calls `uploadImage()` to upload the image and get the URL
2. Creates a new message with the image URL using `message.copyWith(imageUrl: url)`
3. Calls `sendMessage()` with the updated message

This method combines upload + send into one convenient method!

---

## Key Concepts

### Supabase Authentication

| Method                                                 | Description                  |
| ------------------------------------------------------ | ---------------------------- |
| `_client.auth.signUp(email:, password:, data:)`      | Create new account           |
| `_client.auth.signInWithPassword(email:, password:)` | Login existing user          |
| `_client.auth.signOut()`                             | Logout current user          |
| `_client.auth.currentUser`                           | Get currently logged in user |
| `_client.auth.onAuthStateChange`                     | Stream of auth state changes |

### Row Level Security (RLS)

RLS policies control who can access what data. See `supabase/01_create_tables.sql` for examples.

| Policy Type    | Use Case                    |
| -------------- | --------------------------- |
| `FOR SELECT` | Control who can read data   |
| `FOR INSERT` | Control who can create data |
| `FOR UPDATE` | Control who can modify data |
| `FOR DELETE` | Control who can remove data |

Key functions:

- `auth.uid()` - Returns the current user's ID
- `auth.role()` - Returns 'authenticated' or 'anon'

### Supabase Storage

| Method                                                    | Description     |
| --------------------------------------------------------- | --------------- |
| `_client.storage.from('bucket').upload(fileName, file)` | Upload a file   |
| `_client.storage.from('bucket').getPublicUrl(fileName)` | Get public URL  |
| `_client.storage.from('bucket').download(fileName)`     | Download a file |
| `_client.storage.from('bucket').remove([fileName])`     | Delete a file   |

---

## Testing Your App

1. **Run the app**: `flutter run`
2. **Sign Up**: Create a new account
3. **Create Room**: Tap the + button to create a chat room
4. **Send Message**: Type and send a text message
5. **Send Image**: Tap the attachment icon to send an image
6. **Test RLS**: Try accessing data you shouldn't (it will be blocked!)

---

## Common Issues

### "Email not confirmed"

By default, Supabase requires email confirmation. For testing, disable it:
**Authentication** → **Providers** → **Email** → Disable "Confirm email"

### "Permission denied" errors

Check your RLS policies. Make sure:

- Tables have RLS enabled
- Policies exist for the operations you're trying to perform
- You're using the correct `auth.uid()` checks

### "Storage upload failed"

Make sure:

- The `chat-images` bucket exists and is public
- Storage policies are set up correctly (run `02_storage_policies.sql`)
- The file isn't too large (default limit: 50MB)

### "User metadata is null"

Make sure you're passing `data: {'display_name': displayName}` in the signUp call.

---

## Project Structure

```
chat_app_starter/
├── supabase/
│   ├── 01_create_tables.sql     # Tables + RLS policies
│   └── 02_storage_policies.sql  # Storage bucket policies
├── lib/
│   └── features/
│       ├── auth/
│       │   └── data/repository/
│       │       └── auth_repo_impl.dart  # TODO 1, 2, 3
│       └── chat/
│           └── data/repository/
│               └── message_repo_impl.dart  # TODO 4, 5
└── .env  # You create this
```

---

## Summary

In this lab, you learned:

1. **Authentication** - How to implement user sign up, sign in, and sign out using Supabase Auth
2. **Authorization (RLS)** - How to secure your database so users can only access their own data
3. **Storage** - How to upload and retrieve files from Supabase Storage

These are essential skills for building any multi-user application!
