SELECT
  DATE_TRUNC(DATE(fis.OrderDate), MONTH) AS sales_month,
  COALESCE(dpc.EnglishProductCategoryName, "Unlabelled") AS category,
  COALESCE(dps.EnglishProductSubcategoryName, 'Unlabelled') AS subcategory,
  FlOOR(SUM(fis.SalesAmount)) AS revenue,
  COUNT(DISTINCT fis.SalesOrderNumber) AS orders,
  SUM(fis.OrderQuantity) AS units
  
FROM adventureworks.fact_internet_sales fis

LEFT JOIN adventureworks.dim_product dp 
  ON fis.ProductKey = dp.ProductKey
LEFT JOIN adventureworks.dim_product_subcategory dps 
  ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
LEFT JOIN adventureworks.dim_product_category dpc 
  ON dps.ProductCategoryKey = dpc.ProductCategoryKey
  
WHERE fis.OrderDate >= '2013-01-01' AND fis.OrderDate < '2013-03-01'
GROUP BY sales_month, category, subcategory
ORDER BY category, subcategory, sales_month
