use pizza_runner;
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  #Data completion:
  update customer_orders
  set extras = null
  where extras = '' or extras='null';
  
  desc customer_orders;
  
  update customer_orders
  set exclusions=null
  where exclusions in ('','null');
  
  update runner_orders
  set distance = trim(replace(distance,'km',''));
  
  update runner_orders
  set distance = null where distance ='null';
  
  update runner_orders
  set pickup_time=null where pickup_time='null';
  
  update runner_orders
  set cancellation=null where cancellation in ('','null');
  
-- update runner_orders set duration=
-- case 
--  when ISNUMERIC(LEFT(duration,1))
--  then left(duration,patindex('%[^0-9]%',duration+'t')-1)
-- else null
-- end;
  
  alter table runner_orders
  modify  distance float;
  
  -- alter table runner_orders
  -- modify duration int;
  
-- QUESTION:-
-- PART 1:-PIZZA METRICS
-- How many pizzas were ordered?
use pizza_runner;
select count(pizza_id) from customer_orders;

-- How many unique customer orders were made?
select count(distinct customer_id ) from customer_orders;
select * from customer_orders;

-- How many successful orders were delivered by each runner?
select * from runner_orders;
select runner_id,count(order_id) as 'Total Orders Delivered' 
from runner_orders
where cancellation is null
group by runner_id;

-- How many of each type of pizza was delivered?
select pizza_name,count(customer_orders.pizza_id)
from pizza_names join customer_orders
on pizza_names.pizza_id=customer_orders.pizza_id
group by pizza_name;

-- How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id,pizza_name,count(customer_orders.pizza_id) from pizza_names join customer_orders
on pizza_names.pizza_id=customer_orders.pizza_id
group by customer_id,pizza_name;

-- What was the maximum number of pizzas delivered in a single order?
select co.order_id,count(co.pizza_id) as 'Pizza Delivered' from customer_orders co join runner_orders ro
on co.order_id=ro.order_id
where cancellation is null
group by co.order_id
order by count(co.pizza_id) desc limit 1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select customer_orders.customer_id,count(customer_orders.pizza_id) , 
sum(case
when customer_orders.exclusions is not null or customer_orders.extras is not null
then 1 else 0
end) as 'atleast1_change',
sum(case 
when customer_orders.exclusions is null and customer_orders.extras is null
then 1 else 0
end) as 'no_change'
from customer_orders join runner_orders 
on customer_orders.order_id=runner_orders.order_id
where runner_orders.cancellation is null
group by customer_orders.customer_id;

-- How many pizzas were delivered that had both exclusions and extras?
create view both_changes as (select customer_id,count(pizza_id),
sum(case 
when customer_orders.exclusions is not null and customer_orders.extras is not null
then 1 else 0
end) as 'both_change'
from customer_orders join runner_orders 
on customer_orders.order_id=runner_orders.order_id
where runner_orders.cancellation is null
group by customer_orders.customer_id);
-- drop view both_changes;
select *
from both_changes
where both_change>=1;

-- What was the total volume of pizzas ordered for each hour of the day?
select * from customer_orders;
select hour(time(order_time)) as hours,count(order_id) as 'volume of pizzas'
from customer_orders
group by hour(time(order_time))
order by  hour(time(order_time));

-- What was the volume of orders for each day of the week?
select dayname(date(order_time)),count(order_id) as 'volume of pizzas'
 from customer_orders
 group by dayname(date(order_time))
 order by count(order_id) ;
 
-- Runner and Customer Experience
-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
use pizza_runner;
select * from runners;
-- select runner_id,day(registration_date),
-- lag(day(registration_date+7))over(order by runner_id) from runners;
select week(registration_date) as week
from runners;

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select runner_id,
avg(minute(timediff(pickup_time,order_time))) as avg_time_diff
 from runner_orders as ro 
 inner join customer_orders as co
 on ro.order_id=co.order_id
 where pickup_time<>'null'
 group by runner_id;

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
select co.order_id,
count(pizza_id) as 'total no. of pizzas',
max(minute(timediff(pickup_time,order_time))) as 'prep_time'
from runner_orders as ro 
 inner join customer_orders as co
 on ro.order_id=co.order_id
 where pickup_time<>'null'
 group by co.order_id;

-- What was the average distance travelled for each customer?
select customer_id,
avg(distance)
from runner_orders ro
join customer_orders co on ro.order_id=co.order_id
where distance <> 'null'
group by customer_id;

