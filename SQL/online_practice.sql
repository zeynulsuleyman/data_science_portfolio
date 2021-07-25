
---- 1. All the cities in the Texas and the numbers of customers in each city.
select city, count(customer_id) as 'number of customers'
from sales.customers
where state = 'TX'
group by city
order by city;


---- 2. All the cities in the California which has more than 5 customer, by showing the cities which have more customers first.
select city, count(customer_id) as number_of_customers
from sales.customers
where state = 'CA' 
group by city
having count(customer_id) > 5
order by number_of_customers desc;


-----3. The top 10 most expensive products.
select top 10 product_name, list_price 
from production.products
order by list_price desc;


----  Nth highest value in MS SQL Server Instance
select min(list_price)
from (select top 7 list_price 
from production.products
order by list_price desc)
as temp


-----4. Product name and list price of the products which are located in the store id 2 and the quantity is greater than 25.
select 
	A.product_name,
	A.list_price
from production.products as A, production.stocks as B
where A.product_id = B.product_id
and B.store_id = 2 
and B.quantity > 25
order by A.product_name;


-----5. Find the customers who locate in the same zip code.
-- Solution 1:
select 
	A.zip_code, 
	concat(A.first_name, ' ', A.last_name) as customer1, 
	concat(B.first_name, ' ', B.last_name) as customer2
from sales.customers as A, sales.customers as B
where A.customer_id > B.customer_id
and A.zip_code = B.zip_code
order by zip_code;


-- Solution 2:
select 
	a.zip_code,
	a.first_name+' '+a.last_name as customer1,
	b.first_name+' '+b.last_name as customer2
from sales.customers as  a, sales.customers b 
where a.customer_id > b.customer_id
AND a.zip_code = b.zip_code
ORDER BY zip_code,
customer1,
customer2


-----6. Return first name, last name, e-mail and phone number of the customers.
-- Solution 1:
select concat(first_name, ' ', last_name) as 'full name', email, coalesce(phone, 'n/a') phone
from sales.customers;



-- Solution 2:
select concat(first_name, ' ', last_name) as 'full name', email, isnull(phone, 'n/a') phone
from sales.customers;



-----7. Find the sales order of the customers who lives in Houston order by order date.
-- Solution 1:
select 
	B.order_id,
	B.order_date,
	A.customer_id
from sales.customers as A, sales.orders as B
where A.customer_id = B.customer_id
and A.city = 'Houston'
order by B.order_date


-- Solution 2:
SELECT order_id, order_date,customer_id
FROM sales.orders
WHERE customer_id in (
SELECT customer_id
FROM sales.customers
WHERE city = 'Houston')
ORDER BY order_date


-----8. Find the products whose list price is greater than the average list price of all products with the Electra or Heller.
-- Solution 1:
select 
	distinct A.product_name,
	A.list_price
from production.products as A, production.brands as B
where A.brand_id = B.brand_id
and A.list_price > (
					select 
						avg(A.list_price)
					from production.products as A, production.brands as B
					where A.brand_id = B.brand_id
					and B.brand_name = 'Heller'
					)
or A.list_price > (
					select 
						avg(A.list_price)
					from production.products as A, production.brands as B
					where A.brand_id = B.brand_id
					and B.brand_name = 'Electra'
					)
order by A.list_price;



-- Solution 2:

select distinct product_name, list_price
from production.products
where list_price > (select avg(p.list_price)
					from production.products p
					inner join production.brands b
					on b.brand_id = p.brand_id
					where b.brand_name = 'Electra' or b.brand_name = 'Heller')
order by list_price



-- Solution 3:

SELECT DISTINCT product_name,list_price
FROM production.products
WHERE list_price > (
SELECT AVG (list_price)
FROM production.products
WHERE brand_id in (
SELECT brand_id
FROM production.brands
WHERE brand_name = 'Electra'
OR brand_name='Heller'))
ORDER by list_price



-----9. Find the products that have no sales
-- Solution 1:
select 
	A.product_id,
	B.order_id
from production.products as A
left join sales.order_items as B
on A.product_id = B.product_id
where B.order_id is null; 



-- Solution 2:
SELECT product_id
FROM production.products
EXCEPT
SELECT product_id
FROM sales.order_items



-- Solution 3:
SELECT product_id
FROM production.products
WHERE product_id NOT IN (
						SELECT product_id
						FROM sales.order_items);


---- 10. Return the average number of sales orders in 2017 sales.
-- Solution 1:
WITH cte_avg_sale AS(
	SELECT staff_id, Count(order_id) as sales_count
	FROM sales.orders
	WHERE YEAR(order_date)=2017
	GROUP BY staff_id
	)
SELECT AVG(sales_count) as 'Average Number of Sales'
FROM cte_avg_sale;



-- Solution 2:
SELECT AVG(A.sales_amounts) AS 'Average Number of Sales'
FROM (
    SELECT COUNT(order_id) sales_amounts
    FROM sales.orders
    WHERE order_date LIKE '%2017%' 
    GROUP BY staff_id
    ) as A;



-- Solution 3:
SELECT COUNT(order_id) AS Count_of_Sales
INTO Total_Orders_2017
FROM sales.orders
WHERE YEAR(order_date) = 2017;

SELECT COUNT(first_name) AS Count_of_Staffs
INTO Staffs_Sold_2017
FROM sales.staffs
WHERE staff_id IN (
				SELECT staff_id
				FROM sales.orders
				WHERE YEAR(order_date) = 2017);

SELECT A.Count_of_Sales / B.Count_of_Staffs AS 'Average Number of Sales'
FROM Total_Orders_2017 A, Staffs_Sold_2017 B;



----11. By using view get the sales by staffs and years using the AVG() aggregate function.
-- Solution 1:
select 
	A.first_name, 
	A.last_name, 
	year(B.order_date) as year,
	avg(C.list_price*C.quantity) as avg_amount
from sales.staffs as A
inner join sales.orders as B
on A.staff_id = B.staff_id
inner join sales.order_items as C
on B.order_id = C.order_id
group by A.first_name, A.last_name, year(B.order_date)
order by A.first_name, A.last_name, year(B.order_date);
	


-- Solution 2:
CREATE VIEW sales.staff_sales (
        first_name, 
        last_name,
        year, 
        avg_amount
)
AS 
    SELECT 
        first_name,
        last_name,
        YEAR(order_date),
        AVG(list_price * quantity) as avg_amount
    FROM
        sales.order_items i
    INNER JOIN sales.orders o
        ON i.order_id = o.order_id
    INNER JOIN sales.staffs s
        ON s.staff_id = o.staff_id
    GROUP BY 
        first_name, 
        last_name, 
        YEAR(order_date);


SELECT  
    * 
FROM 
    sales.staff_sales
ORDER BY 
	first_name,
	last_name,
	year;


-- Solution 3:
CREATE VIEW view_table AS

select A.order_id, item_id, product_id,customer_id,B.store_id, C.staff_id,quantity,list_price, discount,
C.first_name, C.last_name, year(order_date) as year

from sales.order_items A, sales.orders B, sales.staffs C

where A.order_id = B.order_id
and B.staff_id = C.staff_id;


select first_name, last_name,staff_id,year, avg((list_price-discount)*quantity) as avg_list_price from view_table
group by year,staff_id,first_name,last_name
order by year

