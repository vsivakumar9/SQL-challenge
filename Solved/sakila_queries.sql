Use sakila;

-- 1a. Display first and last names of all actors from actor.
select count(first_name) 
  from actor;
select first_name, last_name 
  from actor;
  
-- 1b. Display the first and last name of each actor in a single column 
--    in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(upper(first_name), ' ', upper(last_name))  as 'Actor Name'
  FROM actor
;

-- 2a. You need to find the ID number, first name, and last name of an actor,
-- of whom you know only the first name, "Joe." What is one query would you 
-- use to obtain this information?
SELECT  actor_id
       ,first_name
       ,last_name 
  FROM ACTOR
 WHERE first_name = 'Joe'
;

-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT  actor_id
       ,first_name
       ,last_name 
  FROM ACTOR
 WHERE last_name like '%GEN%'
;

-- 2c. Find all actors whose last names contain the letters `LI`. 
--   This time, order the rows by last name and first name, in that order:
SELECT  actor_id
       ,first_name
       ,last_name 
  FROM ACTOR
 WHERE last_name like '%LI%'
 ORDER BY last_name, first_name
;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the
--     following countries:  Afghanistan, Bangladesh, and China
SELECT  country_id
       ,country 
  FROM  COUNTRY
 WHERE  country in ('Afghanistan','Bangladesh','China')
;

-- 3a. Add a `middle_name` column to the table `actor`. Position it between 
-- `first_name` and `last_name`. Hint: you will need to specify the data type
ALTER TABLE ACTOR ADD COLUMN middle_name varchar(45) AFTER first_name  
;

-- 3b. You realize that some of these actors have tremendously long last 
-- names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE ACTOR MODIFY middle_name BLOB;

-- 3c. Now delete the `middle_name` column.
ALTER TABLE ACTOR DROP COLUMN middle_name ;

-- 4a. List the last names of actors, as well as how many actors have that
-- last name
SELECT    last_name, count(*) as count_same_lastname
  FROM    ACTOR A 
GROUP BY  A.last_name
;

-- 4b List last names of actors and the number of actors who have that last
--    name, but only for names that are shared by at least two actors
SELECT    last_name, count(*) as count_same_lastname
  FROM    ACTOR A 
GROUP BY  A.last_name
HAVING    count_same_lastname >=2
-- ORDER BY  count_same_lastname DESC
;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the 
--     `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second 
--     cousin's husband's yoga teacher. Write a query to fix the record.
--
-- Good to do a select before the update to ensure that record exists..
SELECT * FROM ACTOR 
 WHERE first_name  = 'GROUCHO' 
   AND last_name = 'WILLIAMS'
;
UPDATE ACTOR 
   SET first_name = 'HARPO' 
 WHERE first_name  = 'GROUCHO' 
   AND last_name = 'WILLIAMS'
;
-- Performing a select after update to verify update results. 
SELECT * FROM ACTOR 
 WHERE first_name  = 'HARPO' 
   AND last_name = 'WILLIAMS'
;

/*4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
It turns out that `GROUCHO` was the correct name after all! In a single 
query, if the first name of the actor is currently `HARPO`, change it to 
`GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is
 exactly what the actor will be with the grievous error. BE CAREFUL NOT TO
 CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! 
 (Hint: update the record using a unique identifier.)
*/
SELECT *
  FROM ACTOR
 WHERE ACTOR_ID  = 172
;

-- Update with case statement to determine the update value for first_name.
UPDATE ACTOR SET first_name = 
  CASE WHEN first_name = 'HARPO'
         THEN 'GROUCHO'
		 ELSE 'MUCHO GROUCHO'
  END
 WHERE ACTOR_ID  = 172
;

SELECT first_name 
  FROM ACTOR
 WHERE ACTOR_ID  = 172
;

-- 5a. . You cannot locate the schema of the `address` table. Which query 
-- would you use to re-create it?
-- Hint: <https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html>
SHOW CREATE TABLE address ;

-- Create table query can be run after reviewing the original create
-- table DDL that is retrieved using the show.
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

/*6a. Use `JOIN` to display the first and last names, as well as the address,
  of each staff member. Use the tables `staff` and `address`:*/
