-- Let's show a random sample of 10 rows from the staging table

SELECT

  fullVisitorId,
  visitStartTime,
  date,
  device.browser,
  geoNetwork.country,
  trafficSource.source,
  totals.pageviews,
  totals.transactions,
  totals.totalTransactionRevenue

FROM
  `copper-site-454601-i7.analytics_star_model.staging_sessions`

WHERE
  date BETWEEN '20160801' AND '20170801'

ORDER BY
  RAND()
  
LIMIT 10;


/*

-- Summary stats: session count per month

SELECT
  FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date)) AS year_month,

  COUNT(*) AS session_count

FROM
  `copper-site-454601-i7.analytics_star_model.staging_sessions`

GROUP BY
  year_month
  
ORDER BY
  year_month;

*/
