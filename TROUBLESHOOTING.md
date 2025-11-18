# Troubleshooting Guide

## Problem: No Data Showing / Connection Issues

If you've connected Supabase but aren't seeing any data, follow these steps:

### Step 1: Check Environment Variables

1. Make sure `.env.local` exists in your project root
2. Verify it contains:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
   ```
3. **Restart your dev server** after changing environment variables:
   ```bash
   # Stop the server (Ctrl+C)
   npm run dev
   ```

### Step 2: Use the Debug Page

1. Visit `http://localhost:3000/debug` in your browser
2. This will show you:
   - Environment variable status
   - Connection status
   - Which tables exist
   - Specific error messages

### Step 3: Check Database Setup

#### Have you run the SQL files?

1. Go to Supabase Dashboard → SQL Editor
2. Run `sql/schema.sql` - This creates all tables
3. Run `sql/sample_data.sql` - This inserts sample data
4. **IMPORTANT:** Run one of these to allow data access:
   - `sql/disable_rls.sql` (for testing - disables security)
   - `sql/enable_public_read.sql` (better - enables public read access)

### Step 4: Row Level Security (RLS) Issue

**This is the most common problem!**

Supabase enables Row Level Security by default, which blocks all access unless you:
- Disable RLS (for testing), OR
- Create policies to allow access

#### Quick Fix - Disable RLS (Testing Only):

1. Go to Supabase SQL Editor
2. Run `sql/disable_rls.sql`
3. Refresh your Next.js app

#### Better Fix - Enable Public Read Access:

1. Go to Supabase SQL Editor
2. Run `sql/enable_public_read.sql`
3. This keeps RLS enabled but allows public read access
4. Refresh your Next.js app

### Step 5: Verify Tables Exist

Run this in Supabase SQL Editor:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
```

You should see:
- categories
- products
- customers
- addresses
- orders
- order_items
- payments
- reviews
- coupons

### Step 6: Verify Data Exists

Run this in Supabase SQL Editor:

```sql
SELECT 
    'products' as table_name, COUNT(*) as count FROM products
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;
```

You should see:
- 10 products
- 8 customers
- 15 orders

If counts are 0, you need to run `sql/sample_data.sql`.

## Common Error Messages

### "relation does not exist"
- **Cause:** Tables haven't been created
- **Fix:** Run `sql/schema.sql` in Supabase

### "permission denied for table"
- **Cause:** Row Level Security is blocking access
- **Fix:** Run `sql/disable_rls.sql` or `sql/enable_public_read.sql`

### "Missing Supabase environment variables"
- **Cause:** `.env.local` is missing or incorrect
- **Fix:** Create `.env.local` with your Supabase credentials

### "Failed to fetch" or Network errors
- **Cause:** Wrong Supabase URL or network issue
- **Fix:** Verify your URL in Supabase Dashboard → Settings → API

## Quick Checklist

- [ ] `.env.local` file exists with correct values
- [ ] Dev server restarted after setting environment variables
- [ ] `sql/schema.sql` has been run in Supabase
- [ ] `sql/sample_data.sql` has been run in Supabase
- [ ] `sql/disable_rls.sql` OR `sql/enable_public_read.sql` has been run
- [ ] Tables exist (check in Supabase Table Editor)
- [ ] Data exists (check in Supabase Table Editor)
- [ ] Debug page shows connection successful

## Still Having Issues?

1. Check the browser console (F12) for errors
2. Check the terminal where `npm run dev` is running
3. Visit `/debug` page for detailed diagnostics
4. Verify your Supabase project is active (not paused)
5. Check Supabase Dashboard → Logs for database errors

## Testing the Connection

You can test the API connection directly:

```bash
# Test endpoint
curl http://localhost:3000/api/test
```

Or visit `http://localhost:3000/api/test` in your browser.


