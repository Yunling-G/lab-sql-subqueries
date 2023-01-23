USE sakila;
-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(inventory_id) AS num_copy
FROM inventory 
WHERE film_id IN (
	SELECT film_id 
	FROM film
	WHERE title = 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average of all the films.
SELECT title
FROM film
WHERE length > (
	SELECT AVG(length) AS average
    FROM film
);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
)
);

-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN(
	SELECT film_id 
    FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE name = 'Family'
        )
);


/*
5. Get name and email from customers from Canada using subqueries.
Do the same with joins. Note that to create a join, 
you will have to identify the correct tables with their primary keys and foreign keys, 
that will help you get the relevant information.
 */
SELECT first_name, last_name,email
FROM customer
WHERE address_id IN(
	SELECT address_id 
    FROM address
    WHERE city_id IN(
		SELECT city_id
        FROM city
        WHERE country_id IN(
			SELECT country_id
            FROM country
            WHERE country ='Canada'
            )
		)
);


/*
 6. Which are films starred by the most prolific actor? 
 Most prolific actor is defined as the actor that has acted in the most number of films. 
 First you will have to find the most prolific actor and then use that actor_id to find the different films 
 that he/she starred.
 */
SELECT title
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_actor
    WHERE actor_id IN (
		SELECT actor_id,count(film_id) AS num_film
        FROM film_actor
		GROUP BY actor_id
		ORDER BY num_film DESC
		LIMIT 1
        )
);
	
SELECT title
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_actor
    WHERE actor_id IN (
    SELECT actor_id FROM
		(SELECT actor_id,count(film_id) AS num_film
        FROM film_actor
		GROUP BY actor_id
		ORDER BY num_film DESC
		LIMIT 1) AS sub
        )
);
 
 
 /*
 7. Films rented by most profitable customer. 
 You can use the customer table and payment table to 
 find the most profitable customer ie the customer that has made the largest sum of payments
 */
 SELECT title
 fROM film
 WHERE film_id IN(
	SELECT film_id 
    FROM inventory
    WHERE store_id IN(
		SELECT store_id
        FROM customer
        WHERE customer_id IN(
			SELECT customer_id FROM 
            (SELECT customer_id,sum(amount) AS sum_payments
            FROM payment
            GROUP BY customer_id
            ORDER BY sum_payments DESC
            LIMIT 1) AS sub
            )
		)
);
 
 -- 8. Customers who spent more than the average payments.
SELECT first_name, last_name
FROM customer
WHERE customer_id IN(
	SELECT customer_id
    FROM payment
    WHERE amount > (
		SELECT average FROM(
			SELECT AVG(amount) AS average
			FROM payment) AS sub
            )
);
