# SQL PROJECT 6 - Walmart Sales
USE Projects;
select * from walmart_sales;

-- Data Cleaning
#1. Convert Date
UPDATE walmart_sales
SET Date = STR_TO_DATE(Date,'%Y-%m-%d');

ALTER TABLE walmart_sales
MODIFY COLUMN Date DATE;

#2. Convert Time
ALTER TABLE walmart_sales
MODIFY COLUMN Time TIME;

UPDATE walmart_sales
SET Time = STR_TO_DATE(Time,'%H:%i:%s');

-- Feature Engineering
#Step 1: Add time_of_day
ALTER TABLE walmart_sales
ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmart_sales
SET time_of_day =
CASE
    WHEN TIME(time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
    ELSE 'Evening'
END;

#Step 2: Add day_name
ALTER TABLE walmart_sales
ADD COLUMN day_name VARCHAR(15);

UPDATE walmart_sales
SET day_name = DAYNAME(date);

#Step 3: Add month_name
ALTER TABLE walmart_sales
ADD COLUMN month_name VARCHAR(15);

UPDATE walmart_sales
SET month_name = MONTHNAME(date);

-- Business Questions To Answer
#A. Generic Question
## 1. How many unique cities does the data have?
select count(distinct city) from walmart_sales;

## 2. In which city is each branch?
Select branch,city from walmart_sales
group by branch,city;

#B. Product
## 1. How many unique product lines does the data have?
select count(distinct product_line) as unique_product_lines from walmart_sales;

## 2. What is the most common payment method?
select payment,count(payment) as frequency from walmart_sales
group by payment
order by frequency desc limit 1;

## 3. What is the most selling product line?
select product_line,count(product_line) as frequency from walmart_sales
group by product_line
order by frequency desc limit 1;

## 4. What is the total revenue by month?
SELECT month_name,
       ROUND(SUM(total),2) AS total_revenue
FROM walmart_sales
GROUP BY month_name;

## 5. What month had the largest COGS?
select month_name,round(sum(cogs),2) as cog_s from walmart_sales
group by month_name
order by cog_s desc limit 1;

## 6. What product line had the largest revenue?
SELECT product_line,
       ROUND(SUM(total),2) AS revenue
FROM walmart_sales
GROUP BY product_line
order by revenue desc limit 1;

## 7. What is the city with the largest revenue?
SELECT city,
       ROUND(SUM(total),2) AS revenue
FROM walmart_sales
GROUP BY city
order by revenue desc limit 1;

## 8. What product line had the largest VAT?
select product_line, round(sum(cogs*0.05),2) as VAT
from walmart_sales
group by product_line
order by VAT desc limit 1;

## 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
alter table walmart_sales
add column sales_status varchar(255) after product_line;

UPDATE walmart_sales ws
JOIN (SELECT product_line,
CASE WHEN total_sales >(SELECT AVG(total_sales)FROM
(SELECT SUM(total) AS total_sales FROM walmart_sales
GROUP BY product_line) AS avg_sales)
THEN 'Good'
ELSE 'Bad' END AS status FROM (SELECT product_line,SUM(total) AS total_sales
FROM walmart_sales
GROUP BY product_line) AS sales) AS result
ON ws.product_line = result.product_line
SET ws.sales_status = result.status;

## 10. Which branch sold more products than average product sold?
select branch, sum(quantity) as qty
from walmart_sales
group by branch
having sum(quantity) > (select avg(quantity) from walmart_sales);

## 11. What is the most common product line by gender?
select gender,product_line, count(gender) as commonity from walmart_sales
group by gender,product_line
order by commonity desc limit 1;

## 12. What is the average rating of each product line?
select product_line, round(avg(rating),2) as avg_rating from walmart_sales
group by product_line
order by avg_rating desc;

#C. Sales
## 1. Number of sales made in each time of the day per weekday.
select time_of_day,day_name, count(*) as total_sales from walmart_sales
group by time_of_day,day_name
order by total_sales desc;

## 2. Which of the customer types brings the most revenue?
SELECT customer_type,
       ROUND(SUM(total),2) AS revenue
FROM walmart_sales
GROUP BY customer_type
order by revenue desc limit 1;

## 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, round(avg(tax_5_percent),2) as avg_vat
from walmart_sales
group by city
order by avg_vat desc limit 1;

## 4. Which customer type pays the most in VAT?
select customer_type, round(sum(tax_5_percent),2) as VAT
from walmart_sales
group by customer_type
order by VAT desc limit 1;

#D. Customer
## 1. How many unique customer types does the data have?
select count(distinct customer_type) as cust_type from walmart_sales;

## 2. How many unique payment methods does the data have?
select count(distinct payment) as pay_type from walmart_sales;

## 3. What is the most common customer type?
select customer_type, count(*) as commonity from walmart_sales
group by customer_type
order by commonity desc limit 1;

## 4. Which customer type buys the most?
select customer_type, sum(quantity) as products_bought from walmart_sales
group by customer_type
order by products_bought desc limit 1;

## 5. What is the gender of most of the customers?
select gender, count(*) as cst_count from walmart_sales
group by gender
order by cst_count desc limit 1;

## 6. What is the gender distribution per branch?
select gender, branch, count(*) as distribution
from walmart_sales
group by gender, branch;

## 7. Which time of the day do customers give most ratings?
select time_of_day, count(*) as csts_rated from walmart_sales
group by time_of_day
order by csts_rated desc limit 1;

## 8. Which time of the day do customers give most ratings per branch?
SELECT branch,time_of_day,total_ratings
FROM(SELECT branch,time_of_day,COUNT(*) AS total_ratings,
RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS ranking FROM walmart_sales
GROUP BY branch, time_of_day) AS ratings
WHERE ranking = 1;

## 9. Which day of the week has the best avg ratings?
select day_name, round(avg(rating),2) as average_rating from walmart_sales
group by day_name
order by average_rating desc limit 1;

## 10. Which day of the week has the best average ratings per branch?
SELECT branch,
       day_name,
       avg_ratings
FROM
(
    SELECT branch,
           day_name,
           round(AVG(rating),2) AS avg_ratings,
           RANK() OVER (
               PARTITION BY branch
               ORDER BY AVG(rating) DESC
           ) AS ranking
    FROM walmart_sales
    GROUP BY branch, day_name
) AS ratings
WHERE ranking = 1;