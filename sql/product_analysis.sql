WITH 
  products AS (
    SELECT
      DATE_TRUNC(DATE(isjf.OrderDate), MONTH) AS sales_month,
      COALESCE(dpc.EnglishProductCategoryName, "Unlabelled") AS category,
      COALESCE(dps.EnglishProductSubcategoryName, 'Unlabelled') AS subcategory,
      ROUND(SUM(isjf.SalesAmount), 0) AS revenue,
      COUNT(DISTINCT isjf.SalesOrderNumber) AS orders,
      SUM(isjf.OrderQuantity) AS units,
      ROUND(AVG(isjf.UnitPrice), 2) AS unit_price,
      ROUND(SUM(isjf.SalesAmount) / SUM(isjf.OrderQuantity), 2) AS revenue_per_unit
      
    FROM adventureworks.vw_internet_sales_jan_feb_2013 isjf

    LEFT JOIN adventureworks.dim_product dp 
      ON isjf.ProductKey = dp.ProductKey
    LEFT JOIN adventureworks.dim_product_subcategory dps 
      ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
    LEFT JOIN adventureworks.dim_product_category dpc 
      ON dps.ProductCategoryKey = dpc.ProductCategoryKey
      
    GROUP BY sales_month, category, subcategory
  )
SELECT
  *,
  ROUND(100.0 * revenue / SUM(revenue) OVER (PARTITION BY sales_month), 2) AS revenue_share
FROM products
ORDER BY category, subcategory, sales_month;