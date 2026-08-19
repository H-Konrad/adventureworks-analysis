SELECT
  DATE_TRUNC(DATE(isw.OrderDate), MONTH) AS sales_month,
  dst.SalesTerritoryGroup AS continent,
  dst.SalesTerritoryCountry AS country,
  ROUND(SUM(isw.SalesAmount), 0) AS revenue,
  COUNT(DISTINCT isw.SalesOrderNumber) AS orders,
  COUNT(DISTINCT isw.CustomerKey) AS customers,
  SUM(isw.OrderQuantity) AS units
FROM adventureworks.vw_internet_sales_window isw
LEFT JOIN adventureworks.dim_sales_territory dst 
  ON isw.SalesTerritoryKey = dst.SalesTerritoryKey
GROUP BY sales_month, continent, country
ORDER BY continent, country, sales_month;