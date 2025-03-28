-- Monthly purchasing trends for top 5 customers
-- Goal: identify seasonal patterns or anomalies

-- Step 1: Let's identify the top 5 users with highest total revenue

WITH top_customers AS (

  SELECT
    fullVisitorId

  FROM
    `copper-site-454601-i7.analytics_star_model.fact_sessions`

  WHERE
    revenue_usd IS NOT NULL

  GROUP BY
    fullVisitorId

  ORDER BY
    SUM(revenue_usd) DESC

  LIMIT 5
)

-- Step 2: Let's now aggregate revenue by user and month

SELECT
  f.fullVisitorId AS user_id,                                 -- User ID

  FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', f.session_date)) AS month, -- YYYY-MM format

  ROUND(SUM(f.revenue_usd), 2) AS monthly_revenue_usd         -- Monthly total revenue

FROM
  `copper-site-454601-i7.analytics_star_model.fact_sessions` AS f

WHERE
  f.revenue_usd IS NOT NULL

  AND f.fullVisitorId IN (SELECT fullVisitorId FROM top_customers) -- Filter only top 5

GROUP BY
  user_id, month

ORDER BY
  user_id, month;


  
