CREATE OR REPLACE VIEW vw_ecommerce_analyst AS 
WITH 
Monthly_Summary As (
  SELECT 
Format_timestamp('%Y-%m',o.created_at) As month,
extract( Year from o.created_at) As year,
p.category As product_category,
Round(Sum (p.cost),2) As total_cost,
Sum(oi.sale_price) As TPV, 
Count(oi.order_id) As TPO,
FROM bigquery-public-data.thelook_ecommerce.orders AS o
JOIN bigquery-public-data.thelook_ecommerce.order_items As oi ON o.order_id = oi.order_id 
JOIN bigquery-public-data.thelook_ecommerce.products As p ON oi.product_id = p.id
Group By month, year, product_category 
),
Monthly_Summary_With_Growth As (
  SELECT  
    month, 
    year, 
    product_category,
    TPV,
    TPO,
    total_cost,
    CONCAT (ROUND ((TPV - LAG(TPV,1) OVER (PARTITION BY product_category ORDER BY year, month))/
    LAG(TPV,1) OVER (PARTITION BY product_category ORDER BY year, month) *100,2),'%') As revenue_growth, 
    CONCAT (ROUND ((TPO - LAG(TPO,1) OVER (PARTITION BY product_category ORDER By year, month))/
    LAG(TPO,1) OVER (PARTITION BY product_category ORDER By year, month) *100,2), '%') As order_growth
  FROM 
  Monthly_Summary
),
Monthly_Summary_With_Profit AS (
  SELECT
    month,
    year, 
    product_category, 
    TPV, 
    TPO,
    revenue_growth, 
    order_growth,
    total_cost, 
    ROUND(TPV - total_cost,2) AS total_profit
  FROM Monthly_Summary_With_Growth
)
  SELECT 
    month,
    year, 
    product_category, 
    TPV, 
    TPO,
    revenue_growth, 
    order_growth, 
    total_cost, 
    total_profit,
    CONCAT(ROUND((total_profit / total_cost) * 100,2),'%') As profit_to_cost_ratio
  FROM Monthly_Summary_With_Profit;
