-- 1️⃣ Retrieve the product_name and selling_price of all products in the 'Laptops' category.
SELECT product_name, selling_price
FROM Products
WHERE category = 'Laptops';

-- 2️⃣ Find the total revenue generated by each product category.
SELECT p.category, SUM(oi.quantity * p.selling_price) AS total_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 3️⃣ List the first and last names of customers who have placed more than 2 orders.
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 2
ORDER BY order_count DESC;

-- 4️⃣ Calculate the average quantity of each product sold per order.
SELECT p.product_name, AVG(oi.quantity) AS avg_quantity_per_order
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY avg_quantity_per_order DESC;

-- 5️⃣ Retrieve the order_id, order_date, and total amount for each order (quantity * selling_price).
SELECT o.order_id, o.order_date, SUM(oi.quantity * p.selling_price) AS total_order_amount
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY o.order_id, o.order_date
ORDER BY o.order_date DESC;

-- 6️⃣ Find the names of the products that have never been ordered.
SELECT p.product_name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 7️⃣ Get the month-wise total revenue for the year 2023.
SELECT 
    EXTRACT(MONTH FROM o.order_date) AS order_month,
    SUM(oi.quantity * p.selling_price) AS total_revenue
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2023
GROUP BY order_month
ORDER BY order_month;

-- 8️⃣ Determine the customer who has spent the most money (highest total order value).
SELECT c.customer_id, c.first_name, c.last_name, SUM(oi.quantity * p.selling_price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;

-- 9️⃣ For each category, find the product with the highest profit margin (selling_price - cost_price).
SELECT DISTINCT ON (p.category) 
    p.category, 
    p.product_name, 
    (p.selling_price - p.cost_price) AS profit_margin
FROM Products p
ORDER BY p.category, profit_margin DESC;

-- 🔟 List the customers who have placed orders in every month of the year 2022.
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2022
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM o.order_date)) = 12;
