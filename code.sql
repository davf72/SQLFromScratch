-- TASK 1

SELECT *
FROM survey
LIMIT 10;

-- TASK 2

SELECT question,
    COUNT(DISTINCT user_id) AS 'No_of_answered_questions'
FROM survey
GROUP BY 1;

-- TASK 3

-- I used these queries to more easily observe
-- the question answer choices and the number of 
-- responses in each choice.

-- I used WHERE/LIKE '%fit?' in this case to get 
-- around the 's problem
SELECT response,
COUNT(DISTINCT user_id) AS 'No_of_responses'
FROM survey
WHERE question LIKE '%fit?'
GROUP BY 1;

SELECT response,
COUNT(DISTINCT user_id) AS 'No_of_responses'
FROM survey
WHERE question = '3. Which shapes do you like?'
GROUP BY 1;

SELECT response,
COUNT(DISTINCT user_id) AS 'No_of_responses'
FROM survey
WHERE question = '4. Which colors do you like?'
GROUP BY 1;

SELECT response,
COUNT(DISTINCT user_id) AS 'No_of_responses'
FROM survey
WHERE question = '5. When was your last eye exam?'
GROUP BY 1;


-- TASK 4

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase 
LIMIT 5;

-- TASK 5

SELECT DISTINCT q.user_id, 
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs, 
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id
LIMIT 10;

-- TASK 6 Starting Point (following Task 5)
-- Repeat of above but encased in WITH format:
WITH funnels AS (SELECT DISTINCT q.user_id, 
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs, 
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id
)

-- 6A Aggregating the results of the funnels table
WITH funnels AS (SELECT DISTINCT q.user_id, 
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs, 
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id
)

SELECT COUNT(user_id) AS 'Visitors',
 SUM(is_home_try_on) AS 'Tried_at_Home',
 SUM(is_purchase) AS 'Purchased_Glasses'
FROM funnels;

-- 6B A/B Test Results
WITH funnels AS (SELECT DISTINCT q.user_id, 
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs, 
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id
)

SELECT is_purchase, 
  COUNT(CASE WHEN number_of_pairs = '3 pairs' THEN is_home_try_on END) AS '3_pairs_sent',
  COUNT(CASE WHEN number_of_pairs = '5 pairs' THEN is_home_try_on END) AS '5_pairs_sent'
FROM funnels
GROUP BY 1;

-- 6C Most Common Results of the style Quiz
SELECT style, COUNT(*) AS 'Frequency'
FROM quiz
GROUP BY 1
ORDER BY 2;

SELECT fit, COUNT(*) AS 'Frequency'
FROM quiz
GROUP BY 1
ORDER BY 2;

SELECT shape, COUNT(*) AS 'Frequency'
FROM quiz
GROUP BY 1
ORDER BY 2;

SELECT color, COUNT(*) AS 'Frequency'
FROM quiz
GROUP BY 1
ORDER BY 2;

--6D
--Frequency of models purchased in Women's styles
SELECT model_name, COUNT(*) AS 'No. Purchased'
FROM purchase
WHERE style Like 'W%'
GROUP BY 1
ORDER BY 2 DESC;

--Frequency of colors purchased in Women's styles
SELECT color, COUNT(*) AS 'No. Purchased'
FROM purchase
WHERE style Like 'W%'
GROUP BY 1
ORDER BY 2 DESC;

--Frequency of price purchased at in Women's styles
SELECT price, COUNT(*) AS 'No. Purchased'
FROM purchase
WHERE style Like 'W%'
GROUP BY 1
ORDER BY 2 DESC;

--6E
--Frequency of models purchased in Men's styles
SELECT model_name, COUNT(*) AS 'No. Purchased'
FROM purchase
WHERE style Like 'M%'
GROUP BY 1
ORDER BY 2 DESC;

--Frequency of colors purchased in Men's styles
SELECT color, COUNT(*) AS 'No. Purchased'
FROM purchase
WHERE style Like 'M%'
GROUP BY 1
ORDER BY 2 DESC;

--Frequency of price purchased at in Men's styles
SELECT price, COUNT(*) AS 'No. Purchased'
FROM purchase
WHERE style Like 'M%'
GROUP BY 1
ORDER BY 2 DESC;

--6F
--Average price of purchases by style
SELECT style, 
	ROUND(AVG(price), 2) AS "Average sale price"
FROM purchase
GROUP BY 1;

--Overall Average price of purchases
SELECT ROUND(AVG(price), 2) AS "Overall Average Sale Price"
FROM purchase;
