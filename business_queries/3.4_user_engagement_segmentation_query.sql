-- Let's aggregate engagement metrics per user


WITH user_engagement AS (

  SELECT

    fullVisitorId AS user_id,

    COUNT(*) AS total_sessions,                  -- Number of sessions per user

    SUM(totals.pageviews) AS total_pageviews,    -- Total pages viewed

    SUM(totals.timeOnSite) AS total_time_spent,  -- Time spent on site in seconds

    SUM(totals.transactions) AS total_transactions, -- Total purchases

    SUM(totals.totalTransactionRevenue) / 1e6 AS total_revenue  -- Revenue in USD (divide by 1M because revenue is in micros)


  FROM
    `copper-site-454601-i7.analytics_star_model.staging_sessions`

  GROUP BY
    fullVisitorId

),


-- Let's now define engagement level based on total pageviews

user_segments AS (

  SELECT

    user_id,
    total_sessions,
    total_pageviews,
    total_time_spent,
    total_transactions,
    total_revenue,
    
    -- Segment logic (can be adjusted based on distribution)

    CASE

      WHEN total_pageviews < 5 THEN 'Low'
      WHEN total_pageviews BETWEEN 5 AND 20 THEN 'Medium'

      ELSE 'High'

    END AS engagement_level

  FROM
    user_engagement
),

-- Let's analyze revenue and behavior per segment

segment_analysis AS (

  SELECT

    engagement_level,

    COUNT(user_id) AS user_count,

    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_user,

    ROUND(AVG(total_sessions), 1) AS avg_sessions,

    ROUND(AVG(total_pageviews), 1) AS avg_pageviews,

    ROUND(AVG(total_time_spent), 1) AS avg_time_spent,

    ROUND(AVG(total_transactions), 2) AS avg_transactions

  FROM
    user_segments

  GROUP BY
    engagement_level
)

-- Engagement segmentation summary

SELECT *

FROM segment_analysis

ORDER BY 

  CASE 

    WHEN engagement_level = 'Low' THEN 1
    WHEN engagement_level = 'Medium' THEN 2
    WHEN engagement_level = 'High' THEN 3

  END;



  

