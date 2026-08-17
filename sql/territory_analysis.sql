SELECT
  DATE_TRUNC(DATE(isjf.OrderDate), MONTH) AS sales_month,
  dst.SalesTerritoryGroup AS continent,
  dst.SalesTerritoryCountry AS country,
  ROUND(SUM(isjf.SalesAmount), 0) AS revenue,
  COUNT(DISTINCT isjf.SalesOrderNumber) AS orders,
  COUNT(DISTINCT isjf.CustomerKey) AS customers,
  SUM(isjf.OrderQuantity) AS units
FROM adventureworks.vw_internet_sales_jan_feb_2013 isjf
LEFT JOIN adventureworks.dim_sales_territory dst 
  ON isjf.SalesTerritoryKey = dst.SalesTerritoryKey
GROUP BY sales_month, continent, country
ORDER BY continent, country, sales_month;