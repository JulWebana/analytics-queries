-- Create or replace the traffic source dimension table

CREATE OR REPLACE TABLE `copper-site-454601-i7.analytics_star_model.dim_traffic` AS


SELECT DISTINCT                       -- Select distinct traffic sources from the staging_sessions table
  
  trafficSource.source AS source,     -- Source (google, facebook, ...)


  trafficSource.medium AS medium,       -- Medium (organic, referral, cpc)


  trafficSource.campaign AS campaign,     -- Campaign name

  
  trafficSource.keyword AS keyword,       -- Keyword used in paid search

  
  trafficSource.adContent AS ad_content,   -- Content of the ad

  
  trafficSource.referralPath AS referral_path     -- Referral path (/page/link)


FROM
  `copper-site-454601-i7.analytics_star_model.staging_sessions`;
