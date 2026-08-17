WITH
  customer_first_purchase AS (
    SELECT
      CustomerKey,
      DateFirstPurchase AS first_purchase
    FROM adventureworks.dim_customer
  ),
  customer_months AS (
    SELECT
      DATE_TRUNC(DATE(OrderDate), MONTH) AS sales_month,
      CustomerKey,
      ProductKey
    FROM adventureworks.vw_internet_sales_jan_feb_2013
  ),
  new_vs_old AS (
    SELECT
      cm.sales_month,
      cm.CustomerKey,
      cm.ProductKey,
      CASE
        WHEN cm.sales_month = DATE_TRUNC(cfp.first_purchase, MONTH) THEN 'new'
        ELSE 'returning'
      END AS customer_type,
    FROM customer_months cm
    LEFT JOIN customer_first_purchase cfp
      ON cm.CustomerKey = cfp.CustomerKey
  )
SELECT
  nvo.sales_month,
  nvo.customer_type,
  dpc.EnglishProductCategoryName AS category,
  dps.EnglishProductSubcategoryName AS subcategory,
  COUNT(nvo.ProductKey) AS units_sold
FROM new_vs_old nvo

LEFT JOIN adventureworks.dim_product dp 
  ON nvo.ProductKey = dp.ProductKey
LEFT JOIN adventureworks.dim_product_subcategory dps 
  ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
LEFT JOIN adventureworks.dim_product_category dpc 
  ON dps.ProductCategoryKey = dpc.ProductCategoryKey 

GROUP BY nvo.sales_month, category, subcategory, nvo.customer_type
ORDER BY category, subcategory, nvo.sales_month, nvo.customer_type