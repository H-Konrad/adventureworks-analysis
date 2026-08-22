# AdventureWorks Sales Analysis

## Overview

A cloud-based analysis of AdventureWorks Internet sales, using Google Cloud Platform (BigQuery) and Power BI to investigate a significant discrepancy between sales volume and revenue.

### Business Question

Between January and February 2013: 
- Revenue decreased by 10.1%
- Customers increased by 119%
- Orders increased by 124.8%
- Units increased by 107.8%

So, why did revenue decrease despite the massive increase in orders, customers, and units?

## Dashboard 

### Initial Exploration

![Page 1](dashboard_images/page_1.png)

### Investigation 

![Page 2](dashboard_images/page_2.png)

## Key findings 

The analysis indicate that the decline in revenue was primarily driven by: 
- A decrease in the units sold for key revenue drivers, Mountain Bikes and Road Bikes.
- A large increase in the new customer base but a 71% decrease in revenue per new customer.
- A large increase in sales of lower-value product categories, particularly Accessories and Clothing.
 
Overall, the decline is driven by what customers purchased. Other factors such as promotional activity or geographic distribution did not provide a meaningful explanation for the change. 

## Approach

Historical monthly sales data was first examined to identify any notable anomalies across key sales metrics, including revenue, customers, orders, and units sold. The January–February 2013 decline was then chosen and investigated across: 
- Products: changes in revenue, units and revenue share across product categories and subcategories. 
- Customers: customer retention, differences in new and returning customers, and purchasing habits. 
- Promotions: changes in promotions and discount rates. 
- Geography: changes across territories and locations. 
 
The analysis is performed in BigQuery using SQL, with Power BI used to present the key findings.

## Data & Architecture

The analysis uses Microsoft's AdventureWorks sample database. The database was loaded into SQL Server Management Studio, where the required tables were extracted as CSV files and uploaded to Google Cloud Storage. The data was then loaded into BigQuery, queried, and final views were created for Power BI.

```text
AdventureWorks -> SSMS 22 -> Google Cloud Storage -> BigQuery -> Power BI
```

## Tools

- Google BigQuery 
- Google Cloud Storage
- SQL Server Management Studio 22
- Power BI