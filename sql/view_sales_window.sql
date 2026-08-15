CREATE OR REPLACE VIEW adventureworks.vw_internet_sales_jan_feb_2013 AS

SELECT *
FROM adventureworks.fact_internet_sales
WHERE OrderDate >= '2013-01-01'
  AND OrderDate < '2013-03-01';