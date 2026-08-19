WITH 
  products AS (
    SELECT
      DATE_TRUNC(DATE(isw.OrderDate), MONTH) AS sales_month,
      COALESCE(dpc.EnglishProductCategoryName, "Unlabelled") AS category,
      COALESCE(dps.EnglishProductSubcategoryName, 'Unlabelled') AS subcategory,
      ROUND(SUM(isw.SalesAmount), 0) AS revenue,
      COUNT(DISTINCT isw.SalesOrderNumber) AS orders,
      SUM(isw.OrderQuantity) AS units,
      ROUND(AVG(isw.UnitPrice), 2) AS unit_price,
      ROUND(SUM(isw.SalesAmount) / SUM(isw.OrderQuantity), 2) AS revenue_per_unit
      
    FROM adventureworks.vw_internet_sales_window isw

    LEFT JOIN adventureworks.dim_product dp 
      ON isw.ProductKey = dp.ProductKey
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