-- =====================================================
-- Complex SQL Queries for E-Commerce Platform
-- =====================================================
-- This file contains advanced SQL queries demonstrating:
-- - Multiple JOIN operations
-- - Common Table Expressions (CTEs)
-- - Window Functions
-- - Complex Aggregations
-- =====================================================

-- =====================================================
-- 1. MULTIPLE JOINS: Customer Order History with Product Details
-- =====================================================
-- Get complete order history for customers with product details
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    o.order_id,
    o.order_date,
    o.status AS order_status,
    o.total_amount,
    p.product_name,
    p.sku,
    oi.quantity,
    oi.unit_price,
    oi.line_total,
    cat.category_name
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
WHERE o.payment_status = 'paid'
ORDER BY o.order_date DESC, c.customer_id;

-- =====================================================
-- 2. CTE: Customer Lifetime Value Analysis
-- =====================================================
-- Calculate customer lifetime value using CTEs
WITH customer_order_stats AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_revenue,
        AVG(o.total_amount) AS avg_order_value,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date,
        EXTRACT(EPOCH FROM (MAX(o.order_date) - MIN(o.order_date))) / 86400 AS customer_lifespan_days
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.payment_status = 'paid'
    GROUP BY c.customer_id, c.first_name, c.last_name
),
customer_segments AS (
    SELECT 
        customer_id,
        customer_name,
        total_orders,
        total_revenue,
        avg_order_value,
        customer_lifespan_days,
        CASE 
            WHEN total_revenue >= 2000 THEN 'VIP'
            WHEN total_revenue >= 1000 THEN 'Premium'
            WHEN total_revenue >= 500 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment,
        CASE 
            WHEN customer_lifespan_days > 0 
            THEN total_revenue / (customer_lifespan_days / 30.0)
            ELSE 0
        END AS monthly_revenue_rate
    FROM customer_order_stats
)
SELECT 
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_revenue), 2) AS avg_lifetime_value,
    ROUND(AVG(total_orders), 2) AS avg_orders,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value,
    ROUND(SUM(total_revenue), 2) AS segment_total_revenue
FROM customer_segments
GROUP BY customer_segment
ORDER BY avg_lifetime_value DESC;

-- =====================================================
-- 3. WINDOW FUNCTIONS: Product Sales Ranking and Trends
-- =====================================================
-- Rank products by sales using window functions
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        cat.category_name,
        p.price,
        SUM(oi.quantity) AS total_quantity_sold,
        SUM(oi.line_total) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS order_count,
        AVG(oi.unit_price) AS avg_selling_price
    FROM products p
    INNER JOIN categories cat ON p.category_id = cat.category_id
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id AND o.payment_status = 'paid'
    GROUP BY p.product_id, p.product_name, cat.category_name, p.price
),
ranked_products AS (
    SELECT 
        product_id,
        product_name,
        category_name,
        price,
        COALESCE(total_quantity_sold, 0) AS total_quantity_sold,
        COALESCE(total_revenue, 0) AS total_revenue,
        COALESCE(order_count, 0) AS order_count,
        avg_selling_price,
        RANK() OVER (ORDER BY COALESCE(total_revenue, 0) DESC) AS revenue_rank,
        RANK() OVER (PARTITION BY category_name ORDER BY COALESCE(total_revenue, 0) DESC) AS category_revenue_rank,
        RANK() OVER (ORDER BY COALESCE(total_quantity_sold, 0) DESC) AS quantity_rank,
        PERCENT_RANK() OVER (ORDER BY COALESCE(total_revenue, 0)) AS revenue_percentile,
        LAG(total_revenue) OVER (ORDER BY total_revenue DESC) AS prev_product_revenue
    FROM product_sales
)
SELECT 
    product_name,
    category_name,
    price,
    total_quantity_sold,
    total_revenue,
    order_count,
    revenue_rank,
    category_revenue_rank,
    quantity_rank,
    ROUND(revenue_percentile * 100, 2) AS revenue_percentile,
    ROUND(total_revenue - COALESCE(prev_product_revenue, 0), 2) AS revenue_diff_from_prev
