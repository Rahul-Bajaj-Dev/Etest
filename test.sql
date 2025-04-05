-- =========================================
-- SCHEMA SETUP: Create tables
-- =========================================

-- Customers Table
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  address VARCHAR(255)
);

-- Products Table
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  name VARCHAR(100),
  price DECIMAL(10, 2),
  category VARCHAR(50)
);

-- Orders Table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order_Items Table (Many-to-Many relationship between Orders and Products)
CREATE TABLE Order_Items (
  order_id INT,
  product_id INT,
  quantity INT,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- =========================================
-- SAMPLE DATA INSERTS
-- =========================================

-- Customers
INSERT INTO Customers (customer_id, name, email, address) VALUES
(1, 'Alice Smith', 'alice@example.com', '123 Elm Street'),
(2, 'Bob Johnson', 'bob@example.com', '456 Oak Avenue'),
(3, 'Charlie Brown', 'charlie@example.com', '789 Pine Road'),
(4, 'Diana Ross', 'diana@example.com', '234 Maple Lane'),
(5, 'Evan Wright', 'evan@example.com', '567 Cedar Blvd'),
(6, 'Fiona Green', 'fiona@example.com', '890 Birch Street'),
(7, 'George Stone', 'george@example.com', '321 Walnut Drive'),
(8, 'Hannah Lee', 'hannah@example.com', '654 Spruce Way'),
(9, 'Ian Black', 'ian@example.com', '987 Poplar Circle'),
(10, 'Jill White', 'jill@example.com', '147 Cherry Street');

-- Products
INSERT INTO Products (product_id, name, price, category) VALUES
(1, 'Smartphone X', 799.99, 'Electronics'),
(2, 'Bluetooth Headphones', 199.99, 'Electronics'),
(3, 'Laptop Pro', 1199.99, 'Electronics'),
(4, 'Office Chair', 149.99, 'Furniture'),
(5, 'Standing Desk', 399.99, 'Furniture'),
(6, 'Monitor 4K', 299.99, 'Electronics'),
(7, 'Keyboard', 49.99, 'Accessories'),
(8, 'Mouse', 29.99, 'Accessories'),
(9, 'LED Lamp', 39.99, 'Home'),
(10, 'Notebook', 5.99, 'Stationery'),
(11, 'Pen Set', 9.99, 'Stationery'),
(12, 'Coffee Maker', 89.99, 'Appliances'),
(13, 'Blender', 69.99, 'Appliances'),
(14, 'Smartwatch', 249.99, 'Electronics'),
(15, 'Router', 129.99, 'Electronics'),
(16, 'Water Bottle', 19.99, 'Accessories'),
(17, 'Backpack', 79.99, 'Accessories'),
(18, 'TV 55"', 699.99, 'Electronics'),
(19, 'Shoes', 99.99, 'Apparel'),
(20, 'Jacket', 149.99, 'Apparel');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2025-03-10', 1049.97),
(2, 2, '2025-03-15', 249.98),
(3, 3, '2025-02-20', 129.99),
(4, 1, '2025-03-25', 399.99),
(5, 4, '2025-03-02', 49.99),
(6, 5, '2025-03-03', 79.99),
(7, 2, '2025-03-08', 89.99),
(8, 6, '2025-02-01', 59.99),
(9, 1, '2025-01-15', 199.99),
(10, 7, '2025-03-12', 799.99),
(11, 2, '2025-03-14', 129.99),
(12, 3, '2025-03-05', 69.99),
(13, 8, '2025-03-09', 99.99),
(14, 9, '2025-03-17', 149.99),
(15, 2, '2025-03-19', 39.99);

-- Order Items
INSERT INTO Order_Items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 6, 1),
(1, 7, 1),
(2, 2, 1),
(2, 8, 2),
(3, 15, 1),
(4, 5, 1),
(5, 7, 1),
(6, 17, 1),
(7, 12, 1),
(8, 9, 1),
(9, 14, 1),
(10, 3, 1),
(11, 15, 1),
(12, 13, 1),
(13, 19, 1),
(14, 20, 1),
(15, 10, 2);

-- =========================================
-- QUERIES
-- =========================================

-- 1. Retrieve all orders placed in the last month (March 2025)
SELECT * 
FROM Orders
WHERE order_date BETWEEN '2025-03-01' AND '2025-03-31';

-- 2. Retrieve the top 5 most expensive products
SELECT * 
FROM Products
ORDER BY price DESC
LIMIT 5;

-- 3. Calculate the average order value
SELECT AVG(total_amount) AS avg_order_value
FROM Orders;

-- 4. Find the customers who have placed more than 2 orders
SELECT c.customer_id, c.name, COUNT(o.order_id) AS num_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 2;

-- 5. For each product category, find the product with the highest price
SELECT category, name, price
FROM Products p
WHERE (category, price) IN (
  SELECT category, MAX(price)
  FROM Products
  GROUP BY category
);

-- 6. Update the price of a specific product (e.g., product_id = 1) by increasing it by 10%
UPDATE Products
SET price = price * 1.10
WHERE product_id = 1;

-- 7. Delete all orders placed before a specific date (e.g., before March 1, 2025)
DELETE FROM Orders
WHERE order_date < '2025-03-01';

-- 8. Retrieve the list of customers who haven't placed any orders yet
SELECT *
FROM Customers
WHERE customer_id NOT IN (
  SELECT DISTINCT customer_id FROM Orders
);
