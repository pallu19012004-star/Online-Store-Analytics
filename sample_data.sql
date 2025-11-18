-- =====================================================
-- Sample Data for E-Commerce Platform
-- =====================================================
-- This file contains sample data to populate the database
-- for testing and demonstration purposes
-- =====================================================

-- Insert Categories
INSERT INTO categories (category_id, category_name, description) VALUES
('11111111-1111-1111-1111-111111111111', 'Electronics', 'Electronic devices and accessories'),
('22222222-2222-2222-2222-222222222222', 'Clothing', 'Apparel and fashion items'),
('33333333-3333-3333-3333-333333333333', 'Home & Garden', 'Home improvement and garden supplies'),
('44444444-4444-4444-4444-444444444444', 'Books', 'Books and educational materials'),
('55555555-5555-5555-5555-555555555555', 'Sports & Outdoors', 'Sports equipment and outdoor gear');

-- Insert Sub-categories
INSERT INTO categories (category_id, category_name, description, parent_category_id) VALUES
('11111111-1111-1111-1111-111111111112', 'Smartphones', 'Mobile phones and accessories', '11111111-1111-1111-1111-111111111111'),
('11111111-1111-1111-1111-111111111113', 'Laptops', 'Laptop computers', '11111111-1111-1111-1111-111111111111'),
('22222222-2222-2222-2222-222222222223', 'Men''s Clothing', 'Men''s apparel', '22222222-2222-2222-2222-222222222222'),
('22222222-2222-2222-2222-222222222224', 'Women''s Clothing', 'Women''s apparel', '22222222-2222-2222-2222-222222222222');

-- Insert Products
INSERT INTO products (product_id, product_name, description, category_id, price, cost_price, stock_quantity, sku) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'iPhone 15 Pro', 'Latest Apple smartphone with advanced features', '11111111-1111-1111-1111-111111111112', 999.99, 700.00, 50, 'IPH15PRO001'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Samsung Galaxy S24', 'Premium Android smartphone', '11111111-1111-1111-1111-111111111112', 899.99, 650.00, 75, 'SGS24-001'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'MacBook Pro 16"', 'Professional laptop for creative work', '11111111-1111-1111-1111-111111111113', 2499.99, 1800.00, 30, 'MBP16-001'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Dell XPS 15', 'High-performance Windows laptop', '11111111-1111-1111-1111-111111111113', 1799.99, 1300.00, 40, 'DXP15-001'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Men''s Casual T-Shirt', 'Comfortable cotton t-shirt', '22222222-2222-2222-2222-222222222223', 29.99, 12.00, 200, 'MTS-001'),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'Women''s Summer Dress', 'Elegant summer dress', '22222222-2222-2222-2222-222222222224', 59.99, 25.00, 150, 'WSD-001'),
('66666666-6666-6666-6666-666666666666', 'Garden Tool Set', 'Complete set of gardening tools', '33333333-3333-3333-3333-333333333333', 89.99, 45.00, 100, 'GTS-001'),
('77777777-7777-7777-7777-777777777777', 'The Great Gatsby', 'Classic American novel', '44444444-4444-4444-4444-444444444444', 12.99, 5.00, 300, 'BKGAT-001'),
('88888888-8888-8888-8888-888888888888', 'Yoga Mat Premium', 'High-quality yoga mat', '55555555-5555-5555-5555-555555555555', 39.99, 18.00, 120, 'YM-001'),
('99999999-9999-9999-9999-999999999999', 'Running Shoes', 'Professional running shoes', '55555555-5555-5555-5555-555555555555', 129.99, 60.00, 80, 'RS-001');

