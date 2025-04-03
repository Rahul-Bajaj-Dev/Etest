-- 1. Retrieve the names and contact details of all customers who have rented a car in the last month
SELECT DISTINCT c.name, c.email, c.phone
FROM Customers c
JOIN Rentals r ON c.customer_id = r.customer_id
WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 2. Calculate the average rental duration for each car model
SELECT car.model, AVG(r.rental_duration_days) AS avg_rental_duration
FROM Rentals r
JOIN Cars car ON r.car_id = car.car_id
GROUP BY car.model;

-- 3. Identify the most and least frequently rented car models
SELECT car.model, COUNT(r.rental_id) AS rental_count
FROM Rentals r
JOIN Cars car ON r.car_id = car.car_id
GROUP BY car.model
ORDER BY rental_count DESC;

-- 4. Retrieve the details of customers who have made payments above a certain amount in the last quarter
SELECT DISTINCT c.*
FROM Customers c
JOIN Rentals r ON c.customer_id = r.customer_id
JOIN Payments p ON r.rental_id = p.rental_id
WHERE p.amount > 500 -- Change 500 to the desired threshold
AND p.payment_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- 5. List all cars due for maintenance based on their mileage
SELECT car.*
FROM Cars car
WHERE car.mileage >= car.maintenance_mileage;

-- 6. Rank customers based on the total amount they've spent on rentals
SELECT c.name, SUM(p.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank_position
FROM Customers c
JOIN Rentals r ON c.customer_id = r.customer_id
JOIN Payments p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- 7. Create a report that shows the daily revenue generated from car rentals
SELECT r.rental_date, SUM(p.amount) AS daily_revenue
FROM Rentals r
JOIN Payments p ON r.rental_id = p.rental_id
GROUP BY r.rental_date
ORDER BY r.rental_date;

-- 8. Identify any customers who have overdue rentals
SELECT c.*
FROM Customers c
JOIN Rentals r ON c.customer_id = r.customer_id
WHERE r.due_date < CURDATE() AND r.return_date IS NULL;

-- 9. Find the average rental price for each car category (e.g., Sedan, SUV, Hatchback)
SELECT car.category, AVG(r.rental_price_per_day) AS avg_rental_price
FROM Rentals r
JOIN Cars car ON r.car_id = car.car_id
GROUP BY car.category;

-- 10. Retrieve the top 5 most profitable cars in the fleet
SELECT car.model, SUM(p.amount) AS total_earnings
FROM Rentals r
JOIN Cars car ON r.car_id = car.car_id
JOIN Payments p ON r.rental_id = p.rental_id
GROUP BY car.model
ORDER BY total_earnings DESC
LIMIT 5;
