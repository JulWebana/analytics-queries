-- Churn Rate Analysis: Monthly churn & retention over the past year

-- Let's extract distinct users by activity month

WITH monthly_users AS (

  SELECT

    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date)) AS activity_month,  -- Convert raw date to YYYY-MM format
    fullVisitorId                                                        -- Unique user identifier

  FROM
    `copper-site-454601-i7.analytics_star_model.staging_sessions`

  GROUP BY
    activity_month, fullVisitorId
),


-- Let's count active users per month

user_activity_by_month AS (

  SELECT

    activity_month,

    COUNT(DISTINCT fullVisitorId) AS active_users  -- Total number of unique users in each month

  FROM monthly_users

  GROUP BY activity_month
),

-- Churned users identification

churned_users AS (

  SELECT

    this_month.activity_month,
    COUNT(DISTINCT this_month.fullVisitorId) AS churned_count  -- Users who were active this month but not in the next month

  FROM monthly_users AS this_month

  LEFT JOIN monthly_users AS next_month

    ON this_month.fullVisitorId = next_month.fullVisitorId

    AND DATE_ADD(PARSE_DATE('%Y-%m', this_month.activity_month), INTERVAL 1 MONTH) = PARSE_DATE('%Y-%m', next_month.activity_month)  -- match next month's user activity

  WHERE next_month.fullVisitorId IS NULL  -- filter only those who did not return

  GROUP BY this_month.activity_month
)

-- Let's combine active users and churned users and calculate churn and retention rates

SELECT

  a.activity_month,

  a.active_users,

  c.churned_count,

  ROUND(SAFE_DIVIDE(c.churned_count, a.active_users) * 100, 2) AS churn_rate_pct,       -- Percentage of users who churned

  ROUND(100 - SAFE_DIVIDE(c.churned_count, a.active_users) * 100, 2) AS retention_rate_pct  -- Percentage of users retained
  
FROM
  user_activity_by_month AS a

LEFT JOIN
  churned_users AS c

USING(activity_month)

ORDER BY activity_month;
