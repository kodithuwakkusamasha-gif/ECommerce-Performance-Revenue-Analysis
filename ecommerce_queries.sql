select *
from ecom.dbo.ecom

-- 2. Check for missing values (Data Profiling)
SELECT 
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Missing_Orders,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS Missing_Customers,
    SUM(CASE WHEN revenue IS NULL THEN 1 ELSE 0 END) AS Missing_Revenue
FROM dbo.ecom;

--key performance indicator 

SELECT 
    ROUND(SUM(revenue), 2) AS Total_Revenue,
    SUM(quantity) AS Total_Units_Sold,
    COUNT(DISTINCT order_id) AS Total_Orders,
    ROUND(AVG(customer_rating), 2) AS Avg_Customer_Rating
FROM dbo.ecom;

--Product Category Performance
--Business Insight: Which categories bring in the cash, and where should marketing spend more?

SELECT product_category,
COUNT(order_id) AS Total_ordrs,
SUM(quantity) AS Total_unit_Sold,
ROUND(SUM(revenue),2) AS Total_Revenue,
ROUND ((SUM(revenue)/ (SELECT SUM(revenue) FROM dbo.ecom)) * 100, 2) AS Revenue_Contribution_Percentage
FROM dbo.ecom
GROUP BY product_category
ORDER BY Total_Revenue DESC;

--Regional & Demographic Insights
SELECT region,
COUNT (DISTINCT customer_id) AS Unique_Customers,
ROUND(sum(revenue),2 ) AS Total_Revenue,
ROUND(avg(delivery_days),1) AS Avg_Delivery_Days
from dbo.ecom
GROUP BY region
ORDER BY Total_Revenue DESC;

--Sales Trends & Seasonality (Month-over-Month)
SELECT 
YEAR (order_date) AS sales_year,
MONTH (order_date) AS Month_Number,
DATENAME(month,order_date) AS Sales_month,
ROUND(SUM(revenue), 2) AS Monthly_Revenue,
    COUNT(order_id) AS Order_Count
FROM dbo.ecom
GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(month, order_date)
ORDER BY Sales_Year, Month_Number;

--Customer Behavior & Payment Preferences
select payment_method,
ROUND(SUM(revenue), 2)
from ecom.dbo.ecom
group by (payment_method)
order by ROUND(SUM(revenue), 2) desc;

SELECT 
    payment_method,
    COUNT(order_id) AS Transaction_Count,
    ROUND(SUM(revenue), 2) AS Total_Revenue,
    ROUND(AVG(unit_price * quantity), 2) AS Avg_Order_Value
FROM dbo.ecom
GROUP BY payment_method
ORDER BY Total_Revenue DESC;

-- This creates a separate table with unique customer regions
SELECT DISTINCT 
    customer_id, 
    region 
INTO dbo.dim_customers
FROM dbo.ecom;

-- This creates a separate lookup table for products
SELECT ROW_NUMBER() OVER (ORDER BY product_category) AS product_key,
product_category
INTO dbo.dim_products    
FROM (SELECT DISTINCT product_category FROM dbo.ecom) AS temp;

SELECT 
    f.order_id,
    f.order_date,
    c.region,             -- Brought in via JOIN
    p.product_category,   -- Brought in via JOIN
    f.quantity,
    f.revenue
FROM dbo.ecom f
INNER JOIN dbo.dim_customers c ON f.customer_id = c.customer_id
INNER JOIN dbo.dim_products p ON f.product_category = p.product_category;


select * 
from ecom.dbo.dim_customers

.




