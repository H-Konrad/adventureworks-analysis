WITH 
  applicable_promotions AS (
    SELECT
      PromotionKey,
      EnglishPromotionName AS promotion_name,
      DiscountPct
    FROM adventureworks.dim_promotion 
    WHERE 
      EndDate >= '2013-01-01' 
      AND StartDate < '2013-03-01'
  ),
  products AS (
    SELECT
      DATE_TRUNC(DATE(isjf.OrderDate), MONTH) AS sales_month,
      isjf.PromotionKey,
      isjf.SalesAmount,
      isjf.SalesOrderNumber,
      isjf.OrderQuantity,
      dpc.EnglishProductCategoryName AS category
    FROM adventureworks.vw_internet_sales_jan_feb_2013 isjf   
    
    LEFT JOIN adventureworks.dim_product dp 
      ON isjf.ProductKey = dp.ProductKey
    LEFT JOIN adventureworks.dim_product_subcategory dps 
      ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
    LEFT JOIN adventureworks.dim_product_category dpc 
      ON dps.ProductCategoryKey = dpc.ProductCategoryKey
  )
SELECT
  p.sales_month,
  p.category,
  ap.promotion_name,
  ANY_VALUE(ap.DiscountPct) AS discount_pct,
  ROUND(SUM(p.SalesAmount), 0) AS revenue,
  COUNT(DISTINCT p.SalesOrderNumber) AS orders,
  SUM(p.OrderQuantity) AS units
FROM products p
LEFT JOIN applicable_promotions ap ON p.PromotionKey = ap.PromotionKey
GROUP BY p.sales_month, p.category, ap.promotion_name
ORDER BY p.category, ap.promotion_name, p.sales_month;