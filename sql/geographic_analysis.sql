SELECT
  DATE_TRUNC(DATE(isjf.OrderDate), MONTH) AS sales_month,
  dg.EnglishCountryRegionName AS country,
  dg.StateProvinceName AS state,
  ROUND(SUM(isjf.SalesAmount), 0) AS revenue,
  COUNT(DISTINCT isjf.SalesOrderNumber) AS orders,
  COUNT(DISTINCT isjf.CustomerKey) AS customers,
  SUM(isjf.OrderQuantity) AS units
FROM adventureworks.vw_internet_sales_jan_feb_2013 isjf
LEFT JOIN adventureworks.dim_customer dc 
  ON isjf.CustomerKey = dc.CustomerKey
LEFT JOIN adventureworks.dim_geography dg 
  ON dc.GeographyKey = dg.GeographyKey
GROUP BY sales_month, country, state
HAVING COUNT(DISTINCT isjf.SalesOrderNumber) >= 10
ORDER BY country, state, sales_month;