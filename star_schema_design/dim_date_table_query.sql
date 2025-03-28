-- Create the date dimension table

CREATE OR REPLACE TABLE `copper-site-454601-i7.analytics_star_model.dim_date` AS


SELECT DISTINCT                                       -- Select unique dates and extract useful temporal attributes

  PARSE_DATE('%Y%m%d', date) AS date,               -- Raw date

  EXTRACT(YEAR FROM PARSE_DATE('%Y%m%d', date)) AS year, -- Year

  EXTRACT(MONTH FROM PARSE_DATE('%Y%m%d', date)) AS month, -- Month

  EXTRACT(DAY FROM PARSE_DATE('%Y%m%d', date)) AS day,     -- Day

  FORMAT_DATE('%A', PARSE_DATE('%Y%m%d', date)) AS day_name, -- Day name 

  FORMAT_DATE('%B', PARSE_DATE('%Y%m%d', date)) AS month_name, -- Month name 

  EXTRACT(DAYOFWEEK FROM PARSE_DATE('%Y%m%d', date)) AS day_of_week, -- 1 (Sunday) to 7 (Saturday)

  EXTRACT(WEEK FROM PARSE_DATE('%Y%m%d', date)) AS week_number -- Week of the year

  
FROM
  `copper-site-454601-i7.analytics_star_model.staging_sessions`;
