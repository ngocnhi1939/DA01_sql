---EX1
SELECT
SUM (CASE
WHEN device_type = 'laptop' Then 1 Else 0
END) as Laptops,
SUM (CASE
WHEN device_type IN ('tablet', 'phone') Then 1 Else 0
END) as Mobile_devices
FROM viewership;
---EX2
SELECT x, y, z,
CASE 
WHEN x = 13 AND y = 15 AND z = 30 THEN 'No' 
ELSE 'Yes' 
END As 'triangle'
FROM Triangle
---EX3
SELECT
  ROUND (100.0 * 
    COUNT (CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN case_id END) 
    / COUNT (case_id), 1) AS call_percentage
FROM callers;
---EX4
SELECT name 
FROM Customer 
WHERE referee_id IS NULL OR referee_id <> 2;
---EX5
select 
Case when survived = 0 THEN 0
WHEN survived = 1 THEN 1 END as survived,
SUM (Case When pclass = 1 Then 1 Else 0 END ) As first_class,
SUM (Case When pclass = 2 Then 1 Else 0 END ) As second_class,
SUM (Case when pclass = 3 Then 1 Else 0 END ) As third_class
from titanic
group by survived;
