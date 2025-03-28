-- Create or replace the geographic dimension table

CREATE OR REPLACE TABLE `copper-site-454601-i7.analytics_star_model.dim_geo` AS


SELECT DISTINCT                                     -- Select distinct combinations of geographic data from the staging table
  
  geoNetwork.continent AS continent,                -- Continent name 

  geoNetwork.subContinent AS subcontinent,           -- Sub-continent name (Western Europe, Northern America,...)
  
  geoNetwork.country AS country,                    -- Country 

  geoNetwork.region AS region,                    -- Region or state 

  geoNetwork.city AS city,                      -- City name

  geoNetwork.metro AS metro,                   -- Metropolitan area

  geoNetwork.networkDomain AS network_domain,   -- Network domain

  geoNetwork.networkLocation AS network_location        -- Network location


FROM
  `copper-site-454601-i7.analytics_star_model.staging_sessions`;

