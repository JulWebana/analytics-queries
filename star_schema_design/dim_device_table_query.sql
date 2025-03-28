-- Create or replace the device dimension table

CREATE OR REPLACE TABLE `copper-site-454601-i7.analytics_star_model.dim_device` AS


SELECT DISTINCT                               -- Select distinct device characteristics from the staging table
  
  device.deviceCategory AS device_category,     -- Device category: desktop, mobile, tablet

  
  device.operatingSystem AS operating_system,   -- Operating system: Android, iOS, Windows

 
  device.operatingSystemVersion AS os_version,    -- OS version

  
  device.browser AS browser,                      -- Browser name: Chrome, Safari, Firefox, etc.

  
  device.browserVersion AS browser_version,       -- Browser version

 
  device.mobileDeviceBranding AS device_branding,    -- Device brand (e.g. Apple, Samsung)

 
  device.mobileDeviceModel AS device_model,          -- Specific device model

  
  device.isMobile AS is_mobile                        -- Whether the device is mobile (TRUE/FALSE)


FROM
  `copper-site-454601-i7.analytics_star_model.staging_sessions`;
