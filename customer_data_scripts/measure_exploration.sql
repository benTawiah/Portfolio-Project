/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

--Total Sales
Select 
SUM(convert(int,sales_amount )) Total_sales
from DataWarehouseAnalytics..[gold.fact_sales]

-- How many items are sold
Select 
SUM(convert(int,quantity )) Total_item_sold
from DataWarehouseAnalytics..[gold.fact_sales]

--average selling price
Select 
AVG(convert(int, price)) avg_price
from DataWarehouseAnalytics..[gold.fact_sales]


--Total number of Orders
Select 
COUNT(DISTINCT order_number) total_orders
from DataWarehouseAnalytics..[gold.fact_sales]

--TOTAL NUMBER OF PRODUCT
Select 
COUNT(product_key) total_products
from DataWarehouseAnalytics..[gold.dim_products]

--Total number of customers
Select 
COUNT(customer_id) total_customers
from DataWarehouseAnalytics..[gold.dim_customers]

--Number of customers that placed orders
Select 
COUNT(DISTINCT customer_key) order_placed
from DataWarehouseAnalytics..[gold.fact_sales] 


--Generating a report
Select'Total Sales' as measure_name, SUM(convert(int,sales_amount )) measure_value
from DataWarehouseAnalytics..[gold.fact_sales]
UNION ALL 
Select'Total Quantity' as measure_name, SUM(convert(int,quantity )) measure_value
from DataWarehouseAnalytics..[gold.fact_sales]
UNION ALL
Select 'Average Price',
AVG(convert(int, price)) 
from DataWarehouseAnalytics..[gold.fact_sales]
UNION ALL
Select 'Total Number of Orders',
COUNT(DISTINCT order_number) 
from DataWarehouseAnalytics..[gold.fact_sales]
UNION ALL
Select 'Total Number of Products',
COUNT(product_key) 
from DataWarehouseAnalytics..[gold.dim_products]
UNION ALL 
Select 'Total Number of Customers',
COUNT(customer_id) 
from DataWarehouseAnalytics..[gold.dim_customers]
UNION ALL 
Select 'Total Number of Customers Placed Orders ',
COUNT(DISTINCT customer_key) 
from DataWarehouseAnalytics..[gold.fact_sales] 



