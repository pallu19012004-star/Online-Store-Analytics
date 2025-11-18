# SQL Query Quick Reference

A quick reference guide for all queries in this project.

## 📊 Complex Queries (`complex_queries.sql`)

### Query 1: Customer Order History with Product Details
**Purpose**: Get complete order history for customers with product details  
**Uses**: Multiple INNER JOINs  
**Returns**: Customer info, order details, product info, category

### Query 2: Customer Lifetime Value Analysis
**Purpose**: Calculate and segment customers by CLV  
**Uses**: CTEs, CASE statements, aggregations  
**Returns**: Customer segments (VIP, Premium, Regular, New) with metrics

### Query 3: Product Sales Ranking
**Purpose**: Rank products by sales with percentiles  
**Uses**: Window functions (RANK, PERCENT_RANK, LAG)  
**Returns**: Product rankings, percentiles, revenue differences

### Query 4: Monthly Revenue Trends with Growth
**Purpose**: Calculate monthly revenue with MoM growth  
**Uses**: CTEs, Window functions (LAG), date functions  
**Returns**: Monthly revenue, growth percentages, order counts

### Query 5: Product Performance Analysis
**Purpose**: Comprehensive product metrics  
**Uses**: Multiple CTEs, LEFT JOINs, aggregations  
**Returns**: Sales, reviews, inventory status, product classification

### Query 6: Customer Purchase Patterns
**Purpose**: Analyze customer behavior  
**Uses**: Window functions (LAG, NTILE), aggregations  
**Returns**: Purchase frequency, spending patterns, quartiles

### Query 7: Category Hierarchy (Recursive)
**Purpose**: Navigate category tree structure  
**Uses**: Recursive CTE  
**Returns**: Full category hierarchy with levels

### Query 8: Top Customers by Category
**Purpose**: Find top customers per product category  
**Uses**: CTEs, Window functions (ROW_NUMBER)  
**Returns**: Top 3 customers per category

### Query 9: Running Totals & Moving Averages
**Purpose**: Daily sales with trend analysis  
**Uses**: Window functions (SUM OVER, AVG OVER)  
**Returns**: Daily revenue, running totals, moving averages

### Query 10: Payment Method Analysis
**Purpose**: Payment statistics and success rates  
**Uses**: Aggregations, CASE statements, window functions  
**Returns**: Payment method performance metrics

## 💡 Insights Queries (`insights_queries.sql`)

### Customer Spending Insights

#### Query 1: Top 10 Customers by Total Spending
**Returns**: Top customers with order counts, spending, and tier classification

#### Query 2: Customer Spending Distribution by Tier
**Returns**: Customer count and revenue by tier (VIP, Premium, Regular, New)

#### Query 3: Customer Purchase Frequency Analysis
**Returns**: Average days between orders, frequency categories

#### Query 4: Customer Lifetime Value (CLV) with Projections
**Returns**: Historical CLV, monthly revenue rate, projected annual/3-year CLV

### Revenue Trends Insights

#### Query 5: Monthly Revenue Trends with YoY Comparison
**Returns**: Monthly revenue, MoM growth, YoY growth percentages

#### Query 6: Daily Revenue Trends with Moving Averages
**Returns**: Daily revenue, cumulative totals, 7-day and 30-day moving averages, z-scores

#### Query 7: Revenue by Product Category
**Returns**: Category revenue, order counts, units sold, revenue percentages

#### Query 8: Revenue by Order Status
**Returns**: Revenue breakdown by order status (pending, shipped, delivered, etc.)

### Product Performance Insights

#### Query 9: Top Performing Products by Revenue
**Returns**: Products ranked by revenue with profit margins, ratings, stock status

#### Query 10: Product Performance with Sales Velocity
**Returns**: Sales patterns (stable/volatile), monthly averages, review metrics

#### Query 11: Product Conversion Rate
**Returns**: Order frequency, unique customers, conversion metrics

#### Query 12: Product Profitability Analysis
**Returns**: Profit per unit, total profit, profit margins, potential stock profit

#### Query 13: Best and Worst Performing Products by Rating
**Returns**: Rating distributions, positive review percentages, sales data

## 🎯 Query Use Cases

### For Customer Analysis
- Use: Query 2 (CLV), Query 6 (Purchase Patterns), Insights Query 1-4
- Purpose: Understand customer behavior, segment customers, identify high-value customers

### For Revenue Analysis
- Use: Query 4 (Monthly Trends), Query 9 (Daily Trends), Insights Query 5-8
- Purpose: Track revenue, identify trends, forecast growth

### For Product Management
- Use: Query 3 (Product Rankings), Query 5 (Product Performance), Insights Query 9-13
- Purpose: Identify best sellers, manage inventory, analyze profitability

### For Marketing
- Use: Query 2 (Customer Segments), Query 8 (Top Customers by Category), Insights Query 1-4
- Purpose: Target campaigns, identify opportunities, measure effectiveness

## 🔧 Query Modifications

### Filter by Date Range
Add to WHERE clause:
```sql
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
```

### Filter by Category
Add JOIN and WHERE:
```sql
INNER JOIN categories cat ON p.category_id = cat.category_id
WHERE cat.category_name = 'Electronics'
```

### Limit Results
Add at end:
```sql
ORDER BY total_revenue DESC
LIMIT 20;
```

### Group by Time Period
Modify DATE_TRUNC:
```sql
DATE_TRUNC('week', o.order_date) AS period  -- Weekly
DATE_TRUNC('day', o.order_date) AS period   -- Daily
DATE_TRUNC('quarter', o.order_date) AS period  -- Quarterly
```

## 📈 Performance Tips

1. **Use Indexes**: All foreign keys and common filter columns are indexed
2. **Limit Results**: Use LIMIT for large result sets
3. **Filter Early**: Add WHERE clauses before JOINs when possible
4. **Select Specific Columns**: Avoid SELECT * in production
5. **Use EXPLAIN ANALYZE**: Check query execution plans

## 🔍 Common Patterns

### Running Total
```sql
SUM(column) OVER (ORDER BY date_column)
```

### Moving Average
```sql
AVG(column) OVER (ORDER BY date_column ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
```

### Rank with Ties
```sql
RANK() OVER (PARTITION BY category ORDER BY revenue DESC)
```

### Previous Value
```sql
LAG(column) OVER (ORDER BY date_column)
```

### Percentile
```sql
PERCENT_RANK() OVER (ORDER BY revenue)
```


