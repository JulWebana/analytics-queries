
-- Let's identify the top 5 customers with the highest total purchase amounts over the past year.


SELECT

  f.fullVisitorId AS user_id,                     -- Unique user identifier

  ROUND(SUM(f.revenue_usd), 2) AS total_revenue   -- Total revenue per user in USD

FROM
  `copper-site-454601-i7.analytics_star_model.fact_sessions` AS f


WHERE
  f.revenue_usd IS NOT NULL                       -- Only include sessions that generated revenue

GROUP BY
  user_id                                         -- Group by user

ORDER BY
  total_revenue DESC                              -- Sort from highest to lowest

LIMIT 5;                                          -- Keep only the top 5 users
