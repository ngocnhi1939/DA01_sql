---EX1---
SELECT productline, dealsize, year_id,
SUM(sales) As Revenue
FROM sales_dataset_rfm_prj
GROUP BY productline, dealsize, year_id
ORDER BY year_id

---EX2---
SELECT month_id, year_id,
SUM(sales) AS revenue, 
COUNT(ordernumber) AS order_number
FROM public.sales_dataset_rfm_prj
GROUP BY month_id, year_id
ORDER BY month_id, year_id

---EX3---
SELECT month_id, year_id, productline, 
SUM(sales) AS revenue, 
COUNT(ordernumber) AS order_number
FROM public.sales_dataset_rfm_prj
GROUP BY month_id, year_id, productline 
HAVING month_id = 11
ORDER BY sum(sales) DESC

---EX4--- 
WITH yearly_revenue_rank AS (
SELECT 
   year_id,
   productline,
   SUM(sales) AS revenue,
   ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC) AS rank
FROM sales_dataset_rfm_prj
WHERE country = 'UK'
GROUP BY year_id, productline
)
SELECT 
year_id, productline, revenue,rank
FROM yearly_revenue_rank
WHERE rank = 1;

---EX5---

