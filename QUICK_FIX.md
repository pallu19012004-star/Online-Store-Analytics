# Quick Fix for AI Chat Error

## Error: "Missing Supabase admin environment variables"

This error occurs because the chat API was trying to use the admin client. I've fixed it to use the regular client instead.

## What Changed

- ✅ Changed from `createAdminClient()` to regular `supabase` client
- ✅ No longer requires `SUPABASE_SERVICE_ROLE_KEY` for chat
- ✅ Works with just `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## Required Environment Variables

Your `.env.local` file only needs:

```env
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
OPENAI_API_KEY=sk-your-openai-api-key
```

**You do NOT need `SUPABASE_SERVICE_ROLE_KEY` for the chat feature.**

## After the Fix

1. **Restart your dev server:**
   ```bash
   # Stop the server (Ctrl+C)
   npm run dev
   ```

2. **Test the chat:**
   - Go to `/chat`
   - Try: "I am david brown, can you tell me my registration date?"
   - It should work now!

## If You Still Get Errors

1. Make sure `.env.local` exists in the project root
2. Verify all three variables are set correctly
3. Check that you've restarted the dev server
4. Make sure you've run `sql/disable_rls.sql` or `sql/enable_public_read.sql` in Supabase


