WITH applicable_promotions AS (
  SELECT
    PromotionKey,
    EnglishPromotionName,
    DiscountPct
  FROM adventureworks.dim_promotion 
  WHERE 
    EndDate >= '2013-01-01' 
    AND StartDate < '2013-03-01'
)
SELECT
  DATE_TRUNC(DATE(isjf.OrderDate), MONTH) AS sales_month,
  ap.EnglishPromotionName,
  ap.DiscountPct,
  COUNT(DISTINCT isjf.SalesOrderNumber) AS orders,
  SUM(isjf.OrderQuantity) AS units,
  ROUND(SUM(isjf.SalesAmount), 2) AS revenue
FROM adventureworks.vw_internet_sales_jan_feb_2013 isjf
LEFT JOIN applicable_promotions ap ON isjf.PromotionKey = ap.PromotionKey
GROUP BY sales_month, ap.EnglishPromotionName, ap.DiscountPct
ORDER BY ap.EnglishPromotionName, sales_month

-- cte for subcategory of products that were sold to combine with products table