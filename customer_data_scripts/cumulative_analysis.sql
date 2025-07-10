/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

--TOTAL SALES PER MONTH And Running Total Sales over time
Select
order_date,
total_sales,
SUM(total_sales) OVER(Order by order_date) running_total_sales,
AVG(avg_price) OVER(Order by order_date) moving_average_price
--Windows Function
From
(
Select  
DATETRUNC(YEAR, order_date) order_date,
SUM(CONVERT(int, sales_amount)) total_sales,
AVG (convert(int, price)) avg_price
from DataWarehouseAnalytics..[gold.fact_sales]
Where order_date is not null
Group by DATETRUNC(YEAR, order_date)
) t
Order by DATETRUNC(YEAR, order_date)