# Complete Setup Guide

This guide will help you set up the entire Next.js E-Commerce platform with Supabase.

## Step 1: Prerequisites

- Node.js 18 or higher installed
- A Supabase account (sign up at [supabase.com](https://supabase.com))
- npm or yarn package manager

## Step 2: Install Dependencies

```bash
npm install
```

## Step 3: Set Up Supabase

### 3.1 Create a Supabase Project

1. Go to [app.supabase.com](https://app.supabase.com)
2. Click "New Project"
3. Fill in:
   - **Name**: E-Commerce Platform
   - **Database Password**: Choose a strong password (save it!)
   - **Region**: Choose closest to your users
4. Wait 2-3 minutes for project creation

### 3.2 Get Your API Keys

1. In your Supabase project, go to **Settings** > **API**
2. Copy:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon/public key** (starts with `eyJ...`)
   - **service_role key** (starts with `eyJ...`) - Keep this secret!

## Step 4: Configure Environment Variables

1. Copy the example file:
   ```bash
   cp .env.local.example .env.local
   ```

2. Edit `.env.local` and add your values:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=https://your-project-ref.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
   ```

## Step 5: Set Up the Database

### 5.1 Run Schema SQL

1. Go to Supabase Dashboard > **SQL Editor**
2. Click "New query"
3. Open `sql/schema.sql` from this project
4. Copy the entire contents
5. Paste into Supabase SQL Editor
6. Click "Run" (or press Ctrl+Enter)
7. Wait for "Success. No rows returned"

### 5.2 Insert Sample Data

1. In Supabase SQL Editor, create a new query
2. Open `sql/sample_data.sql` from this project
3. Copy the entire contents
4. Paste into Supabase SQL Editor
5. Click "Run"
6. Verify success

### 5.3 Verify Setup

Run this query in Supabase SQL Editor:

```sql
SELECT 
    'products' as table_name, COUNT(*) as count FROM products
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'categories', COUNT(*) FROM categories;
```

You should see:
- 5 categories
- 10 products
- 8 customers
- 15 orders

## Step 6: Run the Next.js Application

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Step 7: Test the Application

1. **Dashboard** - Should show statistics
2. **Products** - Should list 10 products
3. **Customers** - Should list 8 customers
4. **Orders** - Should show 15 orders
5. **Insights** - Should display analytics

## Troubleshooting

### "Missing Supabase environment variables"

- Make sure `.env.local` exists
- Check that all three variables are set
- Restart the dev server after changing `.env.local`

### "No data showing"

- Verify you ran `sql/schema.sql` first
- Then verify you ran `sql/sample_data.sql`
- Check Supabase SQL Editor for any errors

### "Database connection failed"

- Verify your Supabase URL is correct
- Check that your API keys are correct
- Ensure your Supabase project is active (not paused)

### Port 3000 already in use

```bash
# Use a different port
npm run dev -- -p 3001
```

## Next Steps

1. **Explore the SQL Queries**
   - Run queries from `sql/complex_queries.sql` in Supabase
   - Try queries from `sql/insights_queries.sql`

2. **Customize the Application**
   - Modify pages in `app/` directory
   - Add new features
   - Customize styling in `app/globals.css`

3. **Deploy to Production**
   - Build: `npm run build`
   - Deploy to Vercel, Netlify, or your preferred platform
   - Set environment variables in your hosting platform

## File Structure

```
.
├── app/                    # Next.js pages
│   ├── page.tsx           # Dashboard
│   ├── products/          # Products page
│   ├── customers/         # Customers page
│   ├── orders/            # Orders page
│   ├── insights/          # Analytics page
│   └── setup/             # Setup instructions
├── lib/                    # Utilities
│   ├── supabase.ts        # Client-side Supabase
│   └── supabase-server.ts # Server-side Supabase
├── sql/                    # SQL files
│   ├── schema.sql         # Database schema
│   ├── sample_data.sql    # Sample data
│   ├── complex_queries.sql # Advanced queries
│   └── insights_queries.sql # Business queries
└── .env.local             # Your environment variables (not in git)
```

## Support

- Check `PROJECT_README.md` for more details
- Review `supabase_setup.md` for Supabase-specific help
- See `QUERY_REFERENCE.md` for SQL query documentation


