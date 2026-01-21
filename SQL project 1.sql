--Retail Sales Analysis---

create table retail_sales(transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time	TIME,
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15), 
quantiy	INT,
price_per_unit FLOAT, 
cogs FLOAT,
total_sale INT
)

SELECT * FROM retail_sales;

select count(*) from retail_sales;

--

SELECT * FROM retail_sales 
WHERE
	transactions_id IS NULL
OR 
	sale_date IS NULL
OR
	sale_time IS NULL
OR
	customer_id IS NULL
OR
	gender IS NULL
OR 
	category IS NULL
OR
	quantity IS NULL
OR
	price_per_unit IS NULL
OR
	cogs IS NULL
OR
	total_sale IS NULL

--Data Cleaning

DELETE  FROM retail_sales 
WHERE
	transactions_id IS NULL
OR 
	sale_date IS NULL
OR
	sale_time IS NULL
OR
	customer_id IS NULL
OR
	gender IS NULL
OR 
	category IS NULL
OR
	quantity IS NULL
OR
	price_per_unit IS NULL
OR
	cogs IS NULL
OR
	total_sale IS NULL

-- Data Explorations

-- How many sales we have?
SELECT COUNT(*) AS total_sales FROM retail_sales;

--how many customer we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales;

--How many category we have?
SELECT DISTINCT category FROM retail_sales;


--Data analysis & Business key problems

--My Analysis & Finding

--Q1 write a SQL query to retrieve all the column for sales made on 

SELECT * FROM retail_sales WHERE sale_date = '2022-08-20'

--Q2 write a SQL query to retrieve all the column where category is 'Clothing' and the quantity sold is more than 10 in the month of NOV-22

SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantity >= 4
ORDER BY transactions_id;

--Q3 Write a sql query to calculate the total sales for each category and find the total orders and order by from lowest to highest

Select category,
Sum(total_sale) as net_sales,
Count(*) as total_orders
From retail_sales
Group by category
Order by 2,3 ;

--Q4 find the avg age of customer who purchase items from the beauty category

Select round(Avg(age)) as avg_age
From retail_sales
Where category = 'Beauty'

--Q5 Find all transactions where the total_sales is greater than 1000

Select * From retail_sales
Where total_sale > 1000;

--Q6 Find the total number of transaction_id made by each gender in each category

Select category,gender,
count(*) as Total_transaction
From retail_sales
Group by 1,2
Order by 1,3;

--Q7 Calculate the average sales for each month. Find out best selling month for each year

with my_cte as
				(Select  
				Extract(year from sale_date) as Years,
				Extract(month from sale_date) as months,
				Avg(total_sale) as avg_sales,
				Rank() Over(Partition by Extract(year from sale_date) Order by Avg(total_sale) Desc )
				From retail_sales
				Group by 1,2 )
Select Years,months,avg_sales
From my_cte 
Where Rank = 1;					

--Q8 Find the top 5 customer based on the highest total sales

Select customer_id,
Sum(total_sale) as highest_sales 
From retail_sales 
Group by customer_id 
Order by 2 Desc 
Limit 5;

--Q9 Find the number of unique customer who purchase items for each category

Select category,
Count(Distinct customer_id) as unique_customer
From retail_sales
Group by 1
Order by 2;

-- Q10 	Write a SQL query to create a  each shift and numbers of orders 
--(Exp Morning <= 12, Afternoon Btw 12 to 17 and Evening > 17 )

with My_cte as
				(Select*, 
				Case 
					When Extract(Hour from sale_time) <= 12 Then 'Morning'
					When Extract(Hour from sale_time) Between 12 and 17 Then 'Afternoon'
					Else 'Evening'	
				End as Shift
				From retail_sales)
Select Shift,
Count(*) as NO_orders
From My_cte
Group by 1
Order by 2;

--Q11 Find the 2nd highest sales using sub-query

Select Max(total_sale) as sec_highest
From retail_sales
Where total_sale < 
					(Select Max(total_sale)
					From retail_sales );

