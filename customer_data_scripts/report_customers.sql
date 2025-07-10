/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
USE DataWarehouseAnalytics;
GO

CREATE VIEW [gold.report_custome] AS

/*-- =============================================================================
1) Base Query: Retrieves Core Columns From Tables
-- =============================================================================*/
WITH base_query AS
(
SELECT
s.order_number,
s.product_key,
s.sales_amount,
s.quantity,
s.order_date,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, '  ', c.last_name) customer_name,
DATEDIFF(year,c.birthdate, GETDATE()) age
FROM DataWarehouseAnalytics..[gold.fact_sales] s
LEFT JOIN DataWarehouseAnalytics..[gold.dim_customers] c
ON c.customer_key = s.customer_key
WHERE order_date IS NOT NULL
) 

,customer_aggregation AS
/*-- =============================================================================
2) Customer Aggregations: Summarizes Key Metrics At The Customer Level 
-- =============================================================================*/
(
SELECT 
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) total_orders,
SUM(CONVERT(int, sales_amount)) total_sales,
SUM(CONVERT(int, quantity)) total_quantity,
COUNT(DISTINCT product_key) total_products,
MAX(order_date) last_order_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) lifespan
FROM base_query
GROUP BY
customer_key,
customer_number,
customer_name,
age
)

SELECT
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'UNDER 20'
	 WHEN age BETWEEN 20 AND  29 THEN '20-29'
	 WHEN age BETWEEN 30 AND  39 THEN '30-39'
	 WHEN age BETWEEN 40 AND  49 THEN '40-49'
	 ELSE '50 AND ABOVE'
END age_group,
CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
	 ELSE 'NEW'
END customer_segment,
last_order_date,
DATEDIFF(MONTH, last_order_date, GETDATE()) recency,
total_sales,
total_quantity,
total_products
lifespan,
---COMPUTE AVERAGE ORDER VALUE(AVO)
CASE WHEN total_sales = 0 THEN 0	
	 ELSE total_sales / total_orders
END avg_order_value,

---COMPUTE  AVERAGE MONTHLY SPENDING
CASE WHEN lifespan = 0 THEN total_orders
	 ELSE total_sales / lifespan
END avg_monthly_spend
FROM customer_aggregation 