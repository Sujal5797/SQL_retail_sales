# Retail Sales Analysis using SQL

## Project Overview

**Project Title** - Retail sales analysis  
**Database** - 'SQL_Project_1'  

This project focuses on analyzing retail sales data using SQL to extract meaningful business insights.
The analysis includes data cleaning, exploration, and answering key business questions to understand customer behavior, sales trends, and category performance.

## Tools & Technologies

**Database**: PostgreSQL  
**Language**: SQL  
**Concepts Used**:
Data Cleaning  
Aggregate Functions  
Window Functions  
CTEs  
Subqueries  
Date & Time Functions  

## Objectives
1. Build and structure a retail sales database using SQL.  
2. Clean the dataset by detecting and removing missing or null values.  
3. Perform exploratory data analysis to understand sales patterns and trends.  
4. Answer real-world business questions using SQL to generate meaningful insights.

# Project Structure

### Database creation

This project start by creating a database named 'SQL_Project_1'  

```sql  
CREATE DATABASE 'SQL_PROJECT_1';

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
);
```

### Data Exploration
#### Total Records

```sql
SELECT COUNT(*) FROM retail_sales;
```

#### NULL Values

```sql
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```
### Data Cleaning

#### Removed records containing NULL values to ensure data consistency. 

```sql
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
	total_sale IS NULL;
```

### Data Exploration

1. How many sales we have?
```sql
SELECT COUNT(*) AS total_sales FROM retail_sales;
```

2. how many customer we have?
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales;
```

3. How many category we have?
```sql
SELECT DISTINCT category FROM retail_sales;
```

### Data analysis & Business key problems

#### My Analysis & Finding

1. write a SQL query to retrieve all the column for sales made on 20 aug 2022?
```sql
SELECT * FROM retail_sales WHERE sale_date = '2022-08-20';
```

2. write a SQL query to retrieve all the column where category is 'Clothing' and the quantity sold is more than 10 in the month of NOV-22
```sql
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantity >= 4
ORDER BY transactions_id;
```

3. Write a sql query to calculate the total sales for each category and find the total orders and order by from lowest to highest
```sql
Select category,
Sum(total_sale) as net_sales,
Count(*) as total_orders
From retail_sales
Group by category
Order by 2,3 ;
```

4. find the avg age of customer who purchase items from the beauty category  
```sql
Select round(Avg(age)) as avg_age
From retail_sales
Where category = 'Beauty';
```

5. Find all transactions where the total_sales is greater than 1000  
```sql
Select * From retail_sales
Where total_sale > 1000;
```

6. Find the total number of transaction_id made by each gender in each category
```sql
Select category,gender,
count(*) as Total_transaction
From retail_sales
Group by 1,2
Order by 1,3;
```

7. Calculate the average sales for each month. Find out best selling month for each year
```sql
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
```

8. Find the top 5 customer based on the highest total sales
```sql
Select customer_id,
Sum(total_sale) as highest_sales 
From retail_sales 
Group by customer_id 
Order by 2 Desc 
Limit 5;
```

9. Find the number of unique customer who purchase items for each category
```sql
Select category,
Count(Distinct customer_id) as unique_customer
From retail_sales
Group by 1
Order by 2;
```

10. Write a SQL query to create a  each shift and numbers of orders   
(Exp Morning <= 12, Afternoon Btw 12 to 17 and Evening > 17 )  
```sql
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
```

11. Find the 2nd highest sales using sub-query
```sql
Select Max(total_sale) as sec_highest
From retail_sales
Where total_sale < 
					(Select Max(total_sale)
					From retail_sales );
```
