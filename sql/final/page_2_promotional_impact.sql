CREATE OR REPLACE VIEW adventureworks.page_2_promotional_impact AS

WITH 
  applicable_promotions AS (
    SELECT
      PromotionKey
    FROM adventureworks.dim_promotion 
    WHERE 
      EndDate >= '2013-01-01' 
      AND StartDate < '2013-03-01'
      AND EnglishPromotionName != 'No Discount'
  ),
  promotional_sales AS(
    SELECT
      *
    FROM adventureworks.vw_internet_sales_window
    WHERE PromotionKey IN (
        SELECT
          *
        FROM applicable_promotions
    )
  ),
  before_pivot AS (
  SELECT
    DATE_TRUNC(DATE(OrderDate), MONTH) AS sales_month,
    'promotional_revenue' AS metrics,
    ROUND(SUM(SalesAmount), 0) AS values
  FROM promotional_sales
  GROUP BY sales_month

  UNION ALL

  SELECT
    DATE_TRUNC(DATE(OrderDate), MONTH) AS sales_month,
    'promotional_orders' AS metrics,
    COUNT(DISTINCT SalesOrderNumber) AS values
  FROM promotional_sales
  GROUP BY sales_month

  UNION ALL

  SELECT
    DATE_TRUNC(DATE(OrderDate), MONTH) AS sales_month,
    'promotional_units' AS metrics,
    SUM(OrderQuantity) AS values
  FROM promotional_sales
  GROUP BY sales_month
  )
SELECT 
  *
FROM before_pivot
PIVOT(
  SUM(values)
  FOR sales_month IN (
    DATE '2013-01-01' AS jan_2013,
    DATE '2013-02-01' AS feb_2013
  )
)