
/*Segment products into cost ranges
and count how many products fall into each segment*/

WITH product_segment AS
(
Select 
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost BETWEEN 100 and 500 THEN '100-500'
	 WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END cost_range
from DataWarehouseAnalytics..[gold.dim_products]
)

Select 
	cost_range,
	COUNT(product_key) AS total_products
from product_segment
Group by cost_range
Order by total_products DESC 





/*Grouping customers into three segments based on their spending behavior:
	-VIP: Customers with at least 12 months of history and spending more than $5,000.
	-Regular: Customers with at least 12 months of history but spending $5,000 or less..
	-New: Customers with a lifespan less than 12 months
And finding the total number of customers by each group
*/

WITH customer_spending AS
(
Select 
c.customer_key,
SUM(CONVERT(int,s.sales_amount)) total_spending,
MIN(order_date) first_order,
MAX(order_date) last_order,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date) ) lifespan
from DataWarehouseAnalytics..[gold.fact_sales] s  LEFT JOIN
DataWarehouseAnalytics..[gold.dim_customers] c
ON s.customer_key = c.customer_key
Group by c.customer_key
)

Select
customer_segment,
COUNT(customer_key) total_customers
from
(
Select
customer_key,
total_spending,
lifespan,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'REGULAR'
	 ELSE 'NEW'
END customer_segment
from customer_spending
) t
Group by customer_segment
Order by total_customers DESC