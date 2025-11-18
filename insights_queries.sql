-- =====================================================
-- Business Insights Queries
-- =====================================================
-- This file contains focused queries for business insights:
-- - Customer Spending Analysis
-- - Revenue Trends Analysis
-- - Product Performance Analysis
-- =====================================================

-- =====================================================
-- CUSTOMER SPENDING INSIGHTS
-- =====================================================

-- 1. Top 10 Customers by Total Spending
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    MIN(o.order_date) AS first_purchase_date,
    MAX(o.order_date) AS last_purchase_date,
    EXTRACT(EPOCH FROM (MAX(o.order_date) - MIN(o.order_date))) / 86400 AS customer_lifespan_days,
    CASE 
        WHEN SUM(o.total_amount) >= 2000 THEN 'VIP'
        WHEN SUM(o.total_amount) >= 1000 THEN 'Premium'
        WHEN SUM(o.total_amount) >= 500 THEN 'Regular'
        ELSE 'New'
    END AS customer_tier
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.payment_status = 'paid'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC
LIMIT 10;

-- 2. Customer Spending Distribution by Tier
WITH customer_spending AS (
    SELECT 
        c.customer_id,
        SUM(o.total_amount) AS total_spent,
        CASE 
            WHEN SUM(o.total_amount) >= 2000 THEN 'VIP'
            WHEN SUM(o.total_amount) >= 1000 THEN 'Premium'
            WHEN SUM(o.total_amount) >= 500 THEN 'Regular'
            ELSE 'New'
        END AS customer_tier
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.payment_status = 'paid'
    GROUP BY c.customer_id
)
SELECT 
    customer_tier,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spent), 2) AS avg_spending,
    ROUND(MIN(total_spent), 2) AS min_spending,
    ROUND(MAX(total_spent), 2) AS max_spending,
    ROUND(SUM(total_spent), 2) AS tier_total_revenue,
    ROUND(SUM(total_spent) / SUM(SUM(total_spent)) OVER () * 100, 2) AS revenue_percentage
FROM customer_spending
GROUP BY customer_tier
ORDER BY 
    CASE customer_tier
        WHEN 'VIP' THEN 1
        WHEN 'Premium' THEN 2
        WHEN 'Regular' THEN 3
        WHEN 'New' THEN 4
    END;

-- 3. Customer Purchase Frequency Analysis
WITH customer_order_intervals AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS prev_order_date,
        EXTRACT(EPOCH FROM (o.order_date - LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date))) / 86400 AS days_between_orders
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.payment_status = 'paid'
),
customer_frequency_stats AS (
    SELECT 
        customer_id,
        customer_name,
        COUNT(*) AS total_orders,
        AVG(days_between_orders) AS avg_days_between_orders,
        MIN(days_between_orders) AS min_days_between_orders,
        MAX(days_between_orders) AS max_days_between_orders
    FROM customer_order_intervals
    WHERE days_between_orders IS NOT NULL
    GROUP BY customer_id, customer_name
)
SELECT 
    customer_name,
    total_orders,
    ROUND(avg_days_between_orders, 1) AS avg_days_between_orders,
    ROUND(min_days_between_orders, 1) AS min_days_between_orders,
    ROUND(max_days_between_orders, 1) AS max_days_between_orders,
    CASE 
        WHEN avg_days_between_orders <= 30 THEN 'Frequent (Monthly)'
        WHEN avg_days_between_orders <= 60 THEN 'Regular (Bi-monthly)'
        WHEN avg_days_between_orders <= 90 THEN 'Occasional (Quarterly)'
        ELSE 'Infrequent'
    END AS purchase_frequency_category
FROM customer_frequency_stats
ORDER BY avg_days_between_orders;

-- 4. Customer Lifetime Value (CLV) with Projections
WITH customer_metrics AS (
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
)
SELECT 
    customer_name,
    total_orders,
    ROUND(total_revenue, 2) AS historical_clv,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND(customer_lifespan_days, 0) AS customer_lifespan_days,
    ROUND(
        CASE 
            WHEN customer_lifespan_days > 0 
            THEN total_revenue / (customer_lifespan_days / 30.0)
            ELSE 0
        END, 
        2
    ) AS monthly_revenue_rate,
    ROUND(
        CASE 
            WHEN customer_lifespan_days > 0 
            THEN (total_revenue / (customer_lifespan_days / 30.0)) * 12
            ELSE 0
        END, 
        2
    ) AS projected_annual_value,
    CASE 
        WHEN customer_lifespan_days > 0 AND (total_revenue / (customer_lifespan_days / 30.0)) > 0
        THEN ROUND((total_revenue / (customer_lifespan_days / 30.0)) * 12 * 3, 2)  -- 3-year projection
        ELSE 0
    END AS projected_3yr_clv
FROM customer_metrics
ORDER BY historical_clv DESC;

-- =====================================================
-- REVENUE TRENDS INSIGHTS
-- =====================================================

