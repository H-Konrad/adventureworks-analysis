WITH
  customer_first_purchase AS (
    SELECT
      CustomerKey,
      DATE_TRUNC(DateFirstPurchase, MONTH) AS first_purchase
    FROM adventureworks.dim_customer
  ),
  customer_months AS (
    SELECT
      DATE_TRUNC(DATE(OrderDate), MONTH) AS sales_month,
      CustomerKey,
      ProductKey
    FROM adventureworks.vw_internet_sales_window
  ),
  new_vs_returning AS (
    SELECT
      cm.* EXCEPT(CustomerKey),
      CASE
        WHEN cm.sales_month = cfp.first_purchase THEN 'new'
        ELSE 'returning'
      END AS customer_type,
    FROM customer_months cm
    LEFT JOIN customer_first_purchase cfp
      ON cm.CustomerKey = cfp.CustomerKey
  )
SELECT
  nvr.sales_month,
  nvr.customer_type,
  dpc.EnglishProductCategoryName AS category,
  dps.EnglishProductSubcategoryName AS subcategory,
  COUNT(nvr.ProductKey) AS units_sold
FROM new_vs_returning nvr

LEFT JOIN adventureworks.dim_product dp 
  ON nvr.ProductKey = dp.ProductKey
LEFT JOIN adventureworks.dim_product_subcategory dps 
  ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
LEFT JOIN adventureworks.dim_product_category dpc 
  ON dps.ProductCategoryKey = dpc.ProductCategoryKey 

GROUP BY nvr.sales_month, category, subcategory, nvr.customer_type
ORDER BY category, subcategory, nvr.sales_month, nvr.customer_type;