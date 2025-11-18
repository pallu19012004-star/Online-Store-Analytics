# 🚀 Quick Start Guide

Get your E-Commerce platform running in 5 minutes!

## 1️⃣ Install Dependencies

```bash
npm install
```

## 2️⃣ Set Up Supabase

1. Create account at [supabase.com](https://supabase.com)
2. Create a new project
3. Get your API keys from Settings > API

## 3️⃣ Configure Environment

Create `.env.local` file:

```env
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## 4️⃣ Set Up Database

1. Open Supabase SQL Editor
2. Run `sql/schema.sql` (creates tables)
3. Run `sql/sample_data.sql` (inserts data)

## 5️⃣ Run the App

```bash
npm run dev
```

Visit [http://localhost:3000](http://localhost:3000)

## ✅ Done!

Your e-commerce platform is ready! Check out:
- Dashboard with stats
- Products catalog
- Customer management
- Order tracking
- Business insights

For detailed setup, see [SETUP_GUIDE.md](./SETUP_GUIDE.md)


