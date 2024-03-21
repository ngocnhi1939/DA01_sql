---Ex1---
select Count(order_id) AS total_order, Count(Distinct(user_id)) as total_user, 
format_date('%y-%m', created_at) as year_month
from bigquery-public-data.thelook_ecommerce.orders
Where format_date('%y-%m', created_at) Between '19-01'And '22-04'
Group by format_date('%y-%m', created_at);

---Ex2---
WITH MonthlyOrders AS (
    SELECT
        EXTRACT(YEAR FROM created_at) AS year,
        EXTRACT(MONTH FROM created_at) AS month,
        COUNT(DISTINCT user_id) AS distinct_users,
        SUM(sale_price) AS total_sales
    FROM
        bigquery-public-data.thelook_ecommerce.order_items
    WHERE
        created_at BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
    GROUP BY
        year, month
)

SELECT
    FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(year || '-' || month || '-01')) AS month_year,
    distinct_users,
    ROUND(total_sales / NULLIF(COUNT(*), 0), 2) AS average_order_value
FROM
    MonthlyOrders
GROUP BY
    year, month, distinct_users, total_sales
ORDER BY
    year, month;

---EX3---
WITH YoungestCustomers AS (
    SELECT
        first_name,
        last_name,
        gender,
        age,
        'youngest' AS tag
    FROM
        bigquery-public-data.thelook_ecommerce.users
    WHERE
        created_at BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
    ORDER BY
        age ASC
    LIMIT 1
),

OldestCustomers AS (
    SELECT
        first_name,
        last_name,
        gender,
        age,
        'oldest' AS tag
    FROM
        bigquery-public-data.thelook_ecommerce.users
    WHERE
        created_at BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
    ORDER BY
        age DESC
    LIMIT 1
),
AllCustomers AS (
    SELECT * FROM YoungestCustomers
    UNION ALL
    SELECT * FROM OldestCustomers
)
CREATE TEMP TABLE TempCustomerData AS (
    SELECT * FROM AllCustomers
)
SELECT
    tag,
    COUNT(*) AS customer_count
FROM
    TempCustomerData
GROUP BY
    tag;

---Ex4---
