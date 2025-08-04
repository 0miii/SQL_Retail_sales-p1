-- DATA EXPLORATION --
SELECT COUNT(*) FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

-- Check for NULLs
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Delete rows with NULLs
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- 1. All sales on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Clothing sales with quantity > 4 in Nov-2022
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
    AND quantiy > 4;

-- 3. Total sales for each category
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- 4. Average age of customers who purchased 'Beauty' category
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Transactions where total_sale > 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Total number of transactions by gender and category
SELECT 
    category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- 7. Best selling month (average sale) in each year
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sale_rank
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS t1
WHERE sale_rank = 1;

-- 8. Top 5 customers by total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.:--
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):--
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

--11.Write a query to show most popular product category among female customers-
SELECT category, COUNT(*) AS total_purchases
FROM retail_sales
WHERE gender = 'Female'
GROUP BY category
ORDER BY total_purchases DESC
LIMIT 1;

--12.Query to show  Which day of the week has the highest number of sales--

SELECT TO_CHAR(sale_date, 'Day') AS day_of_week,
       COUNT(*) AS total_sales
FROM retail_sales
GROUP BY day_of_week
ORDER BY total_sales DESC
LIMIT 1;

--13.What is the age group with the highest average spending per order--
SELECT 
  CASE 
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 50 THEN '36-50'
    ELSE '51+' 
  END AS age_group,
  ROUND(AVG(total_sale)::numeric, 2) AS avg_spending
FROM retail_sales
GROUP BY age_group
ORDER BY avg_spending DESC;

--14.Which month had the highest total revenue in 2022--

SELECT 
  TO_CHAR(sale_date, 'Month') AS month,
  SUM(total_sale) AS total_revenue
FROM retail_sales
WHERE EXTRACT(YEAR FROM sale_date) = 2022
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 1;

--15.Who is the most loyal customer (by number of transactions)

SELECT customer_id, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY customer_id
ORDER BY total_transactions DESC
LIMIT 1;

--End of Project--