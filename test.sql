-- ========================================
-- 1. Retrieve usernames and emails of users registered after a specific date
-- Replace '2024-01-01' with the desired date
SELECT username, email
FROM Users
WHERE registration_date > '2024-01-01';

-- ========================================
-- 2. Add a new product to the 'Products' table
-- Replace with actual product details
INSERT INTO Products (product_id, product_name, category, price, stock_quantity)
VALUES (101, 'Wireless Earbuds X200', 'Electronics', 129.99, 50);

-- ========================================
-- 3. Update the price of a specific product
-- Replace product_id and new price as needed
UPDATE Products
SET price = 149.99
WHERE product_id = 101;

-- ========================================
-- 4. Remove a specific product from the 'Products' table
-- Replace product_id as needed
DELETE FROM Products
WHERE product_id = 101;

-- ========================================
-- 5. List all products in 'Electronics' category sorted by price descending
SELECT *
FROM Products
WHERE category = 'Electronics'
ORDER BY price DESC;

-- ========================================
-- 6. Calculate total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue
FROM Orders;

-- ========================================
-- 7. Find average price of products in each category
SELECT category, AVG(price) AS average_price
FROM Products
GROUP BY category;

-- ========================================
-- 8. Display top 5 most expensive products
SELECT *
FROM Products
ORDER BY price DESC
LIMIT 5;

-- ========================================
-- 9. For each order, display order ID, order date, and total number of products
SELECT 
    o.order_id,
    o.order_date,
    SUM(oi.quantity) AS total_products
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date
ORDER BY o.order_date;

-- ========================================
-- 10. Retrieve usernames of users who have placed orders for more than a certain amount
-- Replace 500 with desired threshold
SELECT DISTINCT u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
WHERE o.total_amount > 500;
