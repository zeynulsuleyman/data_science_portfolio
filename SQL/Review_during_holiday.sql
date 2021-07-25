-- List products with category names
-- Select product ID, product name, category ID and category names

select 
	A.product_id, 
	A.product_name,
	A.category_id,
	b.category_name
from production.products as A
inner join production.categories as B
on A.category_id = B.category_id;

select 
	A.product_id, 
	A.product_name,
	A.category_id,
	b.category_name
from production.products as A, production.categories as B
where A.category_id = B.category_id;

----

--List employees of stores with their store information
--Select employee name, surname, store names


select 
	A.first_name,
	A.last_name,
	B.store_name
from sales.staffs as A, sales.stores as B
where A.store_id = B.store_id;

select 
	A.first_name,
	A.last_name,
	B.store_name
from sales.staffs as A
left join sales.stores as B
on A.store_id = B.store_id;

----

select top 3
	A.first_name,
	A.last_name,
	B.store_name
from sales.staffs as A, sales.stores as B
where A.store_id = B.store_id;

----

--List products with category names
--Select product ID, product name, category ID and category names

select 
	A.product_id, 
	A.product_name,
	A.category_id,
	b.category_name
from production.products as A
left join production.categories as B
on A.category_id = B.category_id;

----

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity

select 
	A.product_id,
	A.product_name,
	B.store_id,
	B.quantity
from production.products as A
left join production.stocks as B
on A.product_id = B.product_id
where A.product_id > 310;

----

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity

SELECT 
	A.store_id, 
	A.product_id,
	A.quantity,
	B.product_name
FROM production.stocks as A
RIGHT JOIN production.products as B
ON A.product_id = B.product_id
WHERE B.product_id > 310;

----

---Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, all the information about orders

select 
	*
from sales.orders as A
right join sales.staffs as B
on A.staff_id = B.staff_id;

----

--Write a query that returns stock and order information together for all products .
-- Expected columns: Product_id, store_id, quantity, order_id, list_price

SELECT	
	B.product_id, 
	B.store_id, 
	B.quantity, 
	A.product_id, 
	A.list_price, 
	A.order_id
FROM sales.order_items A
FULL OUTER JOIN production.stocks B
ON A.product_id = B.product_id
ORDER BY A.product_id

----

