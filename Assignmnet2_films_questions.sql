## ASSIGNMENT 2: Movies Database
use films;
show tables;
select * from film_category;
select * from address;
select * from language;
select * from film;
select * from film_actor;
select * from city;
select * from country;

# Q1) Which categories of movies released in 2018? Fetch with the number of movies. 
select category_id,count(title) 
from film
join film_category on film.film_id = film_category.film_id 
where release_year=2018 group by category_id ;

# Q2) Update the address of actor id 36 to “677 Jazz Street”.
update address join actor on address.address_id=actor.address_id
set address='677 Jazz Street' where actor.actor_id=36;

select actor.actor_id,address.address from address join actor
on address.address_id=actor.address_id
where actor.actor_id=36;
# Q3) Add the new actors (id : 105 , 95) in film  ARSENIC INDEPENDENCE (id:41).
select * from film_actor;
select * from film;

INSERT INTO film_actor(actor_id, film_id) 
VALUES (105,41) , (95,41) as new
ON DUPLICATE KEY UPDATE film_id = new.film_id , actor_id = new.actor_id;

# Q4) Get the name of films of the actors who belong to India.
select * from film;
select * from film_actor;
select * from actor;
select * from address;
select * from city;
select * from country;

select film.title from (((((film join film_actor on film.film_id=film_actor.film_id)
join actor on film_actor.actor_id=actor.actor_id)
join address on actor.address_id=address.address_id) 
join city on address.city_id=city.city_id) 
join country on city.country_id=country.country_id)
where country.country='India';

# Q5) How many actors are from the United States?
select country.country,count(first_name) as 'Total Actors' from (((actor join address on actor.address_id=address.address_id) join city on address.city_id=city.city_id) 
join country on city.country_id=country.country_id)
where country.country='United States' group by country.country;

# Q6) Get all languages in which films are released in the year between 2001 and 2010.
select * from language;
select * from film;
select language.name,COUNT(language.language_id) as no_of_films from language join film on language.language_id=film.language_id
where release_year between 2001 and 2010 group by language.name;

# Q7) The film ALONE TRIP (id:17) was actually released in Mandarin, update the info.

select * from film where title='Alone Trip';
update (((((film join film_actor on film.film_id=film_actor.film_id)join actor on film_actor.actor_id=actor.actor_id)
join address on actor.address_id=address.address_id) join city on address.city_id=city.city_id) join country on city.country_id=country.country_id)
set country.country ='Mandarin';

select distinct film.title,country.country from (((((film join film_actor on film.film_id=film_actor.film_id)
join actor on film_actor.actor_id=actor.actor_id) join address on actor.address_id=address.address_id)
join city on address.city_id=city.city_id) join country on city.country_id=country.country_id) where film.title='Alone Trip';

# Q8) Fetch cast details of films released during 2005 and 2015 with PG rating.
select * from film;
select * from film_actor;
select * from actor;

select actor.actor_id,actor.first_name,actor.last_name,actor.address_id from ((film join film_actor on film.film_id=film_actor.film_id)
join actor on film_actor.actor_id=actor.actor_id) where (film.release_year between 2005 and 2015 )and (film.rating='PG');

# Q9) In which year most films were released?
select release_year,count(title) as'Total movies' from film group by release_year order by count(title) desc limit 1;

# Q10) In which year least number of films were released?
select release_year,count(title) as'Total movies' from film group by release_year order by count(title)  limit 1;

#Q11) Get the details of the film with maximum length released in 2014 .
SELECT *, language.name as language 
FROM `film` 
LEFT JOIN language 
ON language.language_id = film.language_id 
WHERE film.release_year = "2014" AND film.length = (SELECT MAX(film.length) FROM film);

#Q12) Get all Sci- Fi movies with NC-17 ratings and language they are screened in.
select * from film where rating ='NC-17';
select * from film where position('space' in description)>=1 and rating ='NC-17';

#Q13) The actor FRED COSTNER (id:16) shifted to a new address:
 #055,  Piazzale Michelangelo, Postal Code - 50125 , District - Rifredi at Florence, Italy. 
#Insert the new city and update the address of the actor.
Update address join actor
on address.address_id=actor.actor_id
set address.address='055, Piazzale Michelangelo',
address.district='Rifredi',
address.city_id=(SELECT city_id
from city
where city.city='Florence'),
address.postal_code='51025'
where actor.actor_id=16;


