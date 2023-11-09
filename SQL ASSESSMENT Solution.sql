# 1. Write an SQL query to find the total number of transactions in the dataset. Answer: 
select count(*) as Total_number_of_transaction from transactions;

#2.Calculate the average list price of products in the "Standard" product Class. Answer:
#It's important to note that "Standard" variable is found in product line not product class therefore:
select product_line, avg(list_price) as average_list_price from transactions
where product_line = 'standard';

#3. Find the product brand that has the highest average standard cost.
select brand, avg(standard_cost) as average_standard_cost from transactions
group by brand
order by average_standard_cost desc
limit 1;

#4 Calculate the total revenue generated from online orders.
select online_order, sum(list_price) as Revenue from transactions
where online_order = 'True';

#5 Identify the top 5 customers who made the most transactions.
delimiter &&
create procedure The_top_five_customers()
begin
select Customer_id, list_price
from Transactions order by list_price DESC
limit 5 ;
End  &&
delimiter ;
call The_top_five_customers();

#6 Determine the percentage of online orders in the dataset.
SELECT 
  online_order, COUNT(*) AS online_order_count, concat((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM transactions), '%') AS count_percentage
FROM 
  transactions
GROUP BY 
  online_order;
  
#7 Find the date with the highest number of transactions.
select transaction_date, count(*) as Total_transaction from transactions
group by transaction_date
order by Total_transaction desc;

#8 Calculate the average standard cost of products sold to "Large" customers (based on product size)
select product_size, avg(standard_cost) as average_standard_cost from transactions 
where product_size = 'large';

#9 Find the product with the highest list price.
select brand, max(list_price) as highest_list_price from transactions
group by brand
order by highest_list_price desc
limit 1;

#Calculate the total revenue for each month in 2017, and present the results in ascending order of the month.
SELECT 
    EXTRACT(MONTH FROM STR_TO_DATE(transaction_date, 'DD/MM/YYYY')) AS month,
    SUM(list_price) AS total_list_price
FROM transactions
WHERE EXTRACT(YEAR FROM STR_TO_DATE(transaction_date, 'DD/MM/YYYY')) = 2017
GROUP BY month
ORDER BY month;

#Calculate the moving average of the list price for each product over a rolling 30-day window. Display the product ID, date, list price, and the calculated moving average.
SELECT product_id, transaction_date, list_price, 
AVG(list_price) OVER (PARTITION BY product_id ORDER BY transaction_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS moving_average
FROM transactions;

#Identify the top 5% of customers who have made the highest number of online orders and have a customer name containing the word "Inc."
select CEIL(0.05 * COUNT(DISTINCT Customer_id)) from transactions;
# 5% of the customers is 175
SELECT Customer_id, count(online_order) as number_of_online_orders
WHERE online_order = 'True' 
GROUP BY Customer_id
ORDER BY number_of_online_orders DESC
limit 175; 

# Write a SQL query to find products that have experienced a price increase of at least 10% compared to the previous month. 
#Display the product name, product ID, and the percentage increase.
WITH ProductPrices AS (
    SELECT 
        brand,
        list_price,
        LAG(list_price) OVER (PARTITION BY brand ORDER BY transaction_date) AS previous_price
    FROM transactions
)
SELECT 
    brand,
	((list_price - previous_price) / previous_price) * 100 AS price_increase_percentage
FROM ProductPrices
WHERE previous_price IS NOT NULL
    AND ((list_price - previous_price) / previous_price) * 100 >= 10;
    












