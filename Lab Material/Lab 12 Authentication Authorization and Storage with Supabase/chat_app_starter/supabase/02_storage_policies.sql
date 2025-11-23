-- ============================================
-- LAB 12: STORAGE BUCKET POLICIES
-- ============================================
-- Run this SQL AFTER creating the 'chat-images' storage bucket
--
-- First, create the bucket manually:
-- 1. Go to Storage in Supabase dashboard
-- 2. Click "New Bucket"
-- 3. Name it: chat-images
-- 4. Check "Public bucket"
-- 5. Click "Create bucket"
--
-- Then run this SQL to set up the policies:


-- Policy: Allow authenticated users to upload images
-- Only logged-in users can upload files to this bucket
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'chat-images');

-- Policy: Allow anyone to view images (public bucket)
-- Images can be viewed without authentication
CREATE POLICY "Anyone can view images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'chat-images');

-- Policy: Users can delete their own uploaded images (optional)
-- This allows users to remove images they uploaded
CREATE POLICY "Users can delete their own images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'chat-images' AND auth.uid()::text = (storage.foldername(name))[1]);
