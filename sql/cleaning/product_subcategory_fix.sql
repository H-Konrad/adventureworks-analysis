CREATE OR REPLACE TABLE adventureworks.dim_product AS
SELECT
  * EXCEPT(ProductSubcategoryKey),
  SAFE_CAST(ProductSubcategoryKey AS INT64) AS ProductSubcategoryKey
FROM adventureworks.dim_product;