-- 1. Retrieve the names and contact details of all customers who have made a purchase in the last quarter
SELECT DISTINCT c.customer_id, c.name, c.email, c.phone
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_date >= DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '3 months';

-- 2. Generate a report listing each product category and its total revenue generated
SELECT p.category, SUM(s.quantity * s.unit_price) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category;

-- 3. Identify and retrieve the top 5 selling products across all stores
SELECT p.product_id, p.name, SUM(s.quantity) AS total_quantity_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- 4. Add a new field to the customer table to store their preferred mode of communication
ALTER TABLE customers
ADD COLUMN preferred_communication VARCHAR(20);

-- 5. Upgrade membership tier to 'Premium' for customers with more than 5 purchases
UPDATE customers
SET membership_tier = 'Premium'
WHERE customer_id IN (
    SELECT customer_id
    FROM sales
    GROUP BY customer_id
    HAVING COUNT(*) > 5
);

-- 6. Remove products from the inventory that are 'Discontinued' and have zero quantity in stock
DELETE FROM inventory
WHERE product_id IN (
    SELECT product_id
    FROM products
    WHERE status = 'Discontinued'
)
AND quantity = 0;

-- 7. Create a view that combines customer information and their purchase history
CREATE OR REPLACE VIEW customer_purchase_history AS
SELECT 
    c.customer_id, c.name, c.email, c.phone, 
    s.sale_id, s.product_id, s.quantity, s.unit_price, s.sale_date
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id;

-- 8. Find the average purchase amount for each customer category (Regular/Premium)
SELECT c.membership_tier, AVG(s.quantity * s.unit_price) AS avg_purchase_amount
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.membership_tier;

-- 9. List the stores with the highest average customer ratings
SELECT store_id, AVG(rating) AS avg_rating
FROM store_reviews
GROUP BY store_id
ORDER BY avg_rating DESC;

-- 10. Retrieve the monthly sales trends for the year 2023
SELECT 
    DATE_TRUNC('month', sale_date) AS month,
    SUM(quantity * unit_price) AS total_sales
FROM sales
WHERE EXTRACT(YEAR FROM sale_date) = 2023
GROUP BY month
ORDER BY month;
