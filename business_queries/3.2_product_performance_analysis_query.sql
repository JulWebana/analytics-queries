-- Product Performance Analysis: Top 10 Products with Month-over-Month Growth (Q2 2017)

-- Step 1: Let's aggregate total quantity sold per product per month during Q2 (May–July 2017)

WITH product_sales_last_qtr AS (

  SELECT

    product.productSKU AS sku,  -- unique product identifier

    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', s.date)) AS year_month,  -- extract purchase month (YYYY-MM)

    SUM(product.productQuantity) AS total_quantity  -- total quantity sold for the month

  FROM
    `copper-site-454601-i7.analytics_star_model.staging_sessions` AS s,

    UNNEST(s.hits) AS hit,
    UNNEST(hit.product) AS product

  WHERE
    CAST(hit.eCommerceAction.action_type AS INT64) = 6  -- Only include completed purchases (action_type = 6)
    AND s.date BETWEEN '20170501' AND '20170731'  -- Limit to Q2 2017 (May 1 – July 31)

  GROUP BY
    sku, year_month
),

-- Step 2: Let's now compute total quantity sold per product during Q2 and select top 10 best-selling products

top_products AS (

  SELECT
    sku,  -- Product SKU
    SUM(total_quantity) AS total_qtr_quantity  -- Total Q2 quantity

  FROM
    product_sales_last_qtr

  GROUP BY
    sku

  ORDER BY
    total_qtr_quantity DESC  -- Rank by highest sales

  LIMIT 10  -- Keep top 10 products
),

-- Step 3: Let's get monthly quantity sold for top 10 products only

monthly_sales AS (

  SELECT

    product.productSKU AS sku,  -- Product identifier

    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', s.date)) AS year_month,  -- Purchase month

    SUM(product.productQuantity) AS quantity_sold  -- Quantity sold for that product per month

  FROM
    `copper-site-454601-i7.analytics_star_model.staging_sessions` AS s,

    UNNEST(s.hits) AS hit,
    UNNEST(hit.product) AS product

  WHERE
    CAST(hit.eCommerceAction.action_type AS INT64) = 6  -- Filter completed purchases
    AND s.date BETWEEN '20170501' AND '20170731'  -- Q2 2017 window
    AND product.productSKU IN (SELECT sku FROM top_products)  -- Limit to top 10 products

  GROUP BY
    sku, year_month
),

-- Step 4: Let's calculate Month-over-Month (MoM) growth for each product

monthly_growth AS (

  SELECT
    sku,  -- Product SKU

    year_month,  -- Month of sale

    quantity_sold,  -- Sales volume

    LAG(quantity_sold) OVER (PARTITION BY sku ORDER BY year_month) AS prev_month_quantity,  -- Previous month's quantity

    ROUND(
      SAFE_DIVIDE(quantity_sold - LAG(quantity_sold) OVER (PARTITION BY sku ORDER BY year_month),
                  LAG(quantity_sold) OVER (PARTITION BY sku ORDER BY year_month)) * 100,2
      
    ) AS growth_rate_pct  -- MoM % growth with safe division

  FROM
    monthly_sales
)

-- Final output: Let's finally show quantity and growth rate per product per month

SELECT *

FROM monthly_growth

ORDER BY sku, year_month;
