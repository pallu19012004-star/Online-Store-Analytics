# Changelog - Sample Data Updates

## Updated Product IDs

The following product IDs were changed to fix errors:

### Old → New Product IDs:
1. **Garden Tool Set**
   - Old: `gggggggg-gggg-gggg-gggg-gggggggggggg`
   - New: `66666666-6666-6666-6666-666666666666`

2. **The Great Gatsby**
   - Old: `hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh`
   - New: `77777777-7777-7777-7777-777777777777`

3. **Yoga Mat Premium**
   - Old: `iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii`
   - New: `88888888-8888-8888-8888-888888888888`

4. **Running Shoes**
   - Old: `jjjjjjjj-jjjj-jjjj-jjjj-jjjjjjjjjjjj`
   - New: `99999999-9999-9999-9999-999999999999`

### Updated Coupon IDs:
1. **WELCOME10**
   - Old: `gggggggg-0001-0001-0001-000000000001`
   - New: `66666666-0001-0001-0001-000000000001`

2. **SPRING20**
   - Old: `gggggggg-0001-0001-0001-000000000002`
   - New: `66666666-0001-0001-0001-000000000002`

3. **FIXED50**
   - Old: `gggggggg-0001-0001-0001-000000000003`
   - New: `66666666-0001-0001-0001-000000000003`

## Files Updated

✅ **sample_data.sql** - All product IDs, order items, reviews, and coupons updated

## Files That Don't Need Updates

✅ **complex_queries.sql** - Uses dynamic joins, no hardcoded IDs  
✅ **insights_queries.sql** - Uses dynamic joins, no hardcoded IDs  
✅ **schema.sql** - Schema definition, no data dependencies

## Impact

- All queries will continue to work correctly as they use dynamic joins
- Order items now reference the correct product IDs
- Reviews now reference the correct product IDs
- No breaking changes to existing functionality

## Verification

After loading the updated sample data, verify with:

```sql
-- Check products
SELECT product_id, product_name FROM products ORDER BY product_name;

-- Check order items reference correct products
SELECT oi.order_item_id, p.product_name 
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_item_id;

-- Check reviews reference correct products
SELECT r.review_id, p.product_name, r.rating
FROM reviews r
JOIN products p ON r.product_id = p.product_id
ORDER BY r.review_id;
```


