/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/


-- Determine the first and last order date and the total duration in months
SELECT 
	 MIN(order_date) first_order_date,
	 MAX(order_date) last_order_date,
	 DATEDIFF(MONTH,MIN(order_date),  MAX(order_date)  ) order_range_year
FROM DataWarehouseAnalytics..[gold.fact_sales]


-- Find the youngest and oldest customer based on birthdate
SELECT
MIN(birthdate) oldest_birthdate,
DATEDIFF(year, MIN(birthdate), GETDATE()) oldest_age,
MAX(birthdate) yongest_birthdate,
DATEDIFF(year, MAX(birthdate), GETDATE()) youngest_age
FROM DataWarehouseAnalytics..[gold.dim_customers]