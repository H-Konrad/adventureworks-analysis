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
      SUM(SalesAmount) AS revenue,
      COUNT(DISTINCT SalesOrderNumber) AS orders,
      SUM(OrderQuantity) AS units
    FROM adventureworks.fact_internet_sales
    GROUP BY sales_month, CustomerKey
  ),
  new_vs_old AS (
    SELECT
      cm.sales_month,
      cm.CustomerKey,
      CASE
        WHEN cm.sales_month = DATE_TRUNC(cfp.first_purchase, MONTH) THEN 'new'
        ELSE 'returning'
      END AS customer_type,
      cm.revenue,
      cm.orders,
      cm.units
    FROM customer_months cm
    LEFT JOIN customer_first_purchase cfp
      ON cm.CustomerKey = cfp.CustomerKey
  )
SELECT
  sales_month,
  customer_type,
  COUNT(customer_type) AS customers,
  ROUND(SUM(revenue), 0) AS revenue,
  SUM(orders) AS orders,
  SUM(units) AS units,
  ROUND(SUM(revenue)/COUNT(customer_type), 2) AS revenue_per_customer,
  ROUND(SUM(orders)/COUNT(customer_type), 2) AS orders_per_customer,
  ROUND(SUM(units)/COUNT(customer_type), 2) AS units_per_customer
FROM new_vs_old
GROUP BY sales_month, customer_type
ORDER BY sales_month, customer_type