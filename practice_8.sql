---EX1
/* link: https://leetcode.com/problems/immediate-food-delivery-ii/?envType=study-plan-v2&envId=top-sql-50 */
SELECT 
    ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT customer_id), 2) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id
);

---EX2
/* link: https://leetcode.com/problems/game-play-analysis-iv/description/?envType=study-plan-v2&envId=top-sql-50 */
SELECT 
    ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) as fraction
FROM 
    Activity
WHERE 
    (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
    IN 
    (
        -- Subquery: Players and their first login date
        SELECT 
            player_id,
            MIN(event_date) AS first_login
        FROM 
            Activity
        GROUP BY 
            player_id
    );
/* The Date_sub(date, Interval value interval) function subtract a time/date interval from a date then returns the date */.
    
---EX3
SELECT CASE
           WHEN s.id % 2 <> 0 AND s.id = (SELECT COUNT(*) FROM Seat) THEN s.id
           WHEN s.id % 2 = 0 THEN s.id - 1
           ELSE
               s.id + 1
           END AS id,
       student
FROM Seat AS s
ORDER BY id

---EX4
WITH Each_Day AS (
    SELECT
        visited_on,
        SUM(amount) amount
    FROM
        Customer
    GROUP BY
        visited_on
)

SELECT 
    c1.visited_on,
    SUM(c2.amount) amount,
    ROUND(AVG(c2.amount), 2) average_amount
FROM
    Each_Day AS c1
JOIN
    Each_Day AS c2 ON 
        c2.visited_on <= c1.visited_on AND
        DATEDIFF(c1.visited_on, c2.visited_on) < 7
GROUP BY
    c1.visited_on
HAVING
    COUNT(*) = 7
ORDER BY
    visited_on ASC

---EX5
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)

---EX6
SELECT Department, Employee, Salary
FROM (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (PARTITION BY d.name ORDER BY Salary DESC) AS rnk
    FROM Employee e
    JOIN Department d
    ON e.departmentId = d.id
) AS rnk_tbl
WHERE rnk <= 3;

---EX7
SELECT 
    q1.person_name
FROM Queue q1 JOIN Queue q2 ON q1.turn >= q2.turn
GROUP BY q1.turn
HAVING SUM(q2.weight) <= 1000
ORDER BY SUM(q2.weight) DESC
LIMIT 1

---EX8
select distinct p.product_id, coalesce( p2.new_price ,10) as price from Products p left join (
    select * from Products where (product_id,change_date) in (
    select product_id,max(change_date) from products
    where change_date <= '2019-08-16'
    group by product_id
)) p2 on p.product_id = p2.product_id
group by product_id
