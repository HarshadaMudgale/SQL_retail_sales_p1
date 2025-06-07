--SQL RETAIL SALES ANALYSIS-P1
CREATE DATABASE sql_project_p1;

--CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
   (
    transactions_id	INT PRIMARY KEY, 
    sale_date	DATE,
    sale_time	TIME,
    customer_id	INT,
    gender	VARCHAR(15),
    age	INT,
    category VARCHAR(15), 	
    quantiy	INT,
	price_per_unit FLOAT,	
	cogs	FLOAT,
	total_sale FLOAT
   );

select * FROM RETAIL_SALES
ORDER BY quantiy DESC
LIMIT 10;

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

SELECT QUANTITY FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;


select * from retail_sales
where quantity is null;
--Data cleaning
SELECT * FROM retail_sales
where
    transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

DELETE FROM retail_sales
WHERE
     transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

--Data Exploration
--How many sales we have?
SElECT COUNT(total_sale) FROM retail_sales;

--How many unique customers we have?
SElECT COUNT(DISTINCT customer_id) FROM retail_sales;

--Which uninque categories we have?
SELECT DISTINCT category FROM retail_sales;

--Data Analysis problems
--Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT* FROM retail_sales
WHERE(sale_date = '2022-11-05');


--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the 
--quantity sold is more than 4 in the month of Nov-2022.
SELECT * FROM retail_sales
WHERE (category = 'Clothing') 
AND quantity >= 4
AND (sale_date BETWEEN '2022-11-01' AND '2022-11-30');

--or

SELECT * 
FROM retail_sales
WHERE 
     category = 'Clothing'
	 AND
	 TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' --to char is used for comparing
	 AND
	 quantity >= 4;


--Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT SUM(total_sale), category FROM retail_sales
GROUP BY category;


--Q4. Write a SQL query to calculate avg age of customers who purchased items from the 'beauty' category.
SELECT  ROUND (AVG(age), 2) as avg_age --it will round of to 2 decimal places
FROM retail_sales
WHERE category = 'Beauty';


--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


--Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT COUNT(*), gender, category
FROM retail_sales
GROUP BY category, gender;


--Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month
--in each year.
  SELECT 
  EXTRACT(year FROM sale_date) AS year, --extract is only used in postgre, in mysql we use YEAR(sale_date)
  EXTRACT(month FROM sale_date) AS month,
  AVG(total_sale) AS avg_sale
  FROM retail_sales
  GROUP BY year, month
  ORDER BY year, avg_sale DESC;

 --OR, in method 2 it will also give rank
SELECT * FROM
(
  SELECT 
  EXTRACT(year FROM sale_date) AS year, --extract is only used in postgre, in mysql we use YEAR(sale_date)
  EXTRACT(month FROM sale_date) AS month,
  AVG(total_sale) AS avg_sale,
  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC) AS rank
  FROM retail_sales
  GROUP BY year, month  
) AS t1
WHERE rank = 1;


--Q8. Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP by customer_id
ORDER BY total_sale DESC;


--Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
COUNT(DISTINCT customer_id) AS cust_id,
category
FROM retail_sales 
GROUP BY category;


--Q10. Write a SQL query to create a each shift and number of orders 
--(Example Morning <= 12, Afternoon Between 12&17, Evening>17)
SELECT 
 CASE
  WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'morning' 
  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon' 
  ELSE 'evening' 
 END AS shift,
 COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift;












