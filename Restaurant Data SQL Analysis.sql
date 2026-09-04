Restaurant Data SQL Analysis:
--Viewing Data

SELECT * 
FROM restaurant_data

SELECT
    COUNT(*)
FROM restaurant_data

--What is the minimum, maximum, average and total revenues? 

SELECT 
    MIN(Revenue) AS MIN,
    MAX(Revenue) AS MAX,
    AVG(Revenue) AS Average,
    SUM(Revenue) AS Total
FROM restaurant_data

--What is the total revenue by cuisine?

SELECT Cuisine, SUM(Revenue) AS total_revenue 
FROM restaurant_data
GROUP BY Cuisine

--What is the total revenue by location?

SELECT 
   Location, SUM(Revenue)
FROM restaurant_data
GROUP BY Location

--How many restuarants are in each cuisine?

SELECT 
   COUNT(*), Cuisine
FROM restaurant_data
GROUP BY Cuisine

what are the top ten restaurants by revenue?

SELECT 
  Name, Location, Cuisine, Revenue
FROM restaurant_data
Order BY Revenue DESC
LIMIT 10

--What restaurants have a higher than average total revenue?

SELECT 
    Name,
    Revenue
FROM restaurant_data
WHERE Revenue > 
(SELECT 
    AVG(Revenue)
FROM restaurant_data
)

-- Which cuisine has the highest average rating?

SELECT
    Cuisine,
    ROUND(AVG(Rating), 2) AS avg_rating
FROM restaurant_data
GROUP BY Cuisine 
ORDER BY avg_rating DESC

--Which restaurants have more social-media followers than the average restaurant?

SELECT
    Name,
    "Social Media Followers"
FROM restaurant_data
WHERE  "Social Media Followers" > (
SELECT 
    AVG( "Social Media Followers")
FROM restaurant_data
)
ORDER BY  "Social Media Followers" DESC;

--Does a higher marketing budget correspond to higher revenue?

SELECT 
    CASE
        WHEN "Marketing Budget" < 3000 THEN '1. Low (< 3k)'
        WHEN "Marketing Budget" < 5000 THEN '2. Medium (< 5k)'
        ELSE '3. High (> 5k)'
    END AS budget_tier,
    COUNT(*) AS restaurant_count,
    ROUND(AVG("Marketing Budget"), 2) AS avg_budget,
    ROUND(AVG(Revenue), 2) AS avg_revenue
FROM restaurant_data
GROUP BY budget_tier
ORDER BY budget_tier;

--Does the number of social media followers correlate to higher revenue?

SELECT
    COUNT(*),
    ROUND(AVG("Social Media Followers"), 2) AS avg_followers,
    ROUND(AVG(Revenue), 2) AS avg_revenue, 
   CASE
       WHEN "Social Media Followers" < 10000 THEN '1.Low'
       WHEN "Social Media Followers" < 35000 THEN '2. Medium'
       ELSE '3. High'
   END AS social_media_rank 
FROM restaurant_data
GROUP BY social_media_rank
ORDER BY social_media_rank;
