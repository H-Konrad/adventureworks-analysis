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
      SUM(SalesAmount) AS revenue,
      COUNT(DISTINCT SalesOrderNumber) AS orders,
      SUM(OrderQuantity) AS units
    FROM adventureworks.fact_internet_sales
    WHERE OrderDate < '2013-03-01' AND OrderDate >= '2013-01-01'
    GROUP BY sales_month, CustomerKey
  ),
  new_vs_returning AS (
    SELECT
      cm.* EXCEPT(CustomerKey),
      CASE
        WHEN cm.sales_month = cfp.first_purchase THEN 'new'
        ELSE 'returning'
      END AS customer_type
    FROM customer_months cm
    LEFT JOIN customer_first_purchase cfp
      ON cm.CustomerKey = cfp.CustomerKey
  )
SELECT
  sales_month,
  customer_type,
  COUNT(customer_type) AS customers,
  ROUND(SUM(revenue), 0) AS total_revenue,
  SUM(orders) AS total_orders,
  SUM(units) AS total_units,
  ROUND(SUM(revenue)/COUNT(customer_type), 0) AS revenue_per_customer,
  ROUND(SUM(orders)/COUNT(customer_type), 2) AS orders_per_customer,
  ROUND(SUM(units)/COUNT(customer_type), 2) AS units_per_customer
FROM new_vs_returning
GROUP BY sales_month, customer_type
ORDER BY sales_month, customer_type