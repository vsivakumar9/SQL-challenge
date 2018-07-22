USE SAKILA;


create table actor2 like actor;

--insert into actor2
select count(*) from actor2;

UPDATE `table` SET `uid` = CASE
    WHEN id = 1 THEN 2952
    WHEN id = 2 THEN 4925
    WHEN id = 3 THEN 1592
    ELSE `uid`
    END
WHERE id  in (1,2,3)
;

UPDATE ACTOR SET first_name = 
  CASE WHEN first_name = 'HARPO'
         THEN 'GROUCHO'
       ELSE
         'MUCHO GROUCHO'  
  END
 WHERE ACTOR_ID = 172
 ;
 UPDATE ACTOR SET first_name = 
  CASE WHEN first_name = 'HARPO'
         THEN 'GROUCHO'
       ELSE
         'MUCHO GROUCHO'  
  END
 WHERE ACTOR_ID = 172
 ;
 
UPDATE ACTOR2 SET first_name = 'HARPO'
 WHERE ACTOR_ID = 172
;

CREATE TABLE `address2` (
  `address_id2` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address3` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id2`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

;

SHOW CREATE TABLE address ;
--

select count(*) from address
LIMIT 5
;
select count(*) from staff limit 5;

select * from staff;
SELECT * FROM PAYMENT LIMIT 10;

SELECT * FROM FILM 
WHERE title = 'Alone Trip'
;



SELECT * FROM LANGUAGE LIMIT 10;


select * from film_actor
where film_id = 17
;

select  FA.actor_id, FA.film_id, A.first_name, A.last_name 
  from  film_actor FA
       ,actor       A
       
where  FA.film_id = (SELECT FILM_ID FROM FILM F WHERE F.title = 'Alone Trip')
  and  FA.actor_id = A.actor_id
;
select * from country 
where country = 'Canada'
;
-- canada country_id = 20

select * from address limit 10;

CUSTOMER
ADDRESS
CITY
COUNTRY

SELECT C.first_name, C.last_name, C.email_id 
  FROM CUSTOMER 
 WHERE address_id in (select  A.address_id 
                        from  ADDRESS A
                             ,CITY    CI
                             ,COUNTRY CN
                       where  A.city_id     = CI.city_id
                         AND  CI.country_id = CN.country_id
                         AND  CN.country = 'Canada'
					  
;

select  A.address_id, 
        CI.city_id, CI.country_id, CN.country
                        from  ADDRESS A
                             ,CITY    CI
                             ,COUNTRY CN
                       where  A.city_id     = CI.city_id
                         AND  CI.country_id = CN.country_id
                         AND  CN.country = 'Canada'
					  
;

-- FILM, FILM_CATEGORY, CATEGORY
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

select  FC.film_id 
                   from  film_category FC
                        ,Category      C
				  where  FC.category_id = C.category_id
                    and  C.name = 'Family'
                ;
 select * from category 
 where name = 'Family' limit 25;
 
 -- RENTAL INVENTORY 
 
 select * from rental limit 35;
 SELECT * FROM INVENTORY LIMIT 5;
 
 
 -- Use  PAYMENT, CUSTOMER, STORE,
 
 SELECT   C.store_id, Sum(P.amount) as Total_store
    From  Payment  P
         ,Customer C
         
	where  P.customer_id = C.customer_id 
      
  Group by C.store_id
;
  
select distinct store_id from store;

;
 
-- Use Store, address, city country
;

 SELECT S.store_id, CI.city, CN.country
 FROM  STORE   S
      ,ADDRESS A
      ,CITY    CI
      ,COUNTRY CN
 
 where S.address_id  = A.address_id
   and A.city_id     = CI.city_id
   and CI.country_id = CN.country_id

;

/* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to 
use the following tables: category, film_category, inventory, payment, and rental.)*/

SELECT C.name as Genre, sum(P.AMOUNT) as Gross_revenue
  FROM   PAYMENT  P
		,RENTAL   R
        ,inventory I
        ,FILM_CATEGORY FC
        ,Category  C
WHERE    P.rental_id = R.rental_id
  AND    R.inventory_id = I.inventory_id
  AND    I.film_id      = FC.film_id
  AND    FC.category_id = C.category_id
GROUP BY C.name
ORDER BY 2 DESC
LIMIT  5 
;  

    