WITH 
  products AS (
    SELECT
      DATE_TRUNC(DATE(isw.OrderDate), MONTH) AS sales_month,
      COALESCE(dps.EnglishProductSubcategoryName, 'Unlabelled') AS subcategory,
      SUM(isw.SalesAmount) AS revenue
    FROM adventureworks.vw_internet_sales_window isw

    LEFT JOIN adventureworks.dim_product dp 
      ON isw.ProductKey = dp.ProductKey
    LEFT JOIN adventureworks.dim_product_subcategory dps 
      ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
    LEFT JOIN adventureworks.dim_product_category dpc 
      ON dps.ProductCategoryKey = dpc.ProductCategoryKey
      
    GROUP BY sales_month, subcategory
  ),
  change_in_revenue AS (
    SELECT
      *,
      ROUND(revenue - LAG(revenue) OVER (
        PARTITION BY subcategory ORDER BY sales_month
      ), 0) AS revenue_change
    FROM products
  ),
  revenue_ranked AS (
    SELECT
      sales_month,
      subcategory,
      revenue_change,
      DENSE_RANK() OVER (ORDER BY revenue_change DESC) AS top_rank,
      DENSE_RANK() OVER (ORDER BY revenue_change) AS bottom_rank
    FROM change_in_revenue
    WHERE sales_month = '2013-02-01'
  )
SELECT
  sales_month, 
  subcategory,
  revenue_change
FROM revenue_ranked
WHERE top_rank <= 5 OR bottom_rank <= 5;