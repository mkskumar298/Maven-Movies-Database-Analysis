USE MAVENMOVIES;
-- 1. Rental Trends
-- 1.1 Analyze the monthly rental trends over the available data period.
SELECT 
DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
COUNT(rental_id) AS rental_count
FROM rental
GROUP BY rental_month
ORDER BY rental_month;

-- 1.2 Determine the peak rental hours in a day based on rental transactions
SELECT
HOUR(rental_date) AS rental_hour,
COUNT(*) AS rental_count
FROM rental
GROUP BY rental_hour
ORDER BY rental_count DESC;
-- 2. Film Popularity
-- 2.1 Identify the top 10 most rented films.

SELECT f.title,
COUNT(r.rental_id) AS rental_count
FROM film f 
INNER JOIN  inventory i on f.film_id = i.film_id
INNER JOIN rental r on i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

-- 2.2 Determine which film categories have the highest number of rentals.
SELECT 
cg.name AS top_category,
COUNT(rental_id) AS rental_count
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category cg ON fc.category_id = cg.category_id
GROUP BY
top_category
ORDER BY
rental_count DESC;

-- 3. Store Performance
-- 3.1 Identify which store generates the highest rental revenue.
SELECT
s.store_id,
SUM(p.amount) AS total_revenue
FROM payment p
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;

-- 3.2 Determine the distribution of rentals by staff members to assess performance.
SELECT 
s.staff_id,CONCAT(s.first_name,space(1),s.last_name) AS Staff_name,
COUNT(r.rental_id) AS total_rentals,
(COUNT(rental_id) / (SELECT COUNT(*) FROM rental) * 100) AS rental_percentage
FROM rental r 
INNER JOIN staff s ON r.staff_id = s.staff_id
GROUP BY s.staff_id,staff_name
ORDER BY total_rentals DESC;


