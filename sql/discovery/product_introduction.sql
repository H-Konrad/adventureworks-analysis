SELECT
    DATE_TRUNC(DATE(StartDate), MONTH) AS introduction_month,
    COUNT(*) AS products_introduced
FROM adventureworks.dim_product
GROUP BY introduction_month
ORDER BY introduction_month;