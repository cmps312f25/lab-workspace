# Assignment 5: Digital Library - Supabase Integration

**Due Date:** 30 Nov 2025
**Points:** 100

---

## Objective

Migrate the Digital Library application from JSON-based storage to **Supabase** cloud backend.

**Your task:** Make the app work **exactly** as the given JSON-based app, but using Supabase as the data source.

---

## Instructions

### Step 1: Understand the Current App

Run the provided JSON-based app and interact with **all features**:

- Login and authentication
- View and search books, authors, members
- View and filter transactions
- Add, edit, and delete records
- Observe how real-time updates work

**This is your reference.** Your Supabase implementation must replicate all this functionality.

### Step 2: Set Up Supabase

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Create database tables that match the app's data structure
3. Set up Row Level Security (RLS) policies
4. Seed your database with sample data

### Step 3: Integrate Supabase into the App

1. Initialize Supabase client in the app
2. Update repository implementations to use Supabase instead of JSON files
3. Ensure all features work as they did before

---

## Requirements

The app must:

- Launch without errors
- Connect to your Supabase database
- Display all data (books, authors, members, transactions)
- Support all CRUD operations (Create, Read, Update, Delete)
- Support search and filter functionality
- Support real-time updates using Supabase streams

**Important:** If something works in the JSON app, it must work in your Supabase app. This document is a guide, not a complete list of every implementation detail. You are responsible for ensuring full functionality.

---

## Recommended Starting Point

**Suggestion:** If you have a working **Assignment 3 (Floor ORM)** or **Assignment 4 (DIO Web API)** solution, you may use it as your starting point. Your previous implementation already has repository patterns you can adapt for Supabase.

---

## Submission

Submit to your **private repository** under `Assignments/Assignment5/`:

### Required Files:

1. **Project Code** - Complete Flutter project that runs with Supabase
2. **schema.sql** - Your SQL statements for creating tables and RLS policies
3. **Testing_Sheet.docx** - Screenshots demonstrating all features work

### Submission Structure:

```
your-repo/
└── Assignments/
    └── Assignment5/
        ├── digital_library/
        ├── schema.sql
        └── Testing_Sheet.docx
```

**Important:**

- Do NOT zip files
- Do NOT commit your Supabase credentials (URL and anon key)
- Test thoroughly before submitting

---

## Grading Rubric

| Component                       | Points        | Requirements                                                         |
| ------------------------------- | ------------- | -------------------------------------------------------------------- |
| **Database Setup**        | 25            | Tables created correctly, RLS enabled, data seeded                   |
| **App Functionality**     | 60            | All features work as in the JSON app (CRUD, search, filter, streams) |
| **Testing Documentation** | 15            | Screenshots demonstrating all features work                          |
| **TOTAL**                 | **100** |                                                                      |

### Grading Criteria

- **Complete and Working** (70% of assigned weight)
- **Complete but Not Working** (40% deduction)
- **Not done** (0%)
- Remaining percentage based on code quality

---

## Resources

- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)
- [Supabase Database Guide](https://supabase.com/docs/guides/database)
- [Supabase Real-time](https://supabase.com/docs/guides/realtime)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- Lab materials on Supabase

---

*CMPS312 Mobile Application Development - Qatar University*