SELECT   S.first_name
        ,S.last_name
        ,A.address

  FROM  STAFF   S 
  
  LEFT JOIN ADDRESS A
         ON S.address_id = A.address_id
 ;
 
 /*6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
Use tables `staff` and `payment`.*/
SELECT  P.staff_id
       ,concat(S.first_name,' ',S.last_name) as Name
       ,SUM(P.amount) as Total_Amount
  FROM PAYMENT P
  JOIN STAFF S ON P.staff_id = S.staff_id 
 GROUP BY P.staff_id
;
/*6c. List each film and the number of actors who are listed for that film. 
Use tables `film_actor` and `film`. Use inner join. */

SELECT   FA.film_id
		,F.title
		,count(FA.actor_id) as Actor_Count
  FROM   FILM_ACTOR FA
		,FILM F 
 WHERE   FA.film_id = F.film_id
 GROUP BY FA.film_id
-- ORDER BY Actor_Count DESC
;

/*6d. How many copies of the film `Hunchback Impossible` exist in the inventory system? */
SELECT  I.film_id, F.title
	   ,count(I.inventory_id) as count_copies
  FROM  INVENTORY I 
	   ,FILM F 
 WHERE  I.film_id in 
        (SELECT F.film_id FROM FILM F 
          WHERE F.title like 'Hunchback%Impossible%')
   AND I.FILM_ID = F.FILM_ID
 GROUP BY 1
 ;

/*6e. Using the tables `payment` and `customer` and the `JOIN` command, 
list the total paid by each customer. List the customers alphabetically by last name: */

select    C.first_name, C.last_name, Sum(P.amount) as Cust_Total 
  from    PAYMENT  P
	     ,CUSTOMER C
where     P.customer_id = C.customer_id
Group BY  C.last_name, C.first_name
ORDER BY  C.last_name  
;

-- 7a.
/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters `K` and `Q` have 
also soared in popularity. Use subqueries to display the titles of movies starting 
with the letters `K` and `Q` whose language is English.*/

SELECT title 
  FROM FILM F
 WHERE ((F.title like 'K%')  OR
	   (F.title like 'Q%')  AND
	   (F.language_id IN  ( Select language_id 
							from  language L
                            where L.name = 'English' )))
					                        
 ;

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
--     Film id is 17 for 'Alone Trip'
select  A.first_name, A.last_name 
  from  film_actor FA
       ,actor       A
where  FA.film_id = (SELECT FILM_ID FROM FILM F WHERE F.title = 'Alone Trip')
  and  FA.actor_id = A.actor_id
;
	
 -- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
 -- email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT C.first_name, C.last_name, C.email
  FROM CUSTOMER C
 WHERE address_id in (select  A.address_id 
                        from  ADDRESS A
                             ,CITY    CI
                             ,COUNTRY CN
                       where  A.city_id     = CI.city_id
                         AND  CI.country_id = CN.country_id
                         AND  CN.country = 'Canada')
					  
;
-- 7d.
-- Sales have been lagging among young families, and you wish to target all family movies 
-- for a promotion. Identify all movies categorized as family films.
SELECT F.title, F.description
  from FILM F
 WHERE F.film_id in 
                (select  FC.film_id 
                   from  film_category FC
                        ,Category      C
				  where  FC.category_id = C.category_id
                    and  C.name = 'Family'
                )
;				

/* 7e. Display the most frequently rented movies in descending order. */
select  I.film_id, F.title,  count(*) as count_rented
 from   rental    R 
       ,inventory I 
       ,Film      F
where   R.inventory_id = I.inventory_id
  and   I.film_id      = F.film_id
Group by I.film_id, F.title
order by count_rented Desc
;

/* 7f. Write a query to display how much business, in dollars, each store brought in. */

/* 7g. Write a query to display for each store its store ID, city, and country.*/

/* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to 
use the following tables: category, film_category, inventory, payment, and rental.)*/

/* 8a. In your new role as an executive, you would like to have an easy way of viewing 
the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view.*/

/* 8b. How would you display the view that you created in 8a?*/




