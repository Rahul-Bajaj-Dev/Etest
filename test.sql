-- 1. Create a report showing the total number of rides completed each day for the past month
SELECT ride_date, COUNT(*) AS total_rides
FROM Rides
WHERE ride_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY ride_date
ORDER BY ride_date;

-- 2. Add a new driver to the database
INSERT INTO Drivers (name, vehicle_details, license_number)
VALUES ('John Doe', 'Toyota Prius - 2022', 'XYZ123456');

-- 3. Modify a passenger's rating of a ride after it's completed
UPDATE Rides
SET passenger_rating = 4.8
WHERE ride_id = 101;  -- Replace with actual ride ID

-- 4. Remove inactive drivers (those who haven't completed a ride in the last 6 months)
DELETE FROM Drivers
WHERE driver_id IN (
    SELECT driver_id FROM Rides
    WHERE ride_date < CURRENT_DATE - INTERVAL '6 months'
);

-- 5. Generate a list of the top 10 drivers who have generated the highest revenue
SELECT driver_id, SUM(fare_amount) AS total_revenue
FROM Rides
GROUP BY driver_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 6. Retrieve all rides taken by a passenger within a specific date range
SELECT * FROM Rides
WHERE passenger_id = 5  -- Replace with actual passenger ID
AND ride_date BETWEEN '2024-02-01' AND '2024-02-28';

-- 7. Locate all rides originating from a particular city
SELECT * FROM Rides
WHERE pickup_city = 'New York';  -- Replace with the desired city

-- 8. Strategy to avoid duplicate entries for rides (Using UNIQUE constraint)
ALTER TABLE Rides
ADD CONSTRAINT unique_ride_entry UNIQUE (passenger_id, driver_id, ride_date, pickup_location, dropoff_location);

-- 9. Record the duration of each ride
ALTER TABLE Rides
ADD COLUMN ride_duration INTERVAL;

UPDATE Rides
SET ride_duration = dropoff_time - pickup_time
WHERE ride_duration IS NULL;

-- 10. Calculate the average rating given by passengers for each driver
SELECT driver_id, AVG(passenger_rating) AS average_rating
FROM Rides
GROUP BY driver_id
ORDER BY average_rating DESC;
