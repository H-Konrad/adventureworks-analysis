WITH
  customer_months AS (
    SELECT
      DISTINCT CustomerKey,
      DATE_TRUNC(DATE(OrderDate), MONTH) AS sales_month
    FROM adventureworks.fact_internet_sales
  ),
  customer_retention AS (
    SELECT
      previous_month.sales_month,
      COUNT(current_month.CustomerKey) AS retained_customers,
      COUNT(previous_month.CustomerKey) AS previous_customers
    FROM customer_months previous_month
    LEFT JOIN customer_months current_month
      ON previous_month.CustomerKey = current_month.CustomerKey
      AND current_month.sales_month = DATE_ADD(previous_month.sales_month, INTERVAL 1 MONTH)
    GROUP BY previous_month.sales_month
  )
SELECT
  sales_month,
  ROUND(100.0 * SAFE_DIVIDE(retained_customers, previous_customers), 2) AS retention_rate
FROM customer_retention
ORDER BY sales_month