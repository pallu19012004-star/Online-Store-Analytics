# E-Commerce Platform - Next.js Project

A complete Next.js application with Supabase integration for an e-commerce platform.

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ installed
- A Supabase account and project
- npm or yarn package manager

### Installation

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Set up environment variables:**
   ```bash
   cp .env.local.example .env.local
   ```
   
   Then edit `.env.local` and add your Supabase credentials:
   - `NEXT_PUBLIC_SUPABASE_URL` - Your Supabase project URL
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Your Supabase anon key
   - `SUPABASE_SERVICE_ROLE_KEY` - Your Supabase service role key (optional, for admin operations)

3. **Set up the database:**
   - Go to your Supabase project dashboard
   - Open the SQL Editor
   - Run `sql/schema.sql` to create all tables
   - Run `sql/sample_data.sql` to insert sample data

4. **Run the development server:**
   ```bash
   npm run dev
   ```

5. **Open your browser:**
   Navigate to [http://localhost:3000](http://localhost:3000)

## 📁 Project Structure

```
.
├── app/                    # Next.js App Router pages
│   ├── page.tsx           # Dashboard home page
│   ├── products/          # Products page
│   ├── customers/         # Customers page
│   ├── orders/            # Orders page
│   ├── insights/          # Business insights page
│   └── setup/             # Database setup instructions
├── lib/                   # Utility functions
│   ├── supabase.ts        # Supabase client (client-side)
│   └── supabase-server.ts # Supabase admin client (server-side)
├── sql/                   # SQL files
│   ├── schema.sql         # Database schema
│   ├── sample_data.sql    # Sample data
│   ├── complex_queries.sql # Advanced SQL queries
│   └── insights_queries.sql # Business insights queries
├── .env.local.example     # Environment variables template
└── package.json           # Dependencies
```

## 🎯 Features

### Pages

- **Dashboard** (`/`) - Overview with key statistics
- **Products** (`/products`) - Product catalog with categories
- **Customers** (`/customers`) - Customer list with spending data
- **Orders** (`/orders`) - Order history and status
- **Insights** (`/insights`) - Business analytics and trends
- **Setup** (`/setup`) - Database setup instructions

### Database Features

- Complete relational database schema
- Sample data for testing
- Advanced SQL queries with:
  - Multiple JOINs
  - Common Table Expressions (CTEs)
  - Window Functions
  - Complex Aggregations

## 🔧 Configuration

### Environment Variables

Create a `.env.local` file with:

```env
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### Supabase Setup

1. Create a project at [supabase.com](https://supabase.com)
2. Get your project URL and API keys from Settings > API
3. Run the SQL files in the Supabase SQL Editor:
   - First: `sql/schema.sql`
   - Then: `sql/sample_data.sql`

## 📊 SQL Files

All SQL files are located in the `sql/` directory:

- **schema.sql** - Creates all database tables, indexes, views, and triggers
- **sample_data.sql** - Inserts sample data for testing
- **complex_queries.sql** - Advanced SQL queries demonstrating CTEs, window functions, etc.
- **insights_queries.sql** - Business insights queries for analytics

## 🛠️ Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

### Tech Stack

- **Next.js 14** - React framework with App Router
- **TypeScript** - Type safety
- **Supabase** - Backend-as-a-Service
- **PostgreSQL** - Database (via Supabase)

## 📝 Usage

### Viewing Data

Navigate to different pages to view:
- Products and their categories
- Customer information and spending
- Order history and status
- Business insights and analytics

### Running SQL Queries

You can run the SQL queries from `sql/complex_queries.sql` and `sql/insights_queries.sql` directly in the Supabase SQL Editor for advanced analytics.

## 🔒 Security Notes

- Never commit `.env.local` to version control
- The `SUPABASE_SERVICE_ROLE_KEY` should only be used in server-side code
- Client-side code uses the anon key which respects Row Level Security (RLS)

## 🐛 Troubleshooting

### Database Connection Issues

- Verify your Supabase URL and keys are correct
- Check that you've run `schema.sql` in Supabase
- Ensure your Supabase project is active

### No Data Showing

- Make sure you've run `sample_data.sql` in Supabase
- Check the browser console for errors
- Verify your environment variables are set correctly

### Build Errors

- Make sure all dependencies are installed: `npm install`
- Check that TypeScript types are correct
- Verify Next.js version compatibility

## 📚 Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [SQL Queries Reference](./QUERY_REFERENCE.md)
- [Supabase Setup Guide](./supabase_setup.md)

## 🤝 Contributing

Feel free to:
- Add new features
- Improve existing pages
- Enhance SQL queries
- Fix bugs

## 📄 License

This project is provided as-is for educational and commercial use.


