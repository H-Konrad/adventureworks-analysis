SELECT
  DATE_TRUNC(DATE(isw.OrderDate), MONTH) AS sales_month,
  dg.EnglishCountryRegionName AS country,
  dg.StateProvinceName AS state,
  ROUND(SUM(isw.SalesAmount), 0) AS revenue,
  COUNT(DISTINCT isw.SalesOrderNumber) AS orders,
  COUNT(DISTINCT isw.CustomerKey) AS customers,
  SUM(isw.OrderQuantity) AS units
FROM adventureworks.vw_internet_sales_window isw
LEFT JOIN adventureworks.dim_customer dc 
  ON isw.CustomerKey = dc.CustomerKey
LEFT JOIN adventureworks.dim_geography dg 
  ON dc.GeographyKey = dg.GeographyKey
GROUP BY sales_month, country, state
HAVING COUNT(DISTINCT isw.SalesOrderNumber) >= 10
ORDER BY country, state, sales_month;