
# 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:

select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;

# 2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 

DELIMITER //
CREATE PROCEDURE GetCustomersByCategory(IN category_name VARCHAR(255))
BEGIN
	SELECT CONCAT(first_name,' ', last_name) AS name, email
	FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON film.film_id = inventory.film_id
	JOIN film_category ON film_category.film_id = film.film_id
	JOIN category ON category.category_id = film_category.category_id
	WHERE category.name = category_name
	GROUP BY first_name, last_name, email;
END
//
DELIMITER ;


CALL GetCustomersByCategory('Action');

SELECT A.name, COUNT(*) AS count
FROM category A
JOIN film_category B ON A.category_id = B.category_id
GROUP BY B.category_id;

#3. Write a query to check the number of movies released in each movie category. 

DELIMITER $$
CREATE PROCEDURE sp_GetMovieCount (IN minCount INT)
BEGIN
	SELECT A.name, COUNT(*) AS count
	FROM category A
	JOIN film_category B ON A.category_id = B.category_id
	GROUP BY B.category_id
    HAVING COUNT(*) > minCount;
END
$$
DELIMITER ;

CALL sp_GetMovieCount(60);