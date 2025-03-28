-- Create a consolidated staging table with all Google Analytics sessions
-- from August 1st, 2016 to August 1st, 2017 (one full year of data)

CREATE OR REPLACE TABLE `copper-site-454601-i7.analytics_star_model.staging_sessions` AS

-- Let's use wildcard table access to query all partitioned tables `ga_sessions_YYYYMMDD`

SELECT *
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`

WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801';  -- Filter the table partitions using _TABLE_SUFFIX to include only dates between 2016-08-01 and 2017-08-01



-- Verification
-- Let's check the min and max session dates from the staging table

SELECT
  MIN(date) AS min_date,
  MAX(date) AS max_date
FROM
  `copper-site-454601-i7.analytics_star_model.staging_sessions`;


