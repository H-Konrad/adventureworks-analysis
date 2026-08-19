CREATE OR REPLACE VIEW adventureworks.page_2_customers_and_products AS

WITH
  customer_first_purchase AS (
    SELECT
      CustomerKey,
      DATE_TRUNC(DateFirstPurchase, MONTH) AS first_purchase
    FROM adventureworks.dim_customer
  ),
  sales_information AS (
    SELECT
      DATE_TRUNC(DATE(OrderDate), MONTH) AS sales_month,
      CustomerKey,
      ProductKey,
      SalesAmount,
      SalesOrderNumber,
      OrderQuantity,
      UnitPrice
    FROM adventureworks.vw_internet_sales_window
  ),
  new_vs_returning AS (
    SELECT
      si.* EXCEPT(CustomerKey),
      CASE
        WHEN si.sales_month = cfp.first_purchase THEN 'new'
        ELSE 'returning'
      END AS customer_type,
    FROM sales_information si
    LEFT JOIN customer_first_purchase cfp
      ON si.CustomerKey = cfp.CustomerKey
  ),
  products AS (
    SELECT
      nvr.sales_month,
      nvr.customer_type,
      dpc.EnglishProductCategoryName AS category,
      dps.EnglishProductSubcategoryName AS subcategory,
      ROUND(SUM(nvr.SalesAmount), 0) AS revenue,
      COUNT(DISTINCT nvr.SalesOrderNumber) AS orders,
      SUM(nvr.OrderQuantity) AS units,
      ROUND(AVG(nvr.UnitPrice), 2) AS unit_price,
    FROM new_vs_returning nvr

    LEFT JOIN adventureworks.dim_product dp 
      ON nvr.ProductKey = dp.ProductKey
    LEFT JOIN adventureworks.dim_product_subcategory dps 
      ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
    LEFT JOIN adventureworks.dim_product_category dpc 
      ON dps.ProductCategoryKey = dpc.ProductCategoryKey
      
    GROUP BY nvr.customer_type, nvr.sales_month, category, subcategory
  )
SELECT
  *,
  ROUND(100.0 * revenue / SUM(revenue) OVER (PARTITION BY customer_type, sales_month), 2) AS revenue_share
FROM products
ORDER BY category, subcategory, sales_month, customer_type