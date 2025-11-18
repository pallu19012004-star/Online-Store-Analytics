# Supabase Setup Guide for E-Commerce Database

This guide will help you set up the E-Commerce database on Supabase.

## Prerequisites

1. A Supabase account (sign up at [supabase.com](https://supabase.com))
2. A Supabase project created

## Step 1: Create a Supabase Project

1. Go to [app.supabase.com](https://app.supabase.com)
2. Click "New Project"
3. Fill in your project details:
   - **Name**: E-Commerce Platform (or your preferred name)
   - **Database Password**: Choose a strong password (save it securely)
   - **Region**: Choose the closest region to your users
4. Click "Create new project" and wait for the project to be provisioned (2-3 minutes)

## Step 2: Access the SQL Editor

1. In your Supabase project dashboard, navigate to the **SQL Editor** from the left sidebar
2. Click "New query" to create a new SQL query

## Step 3: Create the Database Schema

1. Open the `schema.sql` file from this repository
2. Copy the entire contents
3. Paste it into the Supabase SQL Editor
4. Click "Run" or press `Ctrl+Enter` (Windows) / `Cmd+Enter` (Mac)
5. Wait for the execution to complete - you should see "Success. No rows returned"

## Step 4: Insert Sample Data

1. Open the `sample_data.sql` file from this repository
2. Copy the entire contents
3. Paste it into a new query in the Supabase SQL Editor
4. Click "Run"
5. Verify the data was inserted successfully

## Step 5: Verify the Setup

Run this query to verify your tables were created:

```sql
SELECT 
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns 
     WHERE table_name = t.table_name) AS column_count
FROM information_schema.tables t
WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

You should see tables like:
- categories
- products
- customers
- addresses
- orders
- order_items
- payments
- reviews
- coupons

## Step 6: Test the Queries

1. Open `complex_queries.sql` or `insights_queries.sql`
2. Copy and run individual queries to test them
3. Verify the results match expectations

## Step 7: Set Up Row Level Security (RLS) - Optional

If you want to secure your data, you can enable Row Level Security:

```sql
-- Enable RLS on sensitive tables
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- Create policies (example - adjust based on your needs)
CREATE POLICY "Users can view their own orders"
    ON orders FOR SELECT
    USING (auth.uid()::text = customer_id::text);
```

## Step 8: Create Database Functions (Optional)

You can create helper functions for common operations:

```sql
-- Function to calculate order total
CREATE OR REPLACE FUNCTION calculate_order_total(order_uuid UUID)
RETURNS DECIMAL AS $$
DECLARE
    total DECIMAL;
BEGIN
    SELECT 
        COALESCE(SUM(oi.line_total), 0) + 
        COALESCE(o.tax_amount, 0) + 
        COALESCE(o.shipping_cost, 0) - 
        COALESCE(o.discount_amount, 0)
    INTO total
    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_id = order_uuid;
    
    RETURN total;
END;
$$ LANGUAGE plpgsql;
```

## Step 9: Set Up API Access (Optional)

Supabase automatically creates REST APIs for your tables. You can:

1. Go to **Settings** > **API** in your Supabase dashboard
2. Find your **Project URL** and **anon/public key**
3. Use these to access your database via REST API

Example API call:
```javascript
const { createClient } = require('@supabase/supabase-js')

const supabase = createClient(
  'YOUR_PROJECT_URL',
  'YOUR_ANON_KEY'
)

// Fetch products
const { data, error } = await supabase
  .from('products')
  .select('*')
```

## Step 10: Set Up Database Backups

1. Go to **Settings** > **Database** in your Supabase dashboard
2. Enable **Point-in-time Recovery** (available on Pro plan and above)
3. Set up automated backups if needed

## Connection String

To connect to your Supabase database from external tools:

1. Go to **Settings** > **Database**
2. Find the **Connection string** section
3. Copy the connection string (URI format or parameters)

Example connection string:
```
postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
```

## Useful Supabase Features

### 1. Table Editor
- View and edit data directly in the Supabase dashboard
- Go to **Table Editor** from the left sidebar

### 2. Database Functions
- Create stored procedures and functions
- Access via SQL Editor or REST API

### 3. Real-time Subscriptions
- Subscribe to database changes in real-time
- Useful for live dashboards

### 4. Database Webhooks
- Trigger webhooks on database events
- Set up in **Database** > **Webhooks**

## Troubleshooting

### Issue: UUID extension not found
**Solution**: Supabase should have `uuid-ossp` enabled by default. If not, run:
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### Issue: Foreign key constraint errors
**Solution**: Make sure you're inserting data in the correct order:
1. Categories first
2. Products
3. Customers
4. Addresses
5. Orders
6. Order Items
7. Payments
8. Reviews

### Issue: Permission denied
**Solution**: Make sure you're using the correct database role. In Supabase SQL Editor, you should have full access.

## Next Steps

1. Explore the `complex_queries.sql` file for advanced SQL operations
2. Run queries from `insights_queries.sql` for business insights
3. Set up your application to connect to Supabase
4. Consider setting up authentication if needed
5. Configure Row Level Security policies based on your requirements

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Supabase SQL Editor Guide](https://supabase.com/docs/guides/database/tables)


