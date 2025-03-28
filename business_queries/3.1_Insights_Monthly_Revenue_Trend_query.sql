-- Monthly revenue trends for top 5 users (each as a separate column)

SELECT

  month,

  SUM(CASE WHEN user_id = '1957458976293878100' THEN monthly_revenue_usd ELSE 0 END) AS user_1,
  SUM(CASE WHEN user_id = '9417857471295131045' THEN monthly_revenue_usd ELSE 0 END) AS user_2,
  SUM(CASE WHEN user_id = '56322786726117571' THEN monthly_revenue_usd ELSE 0 END) AS user_3,
  SUM(CASE WHEN user_id = '4471415170206918415' THEN monthly_revenue_usd ELSE 0 END) AS user_4,
  SUM(CASE WHEN user_id = '9089132392240687278' THEN monthly_revenue_usd ELSE 0 END) AS user_5

FROM (

  SELECT

    f.fullVisitorId AS user_id,

    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', f.session_date)) AS month,

    ROUND(SUM(f.revenue_usd), 2) AS monthly_revenue_usd

  FROM
    `copper-site-454601-i7.analytics_star_model.fact_sessions` AS f

  WHERE

    f.revenue_usd IS NOT NULL
    AND f.fullVisitorId IN (
      '1957458976293878100',
      '9417857471295131045',
      '56322786726117571',
      '4471415170206918415',
      '9089132392240687278'
    )

  GROUP BY
    user_id, month

)
GROUP BY
  month

ORDER BY
  month;



/*
Based on the graph and query results :


1. User_1

- Shows consistent activity over several months.

- Generated a significant revenue spike in April 2017, reaching over $100K.

- This user appears to be a loyal, high-value customer with repeated purchases.


2. User_2

- Made a single large purchase in July 2017 (~$41K).

- No activity in any other month.

- This pattern indicates a one-time high spender — possibly an anomaly or a promotional campaign responder.


3- Users 3, 4, and 5

- Displayed very low or no visible revenue throughout the year.

- Their overall contributions are minimal compared to Users 1 and 2.


      Patterns & Observations :

- No clear seasonality across the year.

    - Revenue spikes are user-specific, not time-based.

    - Example: April peak for User_1, July for User_2 — not tied to holidays or common seasonal events.


- Anomalies detected:

    - User_2’s isolated spike could signal a data anomaly, fraud risk, or a bulk purchase scenario.

    - User_1 may represent a reliable customer for future retargeting or loyalty initiatives.



*/