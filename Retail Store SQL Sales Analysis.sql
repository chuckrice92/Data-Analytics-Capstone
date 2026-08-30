Retail Store SQL Sales Analysis 

--Viewing Data

SELECT *
FROM store_sales

--How many records in the dataset?

SELECT COUNT(*)
FROM store_sales

--How many Unique Customers?

SELECT distinct "Customer ID"
FROM store_sales

--How many Categories?

SELECT distinct Category
FROM store_sales

--What are the minimum, maximum, and average values for the total amount column?

SELECT MIN(Total), MAX(Total), AVG(Total), SUM(Total)
FROM store_sales

--How many of each item was sold?

SELECT Item, SUM(Quantity)
FROM store_sales
GROUP BY Item

--What's the total  number of items sold?

SELECT SUM(Quantity)
FROM store_sales

--What is the best selling item in each location?

WITH category_sales AS (SELECT Location, Category, SUM(Total) AS total_sales
FROM store_sales
GROUP BY Location, Category),

ranked_sales AS (SELECT Location, Category, total_sales,
RANK() OVER(
    PARTITION BY Location
    ORDER BY total_sales DESC) AS category_rank FROM category_sales
)
SELECT Location, Category, total_sales, category_rank
FROM ranked_sales
WHERE category_rank = 1;

--What is the total revenue for each month? 

SELECT 
    -- Rebuilds 'YYYY-MM' from 'MM/DD/YYYY'
    SUBSTR("Transaction Date", -4) || '-' || 
    PRINTF('%02d', CAST(SUBSTR("Transaction Date", 1, INSTR("Transaction Date", '/') - 1) AS INTEGER)) AS Sales_Month,
    SUM(total) AS Total_Revenue
FROM store_sales
GROUP BY Sales_Month
ORDER BY Sales_Month ASC;


--What percentage of total revenue comes from each category?

SELECT Category, SUM(Total) as category_revenue,
ROUND(
(SUM(Total) * 100)/ SUM(SUM(Total)) OVER (),
2) AS percent_of_revenue
FROM store_sales
GROUP BY Category
ORDER BY category_revenue;

Who are the top 10 customers within each location?

WITH customertotals AS (
    SELECT
        Location,
        "CUstomer ID",
        SUM(Total) as total_spent
    FROM store_sales
    GROUP BY Location, "Customer ID"
),
rankedcustomers AS (
    SELECT
        Location,
        "Customer_ID",
        total_spent,
        DENSE_RANK() OVER (
            PARTITION BY Location
            ORDER BY total_spent DESC
        ) AS customer_rank
    FROM customertotals
)
SELECT 
    Location,
    customer_rank,
    "Customer ID",
    total_spent
FROM rankedcustomers
WHERE customer_rank <= 10
ORDER BY Location, customer_rank;

"Which transactions have a Total greater than the average Total?"

SELECT
    "Transaction ID",
    "Customer ID",
    Total
FROM store_sales 
WHERE Total > (SELECT AVG(Total) FROM store_sales)
ORDER BY Total DESC;

