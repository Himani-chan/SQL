use new_schema;
CREATE TABLE sales(
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
  /* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT SALES.CUSTOMER_ID,SUM(PRICE) FROM SALES INNER JOIN MENU
ON SALES.PRODUCT_ID=MENU.PRODUCT_ID
GROUP BY CUSTOMER_ID;

-- 2. How many days has each customer visited the restaurant?
SELECT CUSTOMER_ID,COUNT(ORDER_DATE) FROM SALES
GROUP BY CUSTOMER_ID;

-- 3. What was the first item from the menu purchased by each customer?
WITH CTE AS (SELECT CUSTOMER_ID,ORDER_DATE,PRODUCT_NAME,
row_number() OVER(partition by CUSTOMER_ID ORDER by CUSTOMER_ID) AS FIRST_ITEM
FROM SALES INNER JOIN MENU
ON SALES.PRODUCT_ID=MENU.PRODUCT_ID)
SELECT CUSTOMER_ID,
PRODUCT_NAME FROM CTE
WHERE FIRST_ITEM=1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT PRODUCT_NAME,COUNT(SALES.PRODUCT_ID) AS 'Times purchased' FROM SALES INNER JOIN MENU
ON SALES.PRODUCT_ID=MENU.PRODUCT_ID
group by PRODUCT_NAME
ORDER BY COUNT(SALES.PRODUCT_ID) DESC LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH CTEE AS (SELECT CUSTOMER_ID,PRODUCT_NAME,COUNT(SALES.PRODUCT_ID) AS 'Times purchased',
RANK() OVER(partition by CUSTOMER_ID ORDER BY COUNT(SALES.PRODUCT_ID) DESC) AS RN
 FROM SALES INNER JOIN MENU
ON SALES.PRODUCT_ID=MENU.PRODUCT_ID
group by PRODUCT_NAME,CUSTOMER_ID)
SELECT CUSTOMER_ID,
PRODUCT_NAME FROM CTEE
WHERE RN=1 ;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT * FROM MEMBERS;

WITH CTE AS (SELECT SALES.CUSTOMER_ID,ORDER_DATE,JOIN_DATE,PRODUCT_NAME,
row_number() OVER(PARTITION BY SALES.CUSTOMER_ID ORDER BY ORDER_DATE) AS RN
FROM (MENU JOIN SALES ON MENU.PRODUCT_ID-SALES.PRODUCT_ID) INNER JOIN MEMBERS
ON SALES.CUSTOMER_ID=MEMBERS.CUSTOMER_ID
WHERE ORDER_DATE>=JOIN_DATE)
SELECT CUSTOMER_ID,PRODUCT_NAME
FROM CTE 
WHERE RN=1;

-- 7. Which item was purchased just before the customer became a member?
WITH CTE AS (SELECT SALES.CUSTOMER_ID,ORDER_DATE,JOIN_DATE,PRODUCT_NAME,
row_number() OVER(PARTITION BY SALES.CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS RN
FROM (MENU JOIN SALES ON MENU.PRODUCT_ID-SALES.PRODUCT_ID) INNER JOIN MEMBERS
ON SALES.CUSTOMER_ID=MEMBERS.CUSTOMER_ID
WHERE ORDER_DATE<JOIN_DATE)
SELECT CUSTOMER_ID,ORDER_DATE,PRODUCT_NAME 
FROM CTE 
WHERE RN=1;

-- 8. What is the total items and amount spent for each member before they became a member?
 CREATE VIEW DANNY_KITCHEN AS (SELECT SALES.CUSTOMER_ID,ORDER_DATE,JOIN_DATE,PRODUCT_NAME,PRICE
FROM (MENU JOIN SALES ON MENU.PRODUCT_ID-SALES.PRODUCT_ID) INNER JOIN MEMBERS
ON SALES.CUSTOMER_ID=MEMBERS.CUSTOMER_ID
WHERE ORDER_DATE<JOIN_DATE);
SELECT SALES.CUSTOMER_ID,ORDER_DATE,PRODUCT_NAME,PRICE
FROM (MENU RIGHT JOIN SALES ON MENU.PRODUCT_ID-SALES.PRODUCT_ID) LEFT JOIN MEMBERS
ON SALES.CUSTOMER_ID=MEMBERS.CUSTOMER_ID;
#SELECT CUSTOMER_ID,PRODUCT_NAME,COUNT(PRODUCT_NAME),SUM(PRICE)
#FROM DANNY_KITCHEN1
#GROUP BY CUSTOMER_ID,PRODUCT_NAME;

-- 8. What is the total items and amount spent for each member before they became a member?
 CREATE VIEW DANNY_KITCHEN1 AS (SELECT SALES.CUSTOMER_ID,ORDER_DATE,PRODUCT_NAME,PRICE
FROM (MENU RIGHT JOIN SALES ON MENU.PRODUCT_ID-SALES.PRODUCT_ID) LEFT JOIN MEMBERS
ON SALES.CUSTOMER_ID=MEMBERS.CUSTOMER_ID
WHERE ORDER_DATE<JOIN_DATE OR JOIN_DATE IS NULL);

SELECT CUSTOMER_ID,COUNT(CUSTOMER_ID),SUM(PRICE)
FROM DANNY_KITCHEN1 
GROUP BY CUSTOMER_ID;

DROP VIEW DANNY_KITCHEN1;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select customer_id,
sum(case
when product_name='sushi' then price*10*2
else price*10
end) as points
from menu join sales
on menu.product_id=sales.product_id
group by customer_id;



-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January?
WITH program_last_day_cte AS
  (SELECT join_date, DATE_ADD(join_date, INTERVAL 7 DAY) AS program_last_date,customer_id FROM members)
SELECT s.customer_id,
       SUM(CASE
               WHEN order_date BETWEEN join_date AND program_last_date THEN price*10*2
               WHEN order_date NOT BETWEEN join_date AND program_last_date
                    AND product_name = 'sushi' THEN price*10*2
               WHEN order_date NOT BETWEEN join_date AND program_last_date
                    AND product_name != 'sushi' THEN price*10
           END) AS customer_points FROM menu AS m INNER JOIN sales AS s ON m.product_id = s.product_id
INNER JOIN program_last_day_cte AS mem ON mem.customer_id = s.customer_id
AND order_date <='2021-01-31' AND order_date >=join_date GROUP BY s.customer_id ORDER BY s.customer_id;



