-- 1. Retrieve customers who made a purchase in the last quarter
SELECT DISTINCT c.customer_id, c.name, c.email, c.phone
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '1 quarter'
  AND o.order_date < DATE_TRUNC('quarter', CURRENT_DATE);

-- 2. Product category-wise total revenue
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category;

-- 3. Top 5 selling products across all stores
SELECT p.product_name, SUM(oi.quantity) AS total_units_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC
LIMIT 5;

-- 4. Add 'preferred_communication' field to customers table
ALTER TABLE customers
ADD COLUMN preferred_communication VARCHAR(10);  -- Options: 'Email' or 'Phone'

-- 5. Upgrade membership tier to 'Premium' for customers with >5 purchases
UPDATE customers
SET membership_tier = 'Premium'
WHERE customer_id IN (
  SELECT customer_id
  FROM orders
  GROUP BY customer_id
  HAVING COUNT(*) > 5
);

-- 6. Remove discontinued products with zero quantity in inventory
DELETE FROM inventory
WHERE product_id IN (
  SELECT product_id FROM products WHERE status = 'Discontinued'
)
AND quantity = 0;

-- 7. Create a view combining customer info and their purchase history
CREATE VIEW customer_purchase_history AS
SELECT c.customer_id, c.name, c.email,
       o.order_id, o.order_date,
       oi.product_id, oi.quantity, oi.unit_price
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id;

-- 8. Average purchase amount for each membership tier
SELECT c.membership_tier, AVG(o.total_amount) AS avg_purchase
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.membership_tier;

-- 9. Stores with highest average customer ratings
SELECT s.store_id, s.store_name, AVG(r.rating) AS avg_rating
FROM stores s
JOIN ratings r ON s.store_id = r.store_id
GROUP BY s.store_id, s.store_name
ORDER BY avg_rating DESC
LIMIT 5;

-- 10. Monthly sales trends for the year 2023
SELECT DATE_TRUNC('month', o.order_date) AS month,
       SUM(o.total_amount) AS total_sales
FROM orders o
WHERE EXTRACT(YEAR FROM o.order_date) = 2023
GROUP BY month
ORDER BY month;
