---EX1
SELECT name FROM STUDENTS WHERE marks>75 ORDER BY SUBSTRING(name, LEN(name) - 2, 3), ID;
---EX2
SELECT
  user_id,
  CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users;
---EX3
SELECT 
    manufacturer,
    CONCAT('$', ROUND(SUM(total_sales) / 1000000, 0), '', ' million') AS sale
FROM 
    pharmacy_sales
GROUP BY 
    manufacturer
ORDER BY 
    SUM(total_sales) DESC, manufacturer;
---EX4
SELECT
    EXTRACT(MONTH FROM submit_date) AS month,
    product_id,
    ROUND(AVG(stars), 2) AS average_stars
FROM
    reviews
GROUP BY
    month, product_id
ORDER BY
    month, product_id;
---EX5
SELECT 
  sender_id,
COUNT (message_id) AS message_count
FROM 
  messages
WHERE 
  extract(month from sent_date)=8 and extract(year from sent_date) = 2022
GROUP BY 
  sender_id
ORDER BY 
  message_count DESC
LIMIT 2
---EX6
SELECT tweet_id
FROM Tweets
WHERE length(content)>15;
---EX7
Select 
  activity_date as day, COUNT(DISTINCT user_id) as active_users
FROM 
  Activity
GROUP By 
  activity_date
Having 
  activity_date Between '2019-06-27' AND '2019-07-27'
---EX8
SELECT COUNT(employee_id) as number_employee
FROM 
  employees
WHERE 
  extract(month from joining_date) between 1 and 7 abd extract(year from joining_date)=2022;
---EX9
SELECT 
  position('a' IN first_name) As position
FROM 
  worker
WHERE 
  first_name = 'Amitah'
---EX10 
SELECT 
  substring(title, length(winery)+2,4)
FROM 
  winemag_p2
WHERE 
  country = 'Macedonia'
