create database Walmart;
use Walmart;
drop table walmartsalesdata.csv
select * from sales;

drop table sales ;

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

SET sql_safe_updates = 0;

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(STR_TO_DATE(date, '%m/%d/%Y'));

-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(STR_TO_DATE(date, '%m/%d/%Y'));


-- ------------------------------------Generic------------------------------------------
-- How many unique cities does the data have 

SELECT DISTINCT
    (city)
FROM
    sales;
    
    -- In which city is each branch 
    
SELECT DISTINCT
    branch
FROM
    sales;
    
---------------------------------------- Product ------------------------------

-- How many unique product lines does the data have--

SELECT 
    COUNT(DISTINCT productline)
FROM
    sales;

-- What is the most common payment method --

SELECT 
    payment, COUNT(payment) AS Cnt
FROM
    sales
GROUP BY payment
ORDER BY Cnt DESC;

-- --What is the most selling productline--

SELECT 
    productline, COUNT(productline) AS Most_Selling
FROM
    sales
GROUP BY productline
ORDER BY Most_Selling DESC;

-- What is the total revenue by month--


SELECT 
    month_name AS month, SUM(total)AS total_revenue
FROM
    sales
GROUP BY Month
ORDER BY total_revenue DESC;

-- What month had the largest COGS --

SELECT 
    month_name AS Month, SUM(cogs) AS Largest_cogs
FROM
    sales
GROUP BY Month
ORDER BY Largest_cogs DESC;

-- What productline has the largest revenue--

select * from sales;

SELECT 
    productline, SUM(total) AS Largest_revenue
FROM
    sales
GROUP BY productline
ORDER BY Largest_revenue DESC;

-- --What is the city with the largest revenue --

SELECT 
    branch, city, SUM(total) AS Largest_revenue
FROM
    sales
GROUP BY branch , city
ORDER BY Largest_revenue DESC;

-- --What productline has the largest VAT----

SELECT 
    productline, AVG(Tax) AS avg_Tax
FROM
    sales
GROUP BY productline
ORDER BY avg_tax ;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- Step 1: Calculate the overall average quantity
WITH overall_avg AS (
    SELECT AVG(Quantity) AS avg_qty
    FROM sales
)
SELECT productline,
    CASE 
        WHEN AVG(Quantity) > (SELECT avg_qty FROM overall_avg) THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM sales
GROUP BY productline;


-- Which branch sold more products than average product sold

select * from sales;

SELECT 
    branch, SUM(quantity) AS quty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender

SELECT 
    gender, productline, COUNT(gender) AS cnt
FROM
    sales
GROUP BY gender , productline
ORDER BY cnt DESC
    
-- What is the average rating of each product line

select productline, round(avg(rating) as avg_rating
from sales
group by  productline
order by avg_rating desc;

-- -------------------------- Sales -------------------------------

-- Number of sales made in each time of the day per weekday

SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Evenings experience most sales, the stores are 
-- filled during the evening hours


-- Which of the customer types brings the most revenue


SELECT
	Customertype,
	SUM(total) AS total_revenue
FROM sales
GROUP BY Customertype
ORDER BY total_revenue;


-- Which city has the largest tax percent/ VAT (Value Added Tax)


select * from sales;

SELECT city, tax
FROM sales
ORDER BY tax DESC
LIMIT 1;

-- Which customer type pays the most in VAT

SELECT 
    customertype, SUM(tax) AS total_vat
FROM
    sales
GROUP BY customertype
ORDER BY total_vat DESC
LIMIT 1;

-- -----------------------------Customer ----------------------------------

-- How many unique customer types does the data have

SELECT DISTINCT
    (customertype)
FROM
    sales


-- How many unique payment methods does the data have

SELECT DISTINCT
    (payment)
FROM
    sales


-- What is the most common customer type

SELECT 
    customertype, COUNT(*) AS count
FROM
    sales
GROUP BY customertype
ORDER BY count DESC

-- Which customer type buys the most

SELECT 
    customertype, 
    SUM(quantity) AS total_quantity
FROM
    sales
GROUP BY 
    customertype
ORDER BY 
    total_quantity DESC
LIMIT 1;

-- What is the gender of most of the customers

SELECT 
    gender, COUNT(*) AS gender_cnt
FROM
    sales
GROUP BY gender
ORDER BY gender_cnt DESC;


-- What is the gender distribution per branch

SELECT 
    gender, COUNT(*) AS gender_cnt
FROM
    sales
WHERE
    branch = 'B'
GROUP BY gender
ORDER BY gender_cnt DESC

-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings

select * from sales;

SELECT 
    time_of_day, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY time_of_day
ORDER BY avg_rating DESC

-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter

-- Which time of the day do customers give most ratings per branch

SELECT 
    time_of_day, branch, AVG(rating) AS avg_rating
FROM
    sales
WHERE
    branch = 'C'
GROUP BY time_of_day
ORDER BY avg_rating DESC

-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Which day of the week has the best avg ratings

SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?


-- Which day of the week has the best average ratings per branch

SELECT 
    day_name, branch,
    AVG(rating) AS avg_rating
FROM
    sales
WHERE 
    branch = 'C' 
GROUP BY 
    day_name, branch
ORDER BY 
    avg_rating DESC;


