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

With customer_rfm As (
Select customername,
current_date - MAX(orderdate) As R,
Count(Distinct ordernumber) As F,
Sum(sales) AS M
From public.sales_dataset_rfm_prj
Group By customername 
)
,rfm_score As(
Select customername, 
ntile(5) Over (Order By R DESC) As r_score, 
ntile(5) Over (order By F) As f_score, 
ntile(5) Over (Order By M) As m_score
From customer_rfm
)
,final_rfm_score As(
Select customername, 
Cast(r_score As varchar) || Cast(f_score As varchar)|| Cast(m_score As varchar) As rfm_score
From rfm_score)
Select a.customername, a.rfm_score, b.segment
From final_rfm_score As a
Join segment_score As b On a.rfm_score = b.scores
Where a.rfm_score = '555'
