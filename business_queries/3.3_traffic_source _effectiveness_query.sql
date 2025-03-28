-- Traffic Source Effectiveness: Conversion Rate per Traffic Source (last 6 months)

-- Let's extract traffic source performance data from staging_sessions

WITH traffic_data AS (

  SELECT

    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', s.date)) AS year_month,  -- Monthly granularity

    trafficSource.source AS traffic_source,                          -- Traffic source name

    COUNT(DISTINCT s.fullVisitorId) AS total_visits,                   -- Total sessions (by visitor ID)
    
    COUNT(DISTINCT IF(hit.eCommerceAction.action_type = '6', s.fullVisitorId, NULL)) AS conversions     -- count conversions: sessions with at least one completed purchase

  FROM
    `copper-site-454601-i7.analytics_star_model.staging_sessions` AS s,

    UNNEST(s.hits) AS hit

  WHERE
    date BETWEEN '20170201' AND '20170731'  -- Adjust this window based on your latest available data (last 6 months)

  GROUP BY
    year_month, traffic_source
),

-- Let's now compute conversion rates

conversion_rates AS (

  SELECT

    year_month,
    traffic_source,
    total_visits,
    conversions,

    ROUND(SAFE_DIVIDE(conversions, total_visits) * 100, 2) AS conversion_rate_pct

  FROM
    traffic_data
)

-- Conversion rate evolution per traffic source

SELECT *

FROM conversion_rates

ORDER BY traffic_source, year_month;
