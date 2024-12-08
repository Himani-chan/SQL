use foodiefi ;

# Data Analysis Questions
-- 1) How many customers has Foodie-Fi ever had?
select count(customer_id) as 'Total Customers' from subscriptions;

-- 2) What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
select month(start_date),count(customer_id) from plans p join subscriptions s on p.plan_id = s.plan_id
WHERE p.plan_id=0
GROUP BY month(start_date)
order by month(start_date);

-- 3) What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT plan_name,count(start_date) AS 'count of events'
from plans p join subscriptions s on p.plan_id = s.plan_id
WHERE year(start_date) > 2020
group by plan_name;

-- 4) What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
select count(customer_id) as 'Total no. Of Customers',round(100*count(customer_id)/
(select count(distinct customer_id) from subscriptions),1) as 'churned percentage'
from plans p join subscriptions s on p.plan_id = s.plan_id
where plan_name = 'churn';

-- 5) How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
with next_plan_cte as (SELECT *,lead(plan_id, 1) over(PARTITION BY customer_id
ORDER BY start_date) AS next_plan
FROM subscriptions),churner as (select * from next_plan_cte where next_plan=4 and plan_id = 0)
select count(customer_id) as 'Total no. Of Customers',round(100*count(customer_id)/
(select count(distinct customer_id) from subscriptions),1) as 'churned percentage' from churner;

-- 6) What is the number and percentage of customer plans after their initial free trial?
select * from plans;
select plan_name,count(customer_id) as 'Total no. Of Customers',round(100*count(customer_id)/
(select count(distinct customer_id) from subscriptions),1) as 'customer percentage'
from plans p join subscriptions s on p.plan_id = s.plan_id where p.plan_id<>0
group by plan_name;

-- 7) What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
-- 8) How many customers have upgraded to an annual plan in 2020?
-- 9) How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
-- 10) Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
-- 11) How many customers downgraded from a pro monthly to a basic monthly plan in 2020?