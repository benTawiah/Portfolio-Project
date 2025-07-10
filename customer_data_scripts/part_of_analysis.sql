/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
--- categories that contributed the most overall sales
 With category_sales as 
 (
 Select
 p.category,
 SUM(CONVERT(int, s.sales_amount)) total_sales
 from DataWarehouseAnalytics..[gold.fact_sales] s Left Join
 DataWarehouseAnalytics..[gold.dim_products] p 
 on s.product_key = p.product_key
 Group by category
 )
 Select
 category,
 total_sales,
SUM(total_sales) OVER() overall_sales,
CONCAT(Round((convert(float,total_sales)/ SUM(total_sales) OVER()) * 100,2),'%') percentage_of_total
 from category_sales
 Order by total_sales DESC
