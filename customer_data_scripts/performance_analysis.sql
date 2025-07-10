/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/


/*Analyzing the unit performance of product by comparing each product's sales to both
 average sales performance and the previous years sales*/
With yearly_product_sales AS
(
SELECT 
YEAR(s.order_date) Order_Year,
p.product_name,
SUM(convert(int,s.sales_amount)) Current_Sales
 FROM 
 DataWarehouseAnalytics..[gold.fact_sales] s 
 LEFT JOIN  DataWarehouseAnalytics..[gold.dim_products] p
 on s.product_key = p.product_key
 Where s.order_date is not null
 Group by YEAR(s.order_date), p.product_name
 )

 Select 
Order_Year,
product_name,
Current_Sales,
AVG(Current_Sales) OVER(Partition by product_name) avg_sales,
Current_Sales - AVG(Current_Sales) OVER(Partition by product_name) diff_avg,
Case When 
	Current_Sales - AVG(Current_Sales) OVER(Partition by product_name) > 0	Then 'Above Average'
	 When 
	Current_Sales - AVG(Current_Sales) OVER(Partition by product_name) < 0	Then 'Below Average'
	Else 'Average'
End avg_change,
LAG(Current_Sales) OVER (Partition by product_name Order by order_year) previous_year_sales,
Current_sales - LAG(Current_Sales) OVER (Partition by product_name Order by order_year) different_in_previous_year,
Case When 
	Current_Sales - LAG(Current_Sales) OVER (Partition by product_name Order by order_year) > 0	Then 'Increase'
	 When 
	Current_Sales - LAG(Current_Sales) OVER (Partition by product_name Order by order_year) < 0	Then 'Decrease'
	Else 'No change'
End diff_change

 from yearly_product_sales
 Order by product_name, Order_Year