FROM ranked_products
ORDER BY revenue_rank;

-- =====================================================
-- 4. COMPLEX AGGREGATION: Monthly Revenue Trends with Growth
-- =====================================================
-- Calculate monthly revenue with month-over-month growth
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) AS month,
        COUNT(DISTINCT o.order_id) AS order_count,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(o.subtotal) AS total_subtotal,
        SUM(o.tax_amount) AS total_tax,
        SUM(o.shipping_cost) AS total_shipping,
        SUM(o.discount_amount) AS total_discounts,
        SUM(o.total_amount) AS total_revenue,
        AVG(o.total_amount) AS avg_order_value
    FROM orders o
    WHERE o.payment_status = 'paid'
    GROUP BY DATE_TRUNC('month', o.order_date)
),
revenue_with_growth AS (
    SELECT 
        month,
        order_count,
        unique_customers,
        total_subtotal,
        total_tax,
        total_shipping,
        total_discounts,
        total_revenue,
        avg_order_value,
        LAG(total_revenue) OVER (ORDER BY month) AS prev_month_revenue,
        LAG(order_count) OVER (ORDER BY month) AS prev_month_orders
    FROM monthly_revenue
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') AS month,
    order_count,
    unique_customers,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND(total_discounts, 2) AS total_discounts,
    ROUND(
        CASE 
            WHEN prev_month_revenue > 0 
            THEN ((total_revenue - prev_month_revenue) / prev_month_revenue) * 100
            ELSE NULL
        END, 
        2
    ) AS revenue_growth_percent,
    ROUND(
        CASE 
            WHEN prev_month_orders > 0 
            THEN ((order_count - prev_month_orders)::DECIMAL / prev_month_orders) * 100
            ELSE NULL
        END, 
        2
    ) AS order_growth_percent,
    ROUND(total_revenue - COALESCE(prev_month_revenue, 0), 2) AS revenue_change
FROM revenue_with_growth
ORDER BY month;

-- =====================================================
-- 5. MULTIPLE CTEs WITH JOINS: Product Performance Analysis
-- =====================================================
-- Comprehensive product performance with reviews and sales
WITH product_sales_summary AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.line_total) AS revenue,
        COUNT(DISTINCT o.order_id) AS times_ordered,
        AVG(oi.unit_price) AS avg_selling_price
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id AND o.payment_status = 'paid'
    GROUP BY p.product_id, p.product_name
),
product_reviews_summary AS (
    SELECT 
        p.product_id,
        COUNT(r.review_id) AS review_count,
        AVG(r.rating) AS avg_rating,
        MIN(r.rating) AS min_rating,
        MAX(r.rating) AS max_rating
    FROM products p
    LEFT JOIN reviews r ON p.product_id = r.product_id
    GROUP BY p.product_id
),
product_inventory AS (
    SELECT 
        product_id,
        stock_quantity,
        CASE 
            WHEN stock_quantity = 0 THEN 'Out of Stock'
            WHEN stock_quantity < 10 THEN 'Low Stock'
            WHEN stock_quantity < 50 THEN 'Medium Stock'
            ELSE 'In Stock'
        END AS stock_status
    FROM products
)
SELECT 
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price,
    p.cost_price,
    ROUND(p.price - p.cost_price, 2) AS profit_margin,
    ROUND(((p.price - p.cost_price) / p.price) * 100, 2) AS profit_margin_percent,
    COALESCE(ps.units_sold, 0) AS units_sold,
    COALESCE(ps.revenue, 0) AS revenue,
    COALESCE(ps.times_ordered, 0) AS times_ordered,
    COALESCE(pr.review_count, 0) AS review_count,
    ROUND(COALESCE(pr.avg_rating, 0), 2) AS avg_rating,
    pi.stock_quantity,
    pi.stock_status,
    CASE 
        WHEN COALESCE(ps.revenue, 0) > 1000 AND COALESCE(pr.avg_rating, 0) >= 4.5 THEN 'Star Product'
        WHEN COALESCE(ps.revenue, 0) > 500 THEN 'Popular'
        WHEN COALESCE(ps.revenue, 0) > 0 THEN 'Active'
        ELSE 'New/Inactive'
    END AS product_status
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN product_sales_summary ps ON p.product_id = ps.product_id
LEFT JOIN product_reviews_summary pr ON p.product_id = pr.product_id
LEFT JOIN product_inventory pi ON p.product_id = pi.product_id
ORDER BY ps.revenue DESC NULLS LAST;

