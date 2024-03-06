---EX1 
Select COUNTRY.Continent, FLOOR(AVG(CITY.Population)) 
From  COUNTRY JOIN CITY ON CITY.CountryCode = COUNTRTY.Code
GROUP By COUNTRY.Continent;

---EX2
SELECT ROUNd(Cast(COUNT(texts.email_id) AS DECIMAL)/ 
COUNT(emails.email_id),2) As activation_rate
FROM emails LEFT JOIN texts On emails.email_id = texts.email_id
AND texts.signup_action ='Confirmed';

---EX3 - Solution 1 
SELECT age.age_bucket,
ROUND (100.0 * SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'send') /
sum(activities.time_spent),2) As send_perc,
ROUND (100.0 * SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'open') /
SUM(activities.time_spent),2) AS open_perc
FROM activities 
INNER JOIN age_breakdown AS age ON activities.user_id = age.user_id 
WHERE activities.activity_type In('send','open')
GROUP BY age.age_bucket;

---EX4
WITH supercloud AS (
SELECT 
  customers.customer_id, 
  COUNT(DISTINCT products.product_category) as unique_count
FROM customer_contracts AS customers
LEFT JOIN products 
  ON customers.product_id = products.product_id
GROUP BY customers.customer_id
)

SELECT customer_id
FROM supercloud
WHERE unique_count = (
  SELECT COUNT(DISTINCT product_category) 
  FROM products)
ORDER BY customer_id;

---EX5
SELECT Em1.employee_id, Em1.name, 
COUNT(Em2.reports_to) As reports_count, 
Round(Avg(Em2.age)) AS average_age
FROM Employees as Em1 JOIN Employees As Em2 
ON Em1.employee_id = Em2.reports_to
GROUP BY Em1.employee_id
ORDER BY Em1.employee_id

--EX6
SELECT p.product_name as product_name, sum(o.unit) As unit  
FROM Products As p JOIN Orders As o On p.product_id=o.product_id
WHERE  Year(o.order_date)='2020' AND Month(o.order_date)='02'
GROUP BY p.product_id
HAVING sum(o.unit)>=100;

---EX7
SELECT page_id
FROM pages
EXCEPT
SELECT page_id
FROM page_likes
