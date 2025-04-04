-- 1️⃣ Retrieve the top 10 best-selling products from last month
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
  AND o.order_date < DATE_TRUNC('month', CURRENT_DATE)
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 10;

-- 2️⃣ Add a new customer who made a purchase without an account
INSERT INTO customers (customer_name, email, is_guest)
VALUES ('John Doe', 'johndoe@example.com', TRUE)
RETURNING customer_id;

-- 3️⃣ Update the price of a product based on its category
UPDATE products
SET price = price * 1.10  -- Increase by 10%
WHERE category = 'Electronics';

-- 4️⃣ Remove inactive customers who haven't made a purchase in the last year
DELETE FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
);

-- 5️⃣ Calculate the average revenue per day for each quarter
SELECT 
    DATE_TRUNC('quarter', o.order_date) AS quarter,
    AVG(daily_revenue) AS avg_daily_revenue
FROM (
    SELECT 
        o.order_date, 
        SUM(oi.quantity * oi.unit_price) AS daily_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_date
) AS daily_sales
GROUP BY quarter
ORDER BY quarter;

-- 6️⃣ Find the customer who has spent the most money cumulatively
SELECT c.customer_id, c.customer_name, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- 7️⃣ Identify products that have never been purchased
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 8️⃣ Implement a mechanism to speed up frequent customer searches (Indexing)
CREATE INDEX idx_customer_name ON customers(customer_name);
CREATE INDEX idx_customer_email ON customers(email);

-- 9️⃣ Create a report that shows daily sales alongside the average sales for that day of the week
SELECT 
    o.order_date, 
    SUM(oi.quantity * oi.unit_price) AS daily_sales,
    AVG(SUM(oi.quantity * oi.unit_price)) OVER (
        PARTITION BY EXTRACT(DOW FROM o.order_date)
    ) AS avg_weekday_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- 🔟 Develop a way to record the history of product price changes
CREATE TABLE price_history (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to automatically track price changes
CREATE OR REPLACE FUNCTION log_price_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO price_history (product_id, old_price, new_price)
    VALUES (NEW.product_id, OLD.price, NEW.price);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER price_update_trigger
BEFORE UPDATE ON products
FOR EACH ROW
WHEN (OLD.price IS DISTINCT FROM NEW.price)
EXECUTE FUNCTION log_price_changes();