-- =====================================================
-- 6. WINDOW FUNCTIONS: Customer Purchase Patterns
-- =====================================================
-- Analyze customer purchase patterns with window functions
WITH customer_orders AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        o.order_id,
        o.order_date,
        o.total_amount,
        LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS prev_order_date,
        LAG(o.total_amount) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS prev_order_amount
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.payment_status = 'paid'
),
customer_metrics AS (
    SELECT 
        customer_id,
        customer_name,
        COUNT(*) AS order_count,
        SUM(total_amount) AS total_spent,
        AVG(total_amount) AS avg_order_value,
        MIN(total_amount) AS min_order_value,
        MAX(total_amount) AS max_order_value,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        EXTRACT(EPOCH FROM (MAX(order_date) - MIN(order_date))) / 86400 AS customer_lifespan_days,
        AVG(EXTRACT(EPOCH FROM (order_date - COALESCE(prev_order_date, order_date))) / 86400) AS avg_days_between_orders
    FROM customer_orders
    GROUP BY customer_id, customer_name
)
SELECT 
    customer_name,
    order_count,
    ROUND(total_spent, 2) AS total_spent,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND(min_order_value, 2) AS min_order_value,
    ROUND(max_order_value, 2) AS max_order_value,
    TO_CHAR(first_order_date, 'YYYY-MM-DD') AS first_order_date,
    TO_CHAR(last_order_date, 'YYYY-MM-DD') AS last_order_date,
    ROUND(customer_lifespan_days, 0) AS customer_lifespan_days,
    ROUND(COALESCE(avg_days_between_orders, 0), 1) AS avg_days_between_orders,
    CASE 
        WHEN customer_lifespan_days > 0 THEN ROUND(total_spent / (customer_lifespan_days / 30.0), 2)
        ELSE 0
    END AS monthly_spending_rate,
    NTILE(4) OVER (ORDER BY total_spent DESC) AS spending_quartile
FROM customer_metrics
ORDER BY total_spent DESC;

-- =====================================================
-- 7. RECURSIVE CTE: Category Hierarchy
-- =====================================================
-- Get full category hierarchy using recursive CTE
WITH RECURSIVE category_hierarchy AS (
    -- Base case: top-level categories
    SELECT 
        category_id,
        category_name,
        parent_category_id,
        0 AS level,
        category_name::TEXT AS hierarchy_path
    FROM categories
    WHERE parent_category_id IS NULL
    
    UNION ALL
    
    -- Recursive case: subcategories
    SELECT 
        c.category_id,
        c.category_name,
        c.parent_category_id,
        ch.level + 1,
        (ch.hierarchy_path || ' > ' || c.category_name)::TEXT
    FROM categories c
    INNER JOIN category_hierarchy ch ON c.parent_category_id = ch.category_id
)
SELECT 
    category_id,
    category_name,
    level,
    hierarchy_path,
    (SELECT COUNT(*) FROM products WHERE category_id = ch.category_id) AS product_count
FROM category_hierarchy ch
ORDER BY level, category_name;