-- Insert Customers
INSERT INTO customers (customer_id, first_name, last_name, email, phone, date_of_birth, registration_date) VALUES
('aaaaaaaa-0001-0001-0001-000000000001', 'John', 'Doe', 'john.doe@email.com', '+1234567890', '1990-05-15', '2023-01-15 10:00:00'),
('aaaaaaaa-0001-0001-0001-000000000002', 'Jane', 'Smith', 'jane.smith@email.com', '+1234567891', '1985-08-22', '2023-02-20 14:30:00'),
('aaaaaaaa-0001-0001-0001-000000000003', 'Michael', 'Johnson', 'michael.j@email.com', '+1234567892', '1992-11-10', '2023-03-10 09:15:00'),
('aaaaaaaa-0001-0001-0001-000000000004', 'Emily', 'Williams', 'emily.w@email.com', '+1234567893', '1988-04-05', '2023-01-25 16:45:00'),
('aaaaaaaa-0001-0001-0001-000000000005', 'David', 'Brown', 'david.brown@email.com', '+1234567894', '1995-07-18', '2023-04-05 11:20:00'),
('aaaaaaaa-0001-0001-0001-000000000006', 'Sarah', 'Davis', 'sarah.d@email.com', '+1234567895', '1991-12-30', '2023-02-14 13:00:00'),
('aaaaaaaa-0001-0001-0001-000000000007', 'Robert', 'Miller', 'robert.m@email.com', '+1234567896', '1987-09-12', '2023-03-22 15:30:00'),
('aaaaaaaa-0001-0001-0001-000000000008', 'Lisa', 'Wilson', 'lisa.w@email.com', '+1234567897', '1993-06-25', '2023-01-10 08:00:00');

