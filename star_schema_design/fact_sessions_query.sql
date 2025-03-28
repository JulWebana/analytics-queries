-- Create the fact table that aggregates session-level metrics

CREATE OR REPLACE TABLE `copper-site-454601-i7.analytics_star_model.fact_sessions` AS

SELECT                                  -- Unique session ID 
  
  fullVisitorId,
  visitId,

  date AS session_date,                 -- Session date 

  fullVisitorId AS user_id,             -- User ID 

  
  geoNetwork.country AS country,        -- Geography dimension keys


  -- Device dimension keys
  device.deviceCategory AS device_category,
  device.operatingSystem AS operating_system,
  device.browser AS browser,

  -- Traffic source dimension keys
  trafficSource.source AS source,
  trafficSource.medium AS medium,
  trafficSource.campaign AS campaign,

  
  totals.pageviews AS pageviews,          -- Number of pageviews during the session

 
  totals.visits AS visits,                -- Number of visits (usually 1)


  totals.transactions AS transactions,    -- Number of transactions

  
  totals.totalTransactionRevenue AS total_transaction_revenue,       -- Raw transaction revenue (in micros)
  

  ROUND(totals.totalTransactionRevenue / 1e6, 2) AS revenue_usd       -- Transaction revenue converted to USD



FROM
  `copper-site-454601-i7.analytics_star_model.staging_sessions`;