-- =====================================================
-- 8. COMPLEX JOIN WITH SUBQUERY: Top Customers by Category
-- =====================================================
-- Find top customers for each product category
WITH category_customer_revenue AS (
    SELECT 
        cat.category_id,
        cat.category_name,
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(oi.line_total) AS category_revenue,
        COUNT(DISTINCT o.order_id) AS orders_in_category
    FROM categories cat
    INNER JOIN products p ON cat.category_id = p.category_id
    INNER JOIN order_items oi ON p.product_id = oi.product_id
    INNER JOIN orders o ON oi.order_id = o.order_id
    INNER JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.payment_status = 'paid'
    GROUP BY cat.category_id, cat.category_name, c.customer_id, c.first_name, c.last_name
),
ranked_customers AS (
    SELECT 
        category_id,
        category_name,
        customer_id,
        customer_name,
        category_revenue,
        orders_in_category,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY category_revenue DESC) AS rank_in_category
    FROM category_customer_revenue
)
SELECT 
    category_name,
    customer_name,
    ROUND(category_revenue, 2) AS category_revenue,
    orders_in_category,
    rank_in_category
FROM ranked_customers
WHERE rank_in_category <= 3
ORDER BY category_name, rank_in_category;

-- =====================================================
-- 9. WINDOW FUNCTIONS: Running Totals and Moving Averages
-- =====================================================
-- Calculate running totals and moving averages for daily sales
WITH daily_sales AS (
    SELECT 
        DATE(o.order_date) AS sale_date,
        COUNT(DISTINCT o.order_id) AS daily_orders,
        COUNT(DISTINCT o.customer_id) AS daily_customers,
        SUM(o.total_amount) AS daily_revenue,
        AVG(o.total_amount) AS avg_order_value
    FROM orders o
    WHERE o.payment_status = 'paid'
    GROUP BY DATE(o.order_date)
)
SELECT 
    sale_date,
    daily_orders,
    daily_customers,
    ROUND(daily_revenue, 2) AS daily_revenue,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND(SUM(daily_revenue) OVER (ORDER BY sale_date), 2) AS running_total_revenue,
    ROUND(AVG(daily_revenue) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7days,
    ROUND(AVG(daily_revenue) OVER (ORDER BY sale_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS moving_avg_30days,
    ROUND(
        (daily_revenue - LAG(daily_revenue) OVER (ORDER BY sale_date)) / 
        NULLIF(LAG(daily_revenue) OVER (ORDER BY sale_date), 0) * 100, 
        2
    ) AS day_over_day_change_percent
FROM daily_sales
ORDER BY sale_date;

-- =====================================================
-- 10. MULTIPLE AGGREGATIONS: Payment Method Analysis
-- =====================================================
-- Analyze payment methods with multiple aggregations
SELECT 
    p.payment_method,
    COUNT(DISTINCT p.payment_id) AS transaction_count,
    COUNT(DISTINCT p.order_id) AS order_count,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(p.amount) AS total_amount,
    AVG(p.amount) AS avg_transaction_amount,
    MIN(p.amount) AS min_amount,
    MAX(p.amount) AS max_amount,
    SUM(CASE WHEN p.status = 'completed' THEN p.amount ELSE 0 END) AS successful_amount,
    SUM(CASE WHEN p.status = 'failed' THEN p.amount ELSE 0 END) AS failed_amount,
    COUNT(CASE WHEN p.status = 'completed' THEN 1 END) AS successful_count,
    COUNT(CASE WHEN p.status = 'failed' THEN 1 END) AS failed_count,
    ROUND(
        COUNT(CASE WHEN p.status = 'completed' THEN 1 END)::DECIMAL / 
        COUNT(*) * 100, 
        2
    ) AS success_rate_percent,
    ROUND(
        SUM(p.amount) / SUM(SUM(p.amount)) OVER () * 100, 
        2
    ) AS percentage_of_total
FROM payments p
INNER JOIN orders o ON p.order_id = o.order_id
GROUP BY p.payment_method
ORDER BY total_amount DESC;


