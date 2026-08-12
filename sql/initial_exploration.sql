WITH 
    monthly AS (
        SELECT
            FORMAT_TIMESTAMP('%Y-%m', OrderDate) AS year_month,
            FlOOR(SUM(SalesAmount)) AS revenue,
            COUNT(DISTINCT SalesOrderNumber) AS orders,
            COUNT(DISTINCT CustomerKey) AS customers,
            SUM(OrderQuantity) AS units
        FROM adventureworks.fact_internet_sales
        GROUP BY year_month
    ),
    monthly_with_previous AS (
        SELECT
            *,
            LAG(revenue) OVER (ORDER BY year_month) AS previous_revenue,
            LAG(orders) OVER (ORDER BY year_month) AS previous_orders,
            LAG(customers) OVER (ORDER BY year_month) AS previous_customers,
            LAG(units) OVER (ORDER BY year_month) AS previous_units
        FROM monthly
    )
SELECT
    year_month,
    revenue,
    ROUND(
        100.0 * (revenue - previous_revenue) / 
        NULLIF(previous_revenue, 0), 2) AS revenue_pct_change,
    orders,
    ROUND(
        100.0 * (orders - previous_orders) / 
        NULLIF(previous_orders, 0), 2) AS orders_pct_change,
    customers,
    ROUND(
        100.0 * (customers - previous_customers) / 
        NULLIF(previous_customers, 0), 2) AS customers_pct_change,
    units,
    ROUND(
        100.0 * (units - previous_units) / 
        NULLIF(previous_units, 0), 2) AS units_pct_change
FROM monthly_with_previous