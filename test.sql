-- 1. Retrieve the names and email addresses of all customers who have placed an order in the last month.
SELECT DISTINCT c.name, c.email 
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= DATEADD(MONTH, -1, GETDATE());

-- 2. Add a new customer to the Customers table.
INSERT INTO Customers (name, email)
VALUES ('John Doe', 'johndoe@example.com');

-- 3. Update the price of a specific product.
UPDATE Products
SET price = 19.99
WHERE product_id = 101;

-- 4. Remove a specific order from the Orders table.
DELETE FROM Orders
WHERE order_id = 5001;

-- 5. List the top 5 most expensive products.
SELECT name, price
FROM Products
ORDER BY price DESC
LIMIT 5;

-- 6. Calculate the average order value.
SELECT AVG(total_order_value) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(p.price * oi.quantity) AS total_order_value
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    GROUP BY o.order_id
) AS OrderValues;

-- 7. Find the total number of orders placed by each customer.
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- 8. Retrieve the names of products that have never been ordered.
SELECT p.name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 9. Create an index to speed up searches by customer email.
CREATE INDEX idx_customer_email ON Customers(email);

-- 10. Generate a report that shows the total revenue for each month.
SELECT 
    DATEPART(YEAR, o.order_date) AS order_year, 
    DATEPART(MONTH, o.order_date) AS order_month, 
    SUM(p.price * oi.quantity) AS total_revenue
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY DATEPART(YEAR, o.order_date), DATEPART(MONTH, o.order_date)
ORDER BY order_year DESC, order_month DESC;