-- Insert Addresses
INSERT INTO addresses (address_id, customer_id, address_type, street_address, city, state, postal_code, country, is_default) VALUES
('bbbbbbbb-0001-0001-0001-000000000001', 'aaaaaaaa-0001-0001-0001-000000000001', 'both', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
('bbbbbbbb-0001-0001-0001-000000000002', 'aaaaaaaa-0001-0001-0001-000000000002', 'both', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', TRUE),
('bbbbbbbb-0001-0001-0001-000000000003', 'aaaaaaaa-0001-0001-0001-000000000003', 'both', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', TRUE),
('bbbbbbbb-0001-0001-0001-000000000004', 'aaaaaaaa-0001-0001-0001-000000000004', 'both', '321 Elm St', 'Houston', 'TX', '77001', 'USA', TRUE),
('bbbbbbbb-0001-0001-0001-000000000005', 'aaaaaaaa-0001-0001-0001-000000000005', 'both', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', TRUE);

-- Insert Orders (spread across different dates for trend analysis)
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address_id, billing_address_id, subtotal, tax_amount, shipping_cost, discount_amount, total_amount, payment_status) VALUES
-- January 2024 orders
('cccccccc-0001-0001-0001-000000000001', 'aaaaaaaa-0001-0001-0001-000000000001', '2024-01-15 10:30:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000001', 'bbbbbbbb-0001-0001-0001-000000000001', 999.99, 80.00, 15.00, 0.00, 1094.99, 'paid'),
('cccccccc-0001-0001-0001-000000000002', 'aaaaaaaa-0001-0001-0001-000000000002', '2024-01-20 14:20:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000002', 'bbbbbbbb-0001-0001-0001-000000000002', 59.99, 4.80, 10.00, 5.00, 69.79, 'paid'),
('cccccccc-0001-0001-0001-000000000003', 'aaaaaaaa-0001-0001-0001-000000000003', '2024-01-25 09:15:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000003', 'bbbbbbbb-0001-0001-0001-000000000003', 129.99, 10.40, 12.00, 0.00, 152.39, 'paid'),
-- February 2024 orders
('cccccccc-0001-0001-0001-000000000004', 'aaaaaaaa-0001-0001-0001-000000000001', '2024-02-10 11:00:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000001', 'bbbbbbbb-0001-0001-0001-000000000001', 29.99, 2.40, 8.00, 0.00, 40.39, 'paid'),
('cccccccc-0001-0001-0001-000000000005', 'aaaaaaaa-0001-0001-0001-000000000004', '2024-02-15 16:30:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000004', 'bbbbbbbb-0001-0001-0001-000000000004', 899.99, 72.00, 15.00, 50.00, 936.99, 'paid'),
('cccccccc-0001-0001-0001-000000000006', 'aaaaaaaa-0001-0001-0001-000000000002', '2024-02-20 13:45:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000002', 'bbbbbbbb-0001-0001-0001-000000000002', 2499.99, 200.00, 20.00, 0.00, 2719.99, 'paid'),
-- March 2024 orders
('cccccccc-0001-0001-0001-000000000007', 'aaaaaaaa-0001-0001-0001-000000000005', '2024-03-05 10:20:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000005', 'bbbbbbbb-0001-0001-0001-000000000005', 39.99, 3.20, 10.00, 0.00, 53.19, 'paid'),
('cccccccc-0001-0001-0001-000000000008', 'aaaaaaaa-0001-0001-0001-000000000003', '2024-03-12 15:00:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000003', 'bbbbbbbb-0001-0001-0001-000000000003', 1799.99, 144.00, 18.00, 100.00, 1861.99, 'paid'),
('cccccccc-0001-0001-0001-000000000009', 'aaaaaaaa-0001-0001-0001-000000000001', '2024-03-18 09:30:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000001', 'bbbbbbbb-0001-0001-0001-000000000001', 89.99, 7.20, 12.00, 0.00, 109.19, 'paid'),
('cccccccc-0001-0001-0001-000000000010', 'aaaaaaaa-0001-0001-0001-000000000006', '2024-03-25 14:15:00', 'delivered', 'bbbbbbbb-0001-0001-0001-000000000001', 'bbbbbbbb-0001-0001-0001-000000000001', 12.99, 1.04, 5.00, 0.00, 19.03, 'paid'),
-- April 2024 orders
('cccccccc-0001-0001-0001-000000000011', 'aaaaaaaa-0001-0001-0001-000000000002', '2024-04-02 11:45:00', 'shipped', 'bbbbbbbb-0001-0001-0001-000000000002', 'bbbbbbbb-0001-0001-0001-000000000002', 59.99, 4.80, 10.00, 0.00, 74.79, 'paid'),
('cccccccc-0001-0001-0001-000000000012', 'aaaaaaaa-0001-0001-0001-000000000004', '2024-04-10 16:00:00', 'processing', 'bbbbbbbb-0001-0001-0001-000000000004', 'bbbbbbbb-0001-0001-0001-000000000004', 129.99, 10.40, 12.00, 10.00, 142.39, 'paid'),
('cccccccc-0001-0001-0001-000000000013', 'aaaaaaaa-0001-0001-0001-000000000007', '2024-04-15 10:30:00', 'pending', 'bbbbbbbb-0001-0001-0001-000000000001', 'bbbbbbbb-0001-0001-0001-000000000001', 999.99, 80.00, 15.00, 0.00, 1094.99, 'pending'),
('cccccccc-0001-0001-0001-000000000014', 'aaaaaaaa-0001-0001-0001-000000000001', '2024-04-20 13:20:00', 'processing', 'bbbbbbbb-0001-0001-0001-000000000001', 'bbbbbbbb-0001-0001-0001-000000000001', 29.99, 2.40, 8.00, 0.00, 40.39, 'paid'),
('cccccccc-0001-0001-0001-000000000015', 'aaaaaaaa-0001-0001-0001-000000000005', '2024-04-25 09:00:00', 'shipped', 'bbbbbbbb-0001-0001-0001-000000000005', 'bbbbbbbb-0001-0001-0001-000000000005', 39.99, 3.20, 10.00, 0.00, 53.19, 'paid');

-- Insert Order Items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount_percentage, line_total) VALUES
-- Order 1
('dddddddd-0001-0001-0001-000000000001', 'cccccccc-0001-0001-0001-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 1, 999.99, 0, 999.99),
-- Order 2
('dddddddd-0001-0001-0001-000000000002', 'cccccccc-0001-0001-0001-000000000002', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 1, 59.99, 8.33, 54.99),
-- Order 3
('dddddddd-0001-0001-0001-000000000003', 'cccccccc-0001-0001-0001-000000000003', '99999999-9999-9999-9999-999999999999', 1, 129.99, 0, 129.99),
-- Order 4
('dddddddd-0001-0001-0001-000000000004', 'cccccccc-0001-0001-0001-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 1, 29.99, 0, 29.99),
-- Order 5
('dddddddd-0001-0001-0001-000000000005', 'cccccccc-0001-0001-0001-000000000005', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 1, 899.99, 5.56, 849.99),
-- Order 6
('dddddddd-0001-0001-0001-000000000006', 'cccccccc-0001-0001-0001-000000000006', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 1, 2499.99, 0, 2499.99),
-- Order 7
('dddddddd-0001-0001-0001-000000000007', 'cccccccc-0001-0001-0001-000000000007', '88888888-8888-8888-8888-888888888888', 1, 39.99, 0, 39.99),
-- Order 8
('dddddddd-0001-0001-0001-000000000008', 'cccccccc-0001-0001-0001-000000000008', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 1, 1799.99, 5.56, 1699.99),
-- Order 9
('dddddddd-0001-0001-0001-000000000009', 'cccccccc-0001-0001-0001-000000000009', '66666666-6666-6666-6666-666666666666', 1, 89.99, 0, 89.99),
-- Order 10
('dddddddd-0001-0001-0001-000000000010', 'cccccccc-0001-0001-0001-000000000010', '77777777-7777-7777-7777-777777777777', 1, 12.99, 0, 12.99),
-- Order 11
('dddddddd-0001-0001-0001-000000000011', 'cccccccc-0001-0001-0001-000000000011', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 1, 59.99, 0, 59.99),
-- Order 12
('dddddddd-0001-0001-0001-000000000012', 'cccccccc-0001-0001-0001-000000000012', '99999999-9999-9999-9999-999999999999', 1, 129.99, 7.69, 119.99),
-- Order 13
('dddddddd-0001-0001-0001-000000000013', 'cccccccc-0001-0001-0001-000000000013', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 1, 999.99, 0, 999.99),
-- Order 14
('dddddddd-0001-0001-0001-000000000014', 'cccccccc-0001-0001-0001-000000000014', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 2, 29.99, 0, 59.98),
-- Order 15
('dddddddd-0001-0001-0001-000000000015', 'cccccccc-0001-0001-0001-000000000015', '88888888-8888-8888-8888-888888888888', 1, 39.99, 0, 39.99);

-- Insert Payments
INSERT INTO payments (payment_id, order_id, payment_method, payment_date, amount, transaction_id, status) VALUES
('eeeeeeee-0001-0001-0001-000000000001', 'cccccccc-0001-0001-0001-000000000001', 'credit_card', '2024-01-15 10:35:00', 1094.99, 'TXN001', 'completed'),
('eeeeeeee-0001-0001-0001-000000000002', 'cccccccc-0001-0001-0001-000000000002', 'paypal', '2024-01-20 14:25:00', 69.79, 'TXN002', 'completed'),
('eeeeeeee-0001-0001-0001-000000000003', 'cccccccc-0001-0001-0001-000000000003', 'credit_card', '2024-01-25 09:20:00', 152.39, 'TXN003', 'completed'),
('eeeeeeee-0001-0001-0001-000000000004', 'cccccccc-0001-0001-0001-000000000004', 'debit_card', '2024-02-10 11:05:00', 40.39, 'TXN004', 'completed'),
('eeeeeeee-0001-0001-0001-000000000005', 'cccccccc-0001-0001-0001-000000000005', 'credit_card', '2024-02-15 16:35:00', 936.99, 'TXN005', 'completed'),
('eeeeeeee-0001-0001-0001-000000000006', 'cccccccc-0001-0001-0001-000000000006', 'credit_card', '2024-02-20 13:50:00', 2719.99, 'TXN006', 'completed'),
('eeeeeeee-0001-0001-0001-000000000007', 'cccccccc-0001-0001-0001-000000000007', 'paypal', '2024-03-05 10:25:00', 53.19, 'TXN007', 'completed'),
('eeeeeeee-0001-0001-0001-000000000008', 'cccccccc-0001-0001-0001-000000000008', 'credit_card', '2024-03-12 15:05:00', 1861.99, 'TXN008', 'completed'),
('eeeeeeee-0001-0001-0001-000000000009', 'cccccccc-0001-0001-0001-000000000009', 'debit_card', '2024-03-18 09:35:00', 109.19, 'TXN009', 'completed'),
('eeeeeeee-0001-0001-0001-000000000010', 'cccccccc-0001-0001-0001-000000000010', 'credit_card', '2024-03-25 14:20:00', 19.03, 'TXN010', 'completed'),
('eeeeeeee-0001-0001-0001-000000000011', 'cccccccc-0001-0001-0001-000000000011', 'paypal', '2024-04-02 11:50:00', 74.79, 'TXN011', 'completed'),
('eeeeeeee-0001-0001-0001-000000000012', 'cccccccc-0001-0001-0001-000000000012', 'credit_card', '2024-04-10 16:05:00', 142.39, 'TXN012', 'completed'),
('eeeeeeee-0001-0001-0001-000000000014', 'cccccccc-0001-0001-0001-000000000014', 'debit_card', '2024-04-20 13:25:00', 40.39, 'TXN014', 'completed'),
('eeeeeeee-0001-0001-0001-000000000015', 'cccccccc-0001-0001-0001-000000000015', 'paypal', '2024-04-25 09:05:00', 53.19, 'TXN015', 'completed');

-- Insert Reviews
INSERT INTO reviews (review_id, product_id, customer_id, order_id, rating, review_text, is_verified_purchase) VALUES
('ffffffff-0001-0001-0001-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'aaaaaaaa-0001-0001-0001-000000000001', 'cccccccc-0001-0001-0001-000000000001', 5, 'Excellent phone! Great camera and battery life.', TRUE),
('ffffffff-0001-0001-0001-000000000002', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'aaaaaaaa-0001-0001-0001-000000000002', 'cccccccc-0001-0001-0001-000000000002', 4, 'Beautiful dress, fits perfectly!', TRUE),
('ffffffff-0001-0001-0001-000000000003', '99999999-9999-9999-9999-999999999999', 'aaaaaaaa-0001-0001-0001-000000000003', 'cccccccc-0001-0001-0001-000000000003', 5, 'Very comfortable running shoes.', TRUE),
('ffffffff-0001-0001-0001-000000000004', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaaa-0001-0001-0001-000000000004', 'cccccccc-0001-0001-0001-000000000005', 4, 'Good phone, but battery could be better.', TRUE),
('ffffffff-0001-0001-0001-000000000005', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-0001-0001-0001-000000000002', 'cccccccc-0001-0001-0001-000000000006', 5, 'Amazing laptop! Perfect for my work.', TRUE),
('ffffffff-0001-0001-0001-000000000006', '88888888-8888-8888-8888-888888888888', 'aaaaaaaa-0001-0001-0001-000000000005', 'cccccccc-0001-0001-0001-000000000007', 4, 'Good quality yoga mat.', TRUE),
('ffffffff-0001-0001-0001-000000000007', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'aaaaaaaa-0001-0001-0001-000000000003', 'cccccccc-0001-0001-0001-000000000008', 5, 'Great laptop, fast and reliable.', TRUE),
('ffffffff-0001-0001-0001-000000000008', '66666666-6666-6666-6666-666666666666', 'aaaaaaaa-0001-0001-0001-000000000001', 'cccccccc-0001-0001-0001-000000000009', 3, 'Tools are okay, but could be sturdier.', TRUE);

-- Insert Coupons
INSERT INTO coupons (coupon_id, coupon_code, discount_type, discount_value, min_purchase_amount, max_discount_amount, valid_from, valid_until, usage_limit, used_count, is_active) VALUES
('66666666-0001-0001-0001-000000000001', 'WELCOME10', 'percentage', 10.00, 50.00, 100.00, '2024-01-01 00:00:00', '2024-12-31 23:59:59', 1000, 5, TRUE),
('66666666-0001-0001-0001-000000000002', 'SPRING20', 'percentage', 20.00, 100.00, 200.00, '2024-03-01 00:00:00', '2024-05-31 23:59:59', 500, 2, TRUE),
('66666666-0001-0001-0001-000000000003', 'FIXED50', 'fixed', 50.00, 200.00, NULL, '2024-01-01 00:00:00', '2024-12-31 23:59:59', 200, 3, TRUE);

-- Update customer statistics
UPDATE customers SET 
    total_orders = (
        SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.customer_id
    ),
    total_spent = (
        SELECT COALESCE(SUM(total_amount), 0) FROM orders 
        WHERE orders.customer_id = customers.customer_id AND payment_status = 'paid'
    );

