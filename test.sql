-- 1. Retrieve the list of customers who have placed more than 5 orders, sorted by their total order value
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 5
ORDER BY total_order_value DESC;

-- 2. Add a new product to the 'products' table with an auto-incrementing product ID
INSERT INTO Products (name, category, price, stock_quantity)
VALUES ('New Product', 'Electronics', 99.99, 100);

-- 3. Update the quantity of a specific product in the 'inventory' table after an order is placed
UPDATE Inventory 
SET quantity = quantity - (SELECT quantity FROM Order_Items WHERE product_id = 101 AND order_id = 202)
WHERE product_id = 101;

-- 4. Remove orders that have been canceled by the customer from the 'orders' table
DELETE FROM Orders 
WHERE status = 'Canceled';

-- 5. Fetch all orders placed in the last month, along with the corresponding customer details and product names
SELECT o.order_id, o.order_date, c.name AS customer_name, p.name AS product_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 6. Calculate the average order value for each customer
SELECT c.customer_id, c.name, AVG(o.total_amount) AS avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- 7. Create an index on the 'order_date' column in the 'orders' table to speed up queries filtering by date
CREATE INDEX idx_order_date ON Orders(order_date);

-- 8. Design a query to retrieve the top 10 best-selling products
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 10;

-- 9. Find the customers who have purchased the same product more than once
SELECT c.customer_id, c.name, oi.product_id, p.name AS product_name, COUNT(oi.product_id) AS times_purchased
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name, oi.product_id, p.name
HAVING COUNT(oi.product_id) > 1;

-- 10. Implement a mechanism to prevent adding a product to the 'order_items' table if the product does not exist in the 'products' table
ALTER TABLE Order_Items
ADD CONSTRAINT fk_product_exists FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE RESTRICT;
