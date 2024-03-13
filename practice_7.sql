---Ex1
/* link: https://datalemur.com/questions/yoy-growth-rate */
SELECT 
extract(Year From transaction_date) as Year,
product_id,
spend as curr_year_spend,
LAG(spend) Over (partition by product_id order By extract(Year From transaction_date) ) as prev_year_spend,
Round(100.0*(spend - LAG(spend) Over (partition by product_id order By extract(Year From transaction_date) ))/
LAG(spend) Over (partition by product_id order By extract(Year From transaction_date) ),2)
FROM user_transactions;

---EX2
/* lInk: https://datalemur.com/questions/card-launch-success */
WITH card_launch AS (
  SELECT 
    card_name,
    issued_amount,
    MAKE_DATE(issue_year, issue_month, 1) AS issue_date,
    MIN(MAKE_DATE(issue_year, issue_month, 1)) OVER (
      PARTITION BY card_name) AS launch_date
  FROM monthly_cards_issued
)

SELECT 
  card_name, 
  issued_amount
FROM card_launch
WHERE issue_date = launch_date
ORDER BY issued_amount DESC;

---Ex3
/* link: https://datalemur.com/questions/sql-third-transaction */
WITH trans_num AS (
  SELECT 
    user_id, 
    spend, 
    transaction_date, 
    ROW_NUMBER() OVER (
      PARTITION BY user_id ORDER BY transaction_date) AS row_num 
  FROM transactions)
 
SELECT 
  user_id, 
  spend, 
  transaction_date 
FROM trans_num 
WHERE row_num = 3;

---EX4
/* https://datalemur.com/questions/histogram-users-purchases */
WITH latest_transactions_cte AS (
  SELECT 
    transaction_date, 
    user_id, 
    product_id, 
    RANK() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date DESC) AS transaction_rank 
  FROM user_transactions) 
  
SELECT 
  transaction_date, 
  user_id,
  COUNT(product_id) AS purchase_count
FROM latest_transactions_cte
WHERE transaction_rank = 1 
GROUP BY transaction_date, user_id
ORDER BY transaction_date;

---EX5
/*link: https://datalemur.com/questions/rolling-average-tweets */
SELECT    
  user_id,    
  tweet_date,   
  ROUND(AVG(tweet_count) OVER (
    PARTITION BY user_id     
    ORDER BY tweet_date     
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
  ,2) AS rolling_avg_3d
FROM tweets;

---EX6
/*link: https://datalemur.com/questions/repeated-payments */
WITH payments AS (
  SELECT 
    merchant_id, 
    EXTRACT(EPOCH FROM transaction_timestamp - 
      LAG(transaction_timestamp) OVER(
        PARTITION BY merchant_id, credit_card_id, amount 
        ORDER BY transaction_timestamp)
    )/60 AS minute_difference 
  FROM transactions) 
/* using EPOCH to calculate the total number of seconds in a given interval.
  To calculate the difference in minutes, we divide these seconds by 60 (1 minute = 60 seconds). 
  For example, the time interval for transaction id 5 is 1 hour and 9 minutes. 
  EPOCH calculates its value as 4140 seconds. By dividing it by 60, we arrive at 69 minutes.*/
SELECT COUNT(merchant_id) AS payment_count
FROM payments 
WHERE minute_difference <= 10;

---EX7
/* https://datalemur.com/questions/sql-highest-grossing */
WITH ranked_spending_cte AS (
  SELECT 
    category, 
    product, 
    SUM(spend) AS total_spend,
    RANK() OVER (
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS ranking 
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product
)

SELECT 
  category, 
  product, 
  total_spend 
FROM ranked_spending_cte 
WHERE ranking <= 2 
ORDER BY category, ranking;

----EX8
/*link: https://datalemur.com/questions/top-fans-rank*/
WITH top_10_cte AS (
  SELECT 
    artists.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  INNER JOIN songs
    ON artists.artist_id = songs.artist_id
  INNER JOIN global_song_rank AS ranking
    ON songs.song_id = ranking.song_id
  WHERE ranking.rank <= 10
  GROUP BY artists.artist_name
)
/* why using DENSE_rank. Cause While both functions assign the same rank to duplicates, 
  RANK skips the next number in the ranking, 
  which is not suitable for this question. 
  Hence, we use DENSE_RANK, which ensures that all ranks are assigned without skipping any numbers.*/
  
SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5;
