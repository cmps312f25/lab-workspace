-- ============================================
-- LAB 12: CREATE TABLES WITH ROW LEVEL SECURITY
-- ============================================
-- Run this SQL in your Supabase project's SQL Editor
-- Go to: SQL Editor > New Query > Paste this code > Run


-- ============================================
-- PROFILES TABLE
-- Stores user profile information
-- ============================================
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  display_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
-- RLS ensures users can only access data they're authorized to see
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view all profiles (needed to see other users' names in chat)
-- This allows the app to display sender names on messages
CREATE POLICY "Profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

-- Policy: Users can only insert their own profile
-- auth.uid() returns the currently logged-in user's ID
-- This prevents users from creating profiles for other users
CREATE POLICY "Users can insert their own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Policy: Users can only update their own profile
-- This prevents users from modifying other users' profiles
CREATE POLICY "Users can update their own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);


-- ============================================
-- ROOMS TABLE
-- Chat rooms that users can join
-- ============================================
CREATE TABLE rooms (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;

-- Policy: All authenticated users can view all rooms
-- auth.role() = 'authenticated' checks if user is logged in
CREATE POLICY "Rooms are viewable by authenticated users"
  ON rooms FOR SELECT
  TO authenticated
  USING (true);

-- Policy: Authenticated users can create rooms
CREATE POLICY "Authenticated users can create rooms"
  ON rooms FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Policy: Only the room creator can update their room
CREATE POLICY "Users can update their own rooms"
  ON rooms FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by);

-- Policy: Only the room creator can delete their room
CREATE POLICY "Users can delete their own rooms"
  ON rooms FOR DELETE
  TO authenticated
  USING (auth.uid() = created_by);


-- ============================================
-- MESSAGES TABLE
-- Chat messages within rooms
-- ============================================
CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  room_id INTEGER REFERENCES rooms(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can view all messages
-- This allows users to read the chat history
CREATE POLICY "Messages are viewable by authenticated users"
  ON messages FOR SELECT
  TO authenticated
  USING (true);

-- Policy: Authenticated users can send messages
-- But only as themselves (sender_id must match their user ID)
CREATE POLICY "Authenticated users can send messages"
  ON messages FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = sender_id);

-- Policy: Users can only delete their own messages
CREATE POLICY "Users can delete their own messages"
  ON messages FOR DELETE
  TO authenticated
  USING (auth.uid() = sender_id);