-- 5. Monthly Revenue Trends with Year-over-Year Comparison
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) AS month,
        EXTRACT(YEAR FROM o.order_date) AS year,
        EXTRACT(MONTH FROM o.order_date) AS month_num,
        COUNT(DISTINCT o.order_id) AS order_count,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(o.total_amount) AS total_revenue,
        SUM(o.subtotal) AS subtotal,
        SUM(o.tax_amount) AS tax_amount,
        SUM(o.shipping_cost) AS shipping_cost,
        SUM(o.discount_amount) AS discount_amount,
        AVG(o.total_amount) AS avg_order_value
    FROM orders o
    WHERE o.payment_status = 'paid'
    GROUP BY DATE_TRUNC('month', o.order_date), EXTRACT(YEAR FROM o.order_date), EXTRACT(MONTH FROM o.order_date)
),
revenue_with_growth AS (
    SELECT 
        month,
        year,
        month_num,
        order_count,
        unique_customers,
        total_revenue,
        subtotal,
        tax_amount,
        shipping_cost,
        discount_amount,
        avg_order_value,
        LAG(total_revenue) OVER (ORDER BY month) AS prev_month_revenue,
        LAG(total_revenue) OVER (PARTITION BY month_num ORDER BY year) AS prev_year_same_month_revenue
    FROM monthly_revenue
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') AS month,
    order_count,
    unique_customers,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(subtotal, 2) AS subtotal,
    ROUND(tax_amount, 2) AS tax_amount,
    ROUND(shipping_cost, 2) AS shipping_cost,
    ROUND(discount_amount, 2) AS discount_amount,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND(
        CASE 
            WHEN prev_month_revenue > 0 
            THEN ((total_revenue - prev_month_revenue) / prev_month_revenue) * 100
            ELSE NULL
        END, 
        2
    ) AS mom_growth_percent,
    ROUND(
        CASE 
            WHEN prev_year_same_month_revenue > 0 
            THEN ((total_revenue - prev_year_same_month_revenue) / prev_year_same_month_revenue) * 100
            ELSE NULL
        END, 
        2
    ) AS yoy_growth_percent,
    ROUND(total_revenue - COALESCE(prev_month_revenue, 0), 2) AS mom_revenue_change
FROM revenue_with_growth
ORDER BY month;

-- 6. Daily Revenue Trends with Moving Averages
WITH daily_revenue AS (
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
    ROUND(SUM(daily_revenue) OVER (ORDER BY sale_date), 2) AS cumulative_revenue,
    ROUND(AVG(daily_revenue) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7days,
    ROUND(AVG(daily_revenue) OVER (ORDER BY sale_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS moving_avg_30days,
    ROUND(STDDEV(daily_revenue) OVER (ORDER BY sale_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS stddev_30days,
    ROUND(
        (daily_revenue - AVG(daily_revenue) OVER (ORDER BY sale_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)) / 
        NULLIF(STDDEV(daily_revenue) OVER (ORDER BY sale_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 0),
        2
    ) AS z_score_30days
FROM daily_revenue
ORDER BY sale_date;

-- 7. Revenue by Product Category
SELECT 
    cat.category_name,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.line_total) AS category_revenue,
    AVG(oi.unit_price) AS avg_unit_price,
    ROUND(SUM(oi.line_total) / SUM(SUM(oi.line_total)) OVER () * 100, 2) AS revenue_percentage,
    ROUND(AVG(oi.quantity), 2) AS avg_quantity_per_order
FROM categories cat
INNER JOIN products p ON cat.category_id = p.category_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.payment_status = 'paid'
GROUP BY cat.category_id, cat.category_name
ORDER BY category_revenue DESC;

-- 8. Revenue by Order Status
SELECT 
    status,
    COUNT(*) AS order_count,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value,
    ROUND(SUM(total_amount) / SUM(SUM(total_amount)) OVER () * 100, 2) AS revenue_percentage,
    SUM(CASE WHEN payment_status = 'paid' THEN total_amount ELSE 0 END) AS paid_revenue,
    SUM(CASE WHEN payment_status = 'pending' THEN total_amount ELSE 0 END) AS pending_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

-- =====================================================
-- PRODUCT PERFORMANCE INSIGHTS
-- =====================================================

-- 9. Top Performing Products by Revenue
SELECT 
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price,
    p.cost_price,
    ROUND(p.price - p.cost_price, 2) AS profit_per_unit,
    ROUND(((p.price - p.cost_price) / p.price) * 100, 2) AS profit_margin_percent,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.line_total) AS total_revenue,
    ROUND(SUM(oi.line_total) - (SUM(oi.quantity) * p.cost_price), 2) AS total_profit,
    COUNT(DISTINCT o.order_id) AS times_ordered,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    AVG(oi.unit_price) AS avg_selling_price,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.review_id) AS review_count,
    p.stock_quantity,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'Out of Stock'
        WHEN p.stock_quantity < 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.payment_status = 'paid'
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, cat.category_name, p.price, p.cost_price, p.stock_quantity
ORDER BY total_revenue DESC NULLS LAST
LIMIT 20;

-- 10. Product Performance with Sales Velocity
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        DATE_TRUNC('month', o.order_date) AS sale_month,
        SUM(oi.quantity) AS monthly_units_sold,
        SUM(oi.line_total) AS monthly_revenue
    FROM products p
    INNER JOIN order_items oi ON p.product_id = oi.product_id
    INNER JOIN orders o ON oi.order_id = o.order_id
    WHERE o.payment_status = 'paid'
    GROUP BY p.product_id, p.product_name, DATE_TRUNC('month', o.order_date)
),
product_velocity AS (
    SELECT 
        product_id,
        product_name,
        COUNT(DISTINCT sale_month) AS months_with_sales,
        SUM(monthly_units_sold) AS total_units_sold,
        SUM(monthly_revenue) AS total_revenue,
        AVG(monthly_units_sold) AS avg_monthly_units,
        AVG(monthly_revenue) AS avg_monthly_revenue,
        STDDEV(monthly_units_sold) AS stddev_monthly_units
    FROM product_sales
    GROUP BY product_id, product_name
)
SELECT 
    pv.product_name,
    p.price,
    pv.months_with_sales,
    pv.total_units_sold,
    ROUND(pv.total_revenue, 2) AS total_revenue,
    ROUND(pv.avg_monthly_units, 2) AS avg_monthly_units,
    ROUND(pv.avg_monthly_revenue, 2) AS avg_monthly_revenue,
    ROUND(pv.stddev_monthly_units, 2) AS sales_volatility,
    CASE 
        WHEN pv.avg_monthly_units > 5 AND pv.stddev_monthly_units < 2 THEN 'Stable High'
        WHEN pv.avg_monthly_units > 2 THEN 'Stable Medium'
        WHEN pv.stddev_monthly_units > pv.avg_monthly_units THEN 'Volatile'
        ELSE 'Low Volume'
    END AS sales_pattern,
    ROUND(COALESCE(AVG(r.rating), 0), 2) AS avg_rating,
    COUNT(r.review_id) AS review_count
FROM product_velocity pv
INNER JOIN products p ON pv.product_id = p.product_id
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY pv.product_id, pv.product_name, p.price, pv.months_with_sales, 
         pv.total_units_sold, pv.total_revenue, pv.avg_monthly_units, 
         pv.avg_monthly_revenue, pv.stddev_monthly_units
ORDER BY pv.total_revenue DESC;

-- 11. Product Conversion Rate (Views to Orders) - Simplified
-- Note: This assumes we track product views separately. For now, using order frequency as proxy
SELECT 
    p.product_id,
    p.product_name,
    cat.category_name,
    COUNT(DISTINCT o.order_id) AS times_ordered,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity)::DECIMAL / COUNT(DISTINCT o.order_id), 2) AS avg_quantity_per_order,
    ROUND(COUNT(DISTINCT o.customer_id)::DECIMAL / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS customers_per_order_ratio
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.payment_status = 'paid'
GROUP BY p.product_id, p.product_name, cat.category_name
HAVING COUNT(DISTINCT o.order_id) > 0
ORDER BY times_ordered DESC;

-- 12. Product Profitability Analysis
SELECT 
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price,
    p.cost_price,
    ROUND(p.price - p.cost_price, 2) AS profit_per_unit,
    ROUND(((p.price - p.cost_price) / p.price) * 100, 2) AS profit_margin_percent,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    COALESCE(SUM(oi.line_total), 0) AS total_revenue,
    ROUND(COALESCE(SUM(oi.quantity), 0) * (p.price - p.cost_price), 2) AS total_profit,
    ROUND(
        CASE 
            WHEN COALESCE(SUM(oi.quantity), 0) > 0 
            THEN (COALESCE(SUM(oi.quantity), 0) * (p.price - p.cost_price)) / COALESCE(SUM(oi.line_total), 1) * 100
            ELSE 0
        END, 
        2
    ) AS profit_margin_on_sales,
    p.stock_quantity,
    ROUND(p.stock_quantity * (p.price - p.cost_price), 2) AS potential_profit_from_stock
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.payment_status = 'paid'
GROUP BY p.product_id, p.product_name, cat.category_name, p.price, p.cost_price, p.stock_quantity
ORDER BY total_profit DESC NULLS LAST;

-- 13. Best and Worst Performing Products by Rating
SELECT 
    p.product_id,
    p.product_name,
    cat.category_name,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(CASE WHEN r.rating = 5 THEN 1 END) AS five_star_reviews,
    COUNT(CASE WHEN r.rating = 4 THEN 1 END) AS four_star_reviews,
    COUNT(CASE WHEN r.rating = 3 THEN 1 END) AS three_star_reviews,
    COUNT(CASE WHEN r.rating = 2 THEN 1 END) AS two_star_reviews,
    COUNT(CASE WHEN r.rating = 1 THEN 1 END) AS one_star_reviews,
    ROUND(
        COUNT(CASE WHEN r.rating >= 4 THEN 1 END)::DECIMAL / 
        NULLIF(COUNT(r.review_id), 0) * 100, 
        2
    ) AS positive_review_percentage,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.line_total) AS revenue
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN reviews r ON p.product_id = r.product_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.payment_status = 'paid'
GROUP BY p.product_id, p.product_name, cat.category_name
HAVING COUNT(r.review_id) > 0
ORDER BY avg_rating DESC, review_count DESC;


