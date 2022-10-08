#Customers Details Analysis in SQL
select * from customers;
# TOP TEN CUSTOMERS BY SALES AMOUNT.
 create table portfiolo_project as 
 select c.customerNumber, o.orderNumber, ord.productCode, c.customerName, concat(c.contactFirstName, " ", 
 c.contactLastName) as full_Name, p.amount, o.status, pr.productName, pr.productLine,
 (ord.quantityOrdered*ord.priceEach) as Total_sales 
 from customers c
 join payments p 
 using(customerNumber)
 join orders o
 using(customerNumber)
 join orderdetails ord
 using(orderNumber)
 join products pr
 using(productCode)
 group by customerNumber
 order by Total_sales DESC;
 
select distinct status from portfiolo_project;
select * from portfiolo_project where status = "Cancelled" or status = "Resolved";
select amount, Total_sales, productLine from portfiolo_project group by productLine order by Total_sales Desc;
select amount, Total_sales, productLine, first_value(productLine) over (order by Total_sales Desc) as highest_sale_product from portfiolo_project 
where Total_sales > (select avg(Total_sales) from portfiolo_project) 
group by productLine order by Total_sales Desc;
 
select sum(Total_sales) from portfiolo_project;
select customerNumber, Total_sales, concat(((Total_sales/430293.63)*100), "%") as customer_sales_percent, full_Name
from portfiolo_project;

-- let get the first top customers base on sales and lets store it in a procedure.
delimiter &&
create procedure top_five_customers()
begin
select Full_Name, Total_Sales, concat(((Total_sales/430293.63)*100), "%") as customer_sales_percent 
from portfiolo_project order by customer_sales_percent DESC
Limit 5 ;
End  &&
delimiter ;

call top_five_customers(); -- calling for the top customers based on sales.

select * from customers;
create Table country_sales_table as select pp.customerNumber, pp.full_Name, c.country, pp.Total_sales
from customers c
join portfiolo_project pp
using(customerNumber);

-- so let get the country with the highest sales
select country, sum(Total_sales) as Total_sales_based_on_country, concat(((sum(Total_sales)/430293.63)*100), "%") as country_sales_percent 
from country_sales_table
group by country
order by sum(Total_sales) desc;

select * from country_sales_table;

select sum(Total_sales) as Total_sales_based_on_country, concat(((sum(Total_sales)/430293.63)*100), "%") as country_sales_percent 
from country_sales_table;

select full_Name, country, Total_sales, sum(Total_sales) over (partition by country order by country) as sales_in_the_country, 
(Total_sales/sum(Total_sales) over (partition by country order by country))*100 as individual_sales_based_on_total_sales
from country_sales_table;

 with sales (customerNumber, full_name, country, Total_sales, sales_in_the_country)
 as(
 select customerNumber, full_Name, country, Total_sales, sum(Total_sales) over (partition by country order by country) as sales_in_the_country 
from country_sales_table
 )
select *, (Total_sales/sales_in_the_country)*100 as individual_sales_based_on_total_sales from sales;

select * from offices;
select * from employees;
select e.officeCode, o.city, o.state, o.country, o.addressLine1, o.postalCode, 
concat(e.lastName, " ", e.firstName) as full_employees_Name, e.jobTitle  
from offices o
join employees e
using(officeCode);