#Q14) A new film “No Time to Die” is releasing in 2020 whose details are : 
#Title :- No Time to Die
#Description: Recruited to rescue a kidnapped scientist, globe-trotting spy James Bond finds himself hot on the trail of a mysterious villain, who's armed with a dangerous new technology.
#Language: English
#Org. Language : English
#Length : 100
#Rental duration : 6
#Rental rate : 3.99
#Rating : PG-13
#Replacement cost : 20.99
#Special Features = Trailers,Deleted Scenes
#Insert the above data.
select * from film;
INSERT INTO `film`(`title`, 
`description`, 
`release_year`, 
`language_id`, 
`original_language_id`, 
`rental_duration`, 
`rental_rate`, 
`length`, 
`replacement_cost`, 
`rating`, 
`special_features`) 
VALUES ("No Time to Die",  
"Recruited to rescue a kidnapped scientist, globe-trotting spy James Bond finds himself hot on the trail of a mysterious villain, who's armed with a dangerous new technology.", 
2020 , 
	(SELECT language.language_id 
    FROM language 
    WHERE language.name = "English"), 
    (SELECT language.language_id 
    FROM language 
    WHERE language.name = "English"), 
    6, 
    3.99, 
    100, 
    20.99, 
    "PG-13", 
    "Trailers,Deleted Scenes" );

#Q15) Assign the category Action, Classics, Drama  to the movie “No Time to Die” .

#Q16) Assign the cast: PENELOPE GUINESS, NICK WAHLBERG, JOE SWANK to the movie “No Time to Die” .

#Q17) Assign a new category Thriller  to the movie ANGELS LIFE.

#Q18) Which actor acted in most movies?

#Q19) The actor JOHNNY LOLLOBRIGIDA was removed from the movie GRAIL FRANKENSTEIN. How would you update that record?

#Q20) The HARPER DYING movie is an animated movie with Drama and Comedy. Assign these categories to the movie.

#Q21) The entire cast of the movie WEST LION has changed. The new actors are DAN TORN, MAE HOFFMAN, SCARLETT DAMON. How would you update the record in the safest way?

#Q22) The entire category of the movie WEST LION was wrongly inserted. The correct categories are Classics, Family, Children. How would you update the record ensuring no wrong data is left?

#Q23) How many actors acted in films released in 2017?
select * from film where release_year=2017;
select * from film_actor;
select film.release_year,count(actor_id) as 'No. of Actors' from film_actor join film on film_actor.film_id=film.film_id group by release_year having release_year=2017;

#Q24) How many Sci-Fi films released between the year 2007 to 2017?
select count(title) as 'Total of Sci-fi Movies' from film where position('space' in description)>=1 and release_year between 2007 and 2017;

#Q25) Fetch the actors of the movie WESTWARD SEABISCUIT with the city they live in.
select * from film;
select * from film_actor;
select * from actor;
select * from address;
select * from city;
select * from country;

select film.title,actor.first_name,city.city from (((((film join film_actor on film.film_id=film_actor.film_id)join actor on film_actor.actor_id=actor.actor_id)
join address on actor.address_id=address.address_id) join city on address.city_id=city.city_id) join country on city.country_id=country.country_id)
where film.title='WESTWARD SEABISCUIT';

#Q26) What is the total length of all movies played in 2008?
select sum(length) from film where release_year=2008;

#Q27) Which film has the shortest length? In which language and year was it released?
#select title,release_year from film group by length having length=min(length);
select min(length) from film;
select film.title,film.length,language.name,film.release_year from film join language 
on film.language_id=language.language_id where film.length=46;

#Q28) How many movies were released each year?
select release_year,count(title) as'Total movies' from film group by release_year order by release_year ;

#Q29)  How many languages of movies were released each year?.
#select count(name),film.release_year from language join film 
#on language.language_id=film.language_id group by language.name,film.release_year;
#select * from language;

#Q30) Which actor did least movies?
select distinct actor.first_name,count(film.film_id) from ((film join film_actor on film.film_id=film_actor.film_id)
join actor on film_actor.actor_id=actor.actor_id) group by  actor.first_name order by count(film.film_id) limit 1;