-- What was the difference between the longest and shortest delivery times for all orders?
-- select left(duration,patindex('%[^0-9]%',duration+'t')-1)
 select max(left(duration,2))-min(left(duration,2)) as 'time_diff'
 from runner_orders as ro 
 inner join customer_orders as co
 on ro.order_id=co.order_id
 where pickup_time<>'null';

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
select runner_id,avg(distance/left(duration,2)) as 'Average speed' from runner_orders
where distance<>'null'
group by runner_id,order_id;

-- What is the successful delivery percentage for each runner?
select runner_id,
(sum(case when pickup_time is null then 0
else 1
end)/count(order_id))*100 as 'success rate od deliveries'
from runner_orders
group by runner_id;

#Ingredient Optimisation
-- 1. What are the standard ingredients for each pizza?
select * from pizza_toppings;
select * from pizza_rrunnersecipes;

-- 2. What was the most commonly added extra?
-- 3. What was the most common exclusion?
-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- a) Meat Lovers
-- b) Meat Lovers - Exclude Beef
-- c) Meat Lovers - Extra Bacon
-- d) Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- (For example: "Meat Lovers: 2xBacon, Beef, ... , Salami")
-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?


#Pricing and Ratings
-- 1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
-- how much money has Pizza Runner made so far if there are no delivery fees?
use pizza_runner;
select * from pizza_names;
select sum(case when pizza_name='Meatlovers' then 12
else 10 end) as 'Total Money Earned'
from customer_orders co inner join pizza_names pn on co.pizza_id=pn.pizza_id inner join 
runner_orders ro on co.order_id = ro.order_id
WHERE cancellation IS NULL;

-- 2.What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
 select concat('$',topping_revenue+Pizza_revenue) as 'Total money earned'
 from (SELECT  sum(case when pizza_name='Meatlovers' then 12
else 10 end) as 'Pizza_revenue',sum(topping_count) as 'topping_revenue'
FROM(
 SELECT pizza_name,co.pizza_id,length(extras) - length(replace(extras, ",", ""))+1 AS topping_count
      from customer_orders co inner join pizza_names pn on co.pizza_id=pn.pizza_id inner join 
      runner_orders ro on co.order_id = ro.order_id
      where cancellation is null)t1)t2;

-- 3.The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design 
-- an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful
--  customer order between 1 to 5.
create TABLE runner_rating (order_id INTEGER, rating INTEGER, review VARCHAR(100)) ;

-- Order 6 and 9 were cancelled
INSERT INTO runner_rating
VALUES ('1', '1', 'Really bad service'),
       ('2', '1', NULL),
       ('3', '4', 'Took too long...'),
       ('4', '1','Runner was lost, delivered it AFTER an hour. Pizza arrived cold' ),
       ('5', '2', 'Good service'),
       ('7', '5', 'It was great, good service and fast'),
       ('8', '2', 'He tossed it on the doorstep, poor service'),
       ('10', '5', 'Delicious!, he delivered it sooner than expected too!');

select * from runner_rating;

-- 4.Using your newly generated table - can you join all of the information together to form a table which has the following information 
-- for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
select customer_id , co.order_id , runner_id,rating,order_time,pickup_time,
minute(timediff(pickup_time,order_time)) as time_diff,duration,distance,
round(distance*60/left(duration, 2)) AS average_speed,
count(pizza_id) as 'Total Pizzas'
from customer_orders co join runner_orders ro on co.order_id=ro.order_id join runner_rating rr on ro.order_id=rr.order_id
where pickup_time<>'null'
group by order_time;

-- 5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras
-- and each runner is paid $0.30 per kilometre traveled :- 
-- how much money does Pizza Runner have left over after these deliveries
SELECT concat('$', round(sum(pizza_cost-delivery_cost), 2)) AS pizza_runner_revenue
FROM
  (SELECT order_id,
          distance,
          sum(pizza_cost) AS pizza_cost,
          round(0.30*distance, 2) AS delivery_cost
   FROM
     (SELECT *,
             (CASE
                  WHEN pn.pizza_id = 1 THEN 12
                  ELSE 10
              END) AS pizza_cost
      from customer_orders co inner join pizza_names pn on co.pizza_id=pn.pizza_id inner join 
runner_orders ro on co.order_id = ro.order_id
      WHERE cancellation IS NULL
      ORDER BY co.order_id) t1
   GROUP BY order_id
   ORDER BY order_id) t2;
   
select co.order_id,distance,sum(Total_Money_Earned) AS pizza_cost,round(0.30*distance, 2) AS delivery_cost
from 
(select *,sum(case when pizza_name='Meatlovers' then 12
else 10 end) as 'Total_Money_Earned'
from customer_orders co inner join pizza_names pn on co.pizza_id=pn.pizza_id inner join 
runner_orders ro on co.order_id = ro.order_id
WHERE cancellation IS NULL
order by co.order_id)t1
GROUP BY order_id;

