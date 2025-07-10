/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

--Top 5 Product that generated high revenue
Select Top 5 p.product_name,
SUM(convert(int, s.sales_amount)) high_revenue
from DataWarehouseAnalytics..[gold.dim_products] p LEFT JOIN
DataWarehouseAnalytics..[gold.fact_sales] s on p.product_key = s.product_key
Group by p.product_name
Order by high_revenue DESC


Select *
from(
	Select  p.product_name,
	SUM(convert(int, s.sales_amount)) high_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM (convert(int, s.sales_amount))DESC) rank_product
	from DataWarehouseAnalytics..[gold.dim_products] p LEFT JOIN
	DataWarehouseAnalytics..[gold.fact_sales] s on p.product_key = s.product_key
	Group by p.product_name
	
	)t
Where rank_product <=5




---Worse performing product interms of sales

Select TOP 5 p.product_name,
SUM(convert(int, s.sales_amount)) high_revenue
from DataWarehouseAnalytics..[gold.dim_products] p LEFT JOIN
DataWarehouseAnalytics..[gold.fact_sales] s on p.product_key = s.product_key
Group by p.product_name
Order by high_revenue 

---TOTAL NUMBER OF CUSTUMERS
Select
COUNT(customer_id) number_of_customers
from DataWarehouseAnalytics..[gold.dim_customers]

---Total Number of customers that placed orders
Select
COUNT(DISTINCT customer_key) number_of_customers
from DataWarehouseAnalytics..[gold.dim_customers]


--Top 10 Customers with highest revenue

Select Top 10  c.customer_key,c.first_name, c.last_name,
SUM(convert(int, s.sales_amount)) high_revenue
from DataWarehouseAnalytics..[gold.dim_customers] c LEFT JOIN
DataWarehouseAnalytics..[gold.fact_sales] s on c.customer_key = s.customer_key
Group by c.customer_key, c.first_name, c.last_name
Order by high_revenue DESC


---3 customers with lower order placed
Select Top 3 c.customer_key, c.first_name, c.last_name,
COUNT( DISTINCT s.order_number) TOTAL_ORDERS
from DataWarehouseAnalytics..[gold.dim_customers] c LEFT JOIN
DataWarehouseAnalytics..[gold.fact_sales] s on c.customer_key = s.customer_key
Group by c.customer_key, c.first_name, c.last_name
Order by TOTAL_ORDERS









