-- SQL Retail Sales Analysis - P1

Create database sql_project_p1;
USE sql_project_p1;
-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE IF NOT EXISTS retail_sales 
( 
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,	
		sale_time time,	
		customer_id	int,
		gender varchar(15),	
		age	int null,
		category varchar(15),	
		quantity int null,
		price_per_unit float,
		cogs float,	
		total_sale float
        );
SELECT * FROM retail_sales
limit 10;

SELECT count(*) FROM retail_sales;

SELECT * FROM retail_sales
where transactions_id is null;

SELECT * FROM retail_sales
where sale_time is null;

SELECT * FROM retail_sales
where 
transactions_id is null
or
sale_date is null
or
gender is null
or
sale_time is null
or
category is null
or
quantity is null
or
cogs is null
or
total_sale is null;

--
delete from retail_sales
where 
transactions_id is null
or
sale_date is null
or
gender is null
or
sale_time is null
or
category is null
or
quantity is null
or
cogs is null
or
total_sale is null;

--  Data exploration
select count(*) as total_sales from retail_sales;

-- no of unique customers
select count(distinct customer_id) as customers from retail_sales;

-- no of category
select distinct category from retail_sales;

-- data analysis and business key problems/answers

-- select a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = "2022-11-05";

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity is 4 and above in the month of Nov-2022
select 
* from retail_sales
where category = 'Clothing'
and
date_format(sale_date, '%Y-%m') = '2022-11'
and
quantity >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category
select category, sum(total_sale) as Cat_sales, count(*) as total_orders
from retail_sales
group by category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select category, round(avg(age),2) as Ave_age
from retail_sales
where category = 'Beauty';

-- Write a SQL query to find all transactions where the total sale is greater than 1000
select transactions_id, total_sale
from retail_sales
where total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select category, gender, count(transactions_id) as no_of_transactions
from retail_sales
group by category, gender
order by category;

-- write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
year_, month_, avg_sales 
from
(
	select round(avg(total_sale),2) as avg_sales, year(sale_date) as year_, month(sale_date) as month_,
	rank() OVER(PARTITION BY year(sale_date) ORDER BY round(avg(total_sale),2) DESC) as rank_
	from retail_sales
	group by year_, month_
    ) as t1
where rank_ = 1;
-- order by avg_sales desc, year_ desc
-- limit 2;

-- method 2
select round(avg(total_sale),2) as avg_sales, year(sale_date) as year_, month(sale_date) as month_
from retail_sales
group by year_, month_
order by avg_sales desc, year_ desc
limit 2;

-- write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- write a SQL query to find the number of unique customers who purchased items from each category
select category, count(distinct customer_id) as unique_customer from retail_sales
group by category;

-- write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)       
with hourly_sale as (      
select *,
	CASE
		when hour(sale_time) < 12 THEN 'Morning'
        when hour(sale_time) between 12 and 17 THEN 'Afternoon'
        else 'Evening'
	END as shifts
from retail_sales)

select shifts, count(*) as order_no from hourly_sale
group by shifts;