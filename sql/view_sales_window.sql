CREATE OR REPLACE VIEW adventureworks.vw_internet_sales_window AS

SELECT *
FROM adventureworks.fact_internet_sales
WHERE OrderDate >= '2013-01-01'
  AND OrderDate < '2013-03-01';