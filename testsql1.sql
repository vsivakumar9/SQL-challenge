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

select * from film_actor
where film_id = (SELECT FILM_ID FROM FILM WHERE title = 'Alone Trip')
;