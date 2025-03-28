-- Let's extract user IDs from staging_sessions, eliminating duplicates.

-- Create the user dimension table

CREATE OR REPLACE TABLE `copper-site-454601-i7.analytics_star_model.dim_user` AS


SELECT DISTINCT                          -- Select distinct user identifiers from the staging table

  fullVisitorId AS full_visitor_id,      -- Primary user ID (string)

  userId AS user_id,                     -- Optional user ID (if available)

  clientId AS client_id                  -- Client ID 
  

FROM

  `copper-site-454601-i7.analytics_star_model.staging_sessions`;

