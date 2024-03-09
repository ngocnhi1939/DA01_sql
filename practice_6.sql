---EX1
WITH job_count_cte As (
Select company_id,
Count(job_id) as job_count
From job_listings
Group By company_id
Having Count(job_id) >1 )

Select Count(distinct company_id) As duplicate_companies
From job_count_cte
Where job_count > 1;

---EX2
With ranked_spending_cte As (
SELECT category,
product,
sum(spend) As total_spend,
Rank() Over ( Partition by category Order By Sum(spend) Desc) As ranking
FROM product_spend
WHERE Extract(Year From transaction_date) = 2022
Group By category, product )

SELECT 
category,
product, 
total_spend
From ranked_spending_cte
Where ranking <= 2
Order By category, ranking;

---EX3
With call_records 
As (
SELECT policy_holder_id,
Count(case_id) As call_count
FROM callers
Group By policy_holder_id
Having Count(case_id) >= 3)

Select Count(policy_holder_id) As member_count 
From call_records;

---EX4
SELECT page_id
FROM pages
Except
SELECT page_id
FROM page_likes; 

/* 2nd solution */

SELECT pages.page_id
From pages 
LEFT JOIN page_likes As likes
On pages.page_id = likes.page_id
Where likes.page_id Is Null;

---EX5
SELECT 
  EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
  COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions AS last_month
  WHERE last_month.user_id = curr_month.user_id
    AND EXTRACT(MONTH FROM last_month.event_date) =
    EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date);

---EX6
Select 
Date_FORMAT(trans_date, '%Y-%m') As Month,
country,
COUNT(id) As trans_count,
Sum (Case When state='approved' Then 1 Else 0 END) As approved_count,
Sum (amount) As trans_total_amount,
Sum (Case When state ='approved' then amount else 0 End) as approved_total_amount
From transactions
Group by month, country

---Ex7
SELECT product_id, year AS first_year, quantity, price
FROM sales s
WHERE year = (
    SELECT MIN(YEAR)
    FROM sales
    WHERE s.product_id = product_id
    GROUP BY product_id
)

---EX8
select customer_id from customer 
group by 
customer_id
having count(distinct product_key ) = (select count(product_key ) from product)

---EX9
SELECT employee_id
FROM Employees
WHERE salary < 30000
AND manager_id NOT IN 
  (SELECT employee_id FROM Employees)
ORDER BY employee_id

---EX10
SELECT employee_id, department_id
FROM Employee 
WHERE primary_flag = 'Y'
UNION
SELECT employee_id, department_id
FROM Employee 
GROUP BY employee_id
HAVING COUNT(employee_id) = 1
ORDER BY employee_id;

---EX11
(SELECT name AS results
FROM MovieRating JOIN Users USING(user_id)
GROUP BY name
ORDER BY COUNT(*) DESC, name
LIMIT 1)

UNION ALL

(SELECT title AS results
FROM MovieRating JOIN Movies USING(movie_id)
WHERE EXTRACT(YEAR_MONTH FROM created_at) = 202002
GROUP BY title
ORDER BY AVG(rating) DESC, title
LIMIT 1);

---EX12
With base as
  (select requester_id id from RequestAccepted
union all
select accepter_id id from RequestAccepted)
  
select id, count(*) num  from base group by 1 order by 2 desc limit 1
