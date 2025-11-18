# E-Commerce Platform Database

A comprehensive relational database design for an E-Commerce platform with advanced SQL queries, business insights, and Supabase integration.

## 📋 Table of Contents

- [Overview](#overview)
- [Database Schema](#database-schema)
- [Features](#features)
- [Setup Instructions](#setup-instructions)
- [File Structure](#file-structure)
- [SQL Queries](#sql-queries)
- [Business Insights](#business-insights)
- [Usage Examples](#usage-examples)
- [Technologies Used](#technologies-used)

## 🎯 Overview

This project provides a complete database solution for an E-Commerce platform, including:

- **Comprehensive Database Schema**: Well-normalized relational database with all essential e-commerce entities
- **Advanced SQL Queries**: Complex queries using JOINs, CTEs, Window Functions, and Aggregations
- **Business Insights**: Ready-to-use queries for customer spending, revenue trends, and product performance
- **Supabase Integration**: Full setup guide and configuration for Supabase deployment

## 🗄️ Database Schema

The database includes the following tables:

### Core Tables
- **categories**: Product categories with hierarchical support
- **products**: Product catalog with pricing and inventory
- **customers**: Customer information and registration data
- **addresses**: Customer billing and shipping addresses
- **orders**: Order headers with status and payment information
- **order_items**: Order line items with quantities and pricing
- **payments**: Payment transactions and methods
- **reviews**: Product reviews and ratings
- **coupons**: Discount codes and promotions

### Key Features
- ✅ UUID primary keys for all tables
- ✅ Foreign key constraints for data integrity
- ✅ Check constraints for data validation
- ✅ Indexes for query performance
- ✅ Triggers for automatic timestamp updates
- ✅ Views for common queries
- ✅ Support for hierarchical categories

## ✨ Features

### 1. Complex SQL Operations
- **Multiple JOINs**: Combine data from multiple tables efficiently
- **Common Table Expressions (CTEs)**: Organize complex queries with reusable subqueries
- **Window Functions**: Calculate rankings, running totals, and moving averages
- **Aggregations**: Group and summarize data with various aggregate functions
- **Recursive CTEs**: Navigate hierarchical data structures

### 2. Business Insights
- **Customer Spending Analysis**: Identify top customers, spending patterns, and lifetime value
- **Revenue Trends**: Monthly/daily revenue analysis with growth metrics
- **Product Performance**: Sales rankings, profitability, and inventory analysis
- **Purchase Patterns**: Customer behavior and frequency analysis

### 3. Supabase Integration
- Complete setup guide for Supabase
- Configuration files for easy integration
- Sample connection code

## 🚀 Setup Instructions

### Prerequisites
- A Supabase account ([sign up here](https://supabase.com))
- Basic knowledge of SQL

### Quick Start

1. **Create a Supabase Project**
   - Go to [app.supabase.com](https://app.supabase.com)
   - Create a new project
   - Note your project URL and API keys

2. **Set Up the Database Schema**
   ```sql
   -- In Supabase SQL Editor, run:
   -- 1. Copy and execute schema.sql
   -- 2. Copy and execute sample_data.sql
   ```

3. **Verify Installation**
   ```sql
   SELECT COUNT(*) FROM products;
   SELECT COUNT(*) FROM customers;
   SELECT COUNT(*) FROM orders;
   ```

For detailed setup instructions, see [supabase_setup.md](./supabase_setup.md)

## 📁 File Structure

```
.
├── schema.sql              # Database schema with all tables, indexes, and views
├── sample_data.sql         # Sample data for testing and demonstration
├── complex_queries.sql    # Advanced SQL queries (JOINs, CTEs, Window Functions)
├── insights_queries.sql   # Business insights queries
├── supabase_setup.md      # Detailed Supabase setup guide
├── supabase_config.js     # Supabase configuration template
└── README.md              # This file
```

## 📊 SQL Queries

### Complex Queries (`complex_queries.sql`)

1. **Multiple JOINs**: Customer order history with product details
2. **CTE - Customer Lifetime Value**: Calculate and segment customers by CLV
3. **Window Functions - Product Rankings**: Rank products by sales with percentiles
4. **Monthly Revenue Trends**: Revenue analysis with month-over-month growth
5. **Product Performance Analysis**: Comprehensive product metrics
6. **Customer Purchase Patterns**: Analyze customer behavior with window functions
7. **Recursive CTE - Category Hierarchy**: Navigate category tree structure
8. **Top Customers by Category**: Find best customers per product category
9. **Running Totals & Moving Averages**: Daily sales with trend analysis
10. **Payment Method Analysis**: Payment statistics and success rates

### Insights Queries (`insights_queries.sql`)

#### Customer Spending Insights
- Top 10 customers by total spending
- Customer spending distribution by tier
- Purchase frequency analysis
- Customer Lifetime Value (CLV) with projections

#### Revenue Trends Insights
- Monthly revenue trends with YoY comparison
- Daily revenue with moving averages
- Revenue by product category
- Revenue by order status

#### Product Performance Insights
- Top performing products by revenue
- Product sales velocity analysis
- Product conversion rates
- Product profitability analysis
- Best/worst products by ratings

## 💡 Usage Examples

### Example 1: Get Top Customers
```sql
-- Run from insights_queries.sql
SELECT 
    customer_name,
    total_orders,
    total_spent,
    customer_tier
FROM (
    -- Query from insights_queries.sql, query #1
) LIMIT 10;
```

### Example 2: Monthly Revenue Growth
```sql
-- Run from insights_queries.sql
SELECT 
    month,
    total_revenue,
    mom_growth_percent,
    yoy_growth_percent
FROM (
    -- Query from insights_queries.sql, query #5
);
```

### Example 3: Product Performance
```sql
-- Run from insights_queries.sql
SELECT 
    product_name,
    total_revenue,
    total_profit,
    profit_margin_percent
FROM (
    -- Query from insights_queries.sql, query #9
) ORDER BY total_revenue DESC;
```

### Example 4: Using Supabase Client (JavaScript)
```javascript
const { createClient } = require('@supabase/supabase-js');
const { supabaseConfig } = require('./supabase_config');

const supabase = createClient(
  supabaseConfig.url,
  supabaseConfig.anonKey
);

// Get top products
async function getTopProducts() {
  const { data, error } = await supabase
    .from('products')
    .select(`
      product_name,
      price,
      stock_quantity,
      categories(category_name)
    `)
    .eq('is_active', true)
    .order('price', { ascending: false })
    .limit(10);
  
  return data;
}

// Run custom SQL query
async function getCustomerInsights() {
  const { data, error } = await supabase.rpc('get_customer_insights');
  return data;
}
```

## 🔍 Key SQL Concepts Demonstrated

### JOINs
- INNER JOIN: Get matching records from multiple tables
- LEFT JOIN: Include all records from left table
- Multiple table joins for complex relationships

### Common Table Expressions (CTEs)
- Organize complex queries
- Reusable subqueries
- Recursive CTEs for hierarchical data

### Window Functions
- `RANK()`: Rank rows within partitions
- `LAG()` / `LEAD()`: Access previous/next row values
- `SUM() OVER()`: Running totals
- `AVG() OVER()`: Moving averages
- `PERCENT_RANK()`: Percentile rankings
- `NTILE()`: Divide rows into buckets

### Aggregations
- `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`
- `GROUP BY` with multiple columns
- `HAVING` for filtered aggregations
- Conditional aggregations with `CASE`

## 🛠️ Technologies Used

- **PostgreSQL**: Database engine (via Supabase)
- **Supabase**: Backend-as-a-Service platform
- **SQL**: Query language for data operations
- **UUID**: Unique identifier generation

## 📈 Business Use Cases

### 1. Customer Analytics
- Identify high-value customers
- Segment customers by spending behavior
- Analyze purchase frequency and patterns
- Calculate customer lifetime value

### 2. Revenue Analysis
- Track revenue trends over time
- Identify growth opportunities
- Analyze revenue by category/product
- Monitor order status and payment flows

### 3. Product Management
- Identify best-selling products
- Analyze product profitability
- Monitor inventory levels
- Track product ratings and reviews

### 4. Marketing Insights
- Customer segmentation for targeted campaigns
- Product performance for inventory decisions
- Revenue trends for forecasting
- Category analysis for merchandising

## 🔒 Security Considerations

When deploying to production:

1. **Enable Row Level Security (RLS)** on sensitive tables
2. **Use environment variables** for API keys
3. **Implement proper authentication** for API access
4. **Set up database backups** regularly
5. **Review and restrict** database user permissions

See `supabase_setup.md` for RLS examples.

## 📝 Notes

- All monetary values use `DECIMAL(10, 2)` for precision
- UUIDs are used for all primary keys
- Timestamps include timezone information
- Sample data is provided for testing
- All queries are optimized for PostgreSQL/Supabase

## 🤝 Contributing

Feel free to:
- Add more complex queries
- Improve existing queries
- Add more business insights
- Enhance documentation
- Report issues or suggest improvements

## 📄 License

This project is provided as-is for educational and commercial use.

## 🔗 Resources

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL Window Functions Guide](https://www.postgresql.org/docs/current/tutorial-window.html)
- [CTE Documentation](https://www.postgresql.org/docs/current/queries-with.html)

## 📧 Support

For questions or issues:
1. Check the `supabase_setup.md` for setup help
2. Review SQL query comments for explanations
3. Consult Supabase documentation for platform-specific issues

---

**Built with ❤️ for E-Commerce Analytics**


#   O n l i n e - S t o r e - A n a l y t i c s 
 
 #   O n l i n e - S t o r e - A n a l y t i c s 
 
 
