--------------------DAwSQL 17.07.2021 Session 3 (Organize Complex Queries)--------------

-- Pivot

-- Example of PIVOT Syntax
SELECT [column_name], [pivot_value1], [pivot_value2], ...[pivot_value_n]
FROM 
table_name
PIVOT
(
aggregate_function(aggregate_column)
FOR pivot_column
IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])
) AS pivot_table_name;


-- The following syntax summarizes how to use the PIVOT operator. syntax-sql
SELECT <non-pivoted column>,  
    [first pivoted column] AS <column name>,  
    [second pivoted column] AS <column name>,  
    ...  
    [last pivoted column] AS <column name>  
FROM  
    (<SELECT query that produces the data>)   
    AS <alias for the source query>  
PIVOT  
(  
    <aggregation function>(<column being aggregated>)  
FOR   
[<column that contains the values that will become column headers>]   
    IN ( [first pivoted column], [second pivoted column],  
    ... [last pivoted column])  
) AS <alias for the pivot table>  
<optional ORDER BY clause>;  


Use BikeStores

SELECT Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Category


-- Using PIVOT table for giving same values as like above

-- My code
SELECT * 
FROM
(
SELECT Category, total_sales_price
FROM sales.sales_summary
) AS A
PIVOT
(
SUM (total_sales_price)
FOR Category
IN (
[Cruisers Bicycles],
[Mountain Bikes],
[Road Bikes],
[Children Bicycles],
[Cyclocross Bicycles],
[Electric Bikes]
) 
)AS PIVOT_TABLE


-- Instructor's code
SELECT *
FROM
	(
	SELECT	Category, total_sales_price
	FROM	sales.sales_summary
	) AS A
PIVOT
(
SUM (total_sales_price)
FOR	Category
IN	(
	[Children Bicycles],
    [Comfort Bicycles],
    [Cruisers Bicycles],
    [Cyclocross Bicycles],
    [Electric Bikes],
    [Mountain Bikes],
    [Road Bikes]
	)
) AS PIVOT_TABLE

--------////////////////////////////////////

------- SINGLE ROW SUBQUERIES --------

-- Question: Bring all the personnels from the store that Kali Vargas works


SELECT *
FROM sales.staffs
WHERE first_name = 'Kali' AND last_name = 'Vargas'

SELECT *
FROM sales.staffs
WHERE store_id = (SELECT store_id
				  FROM sales.staffs
				  WHERE first_name = 'Kali' and last_name = 'Vargas')



-- Question: List the staff that Venita Daniel is the manager of.

SELECT *
FROM sales.staffs
WHERE manager_id = (SELECT staff_id 
					FROM sales.staffs
					WHERE first_name='Venita')

SELECT A.*
FROM sales.staffs A, sales.staffs B
WHERE A.manager_id = B.staff_id
AND B.first_name = 'Venita' AND B.last_name = 'Daniel'


-- Question: Write a query that returns customers in the city where the 'Rowlett Bikes' store is located.

SELECT *
FROM sales.customers A
WHERE a.city = (
				SELECT city
				FROM sales.stores b
				WHERE b.store_name = 'Rowlett Bikes')

-- Question: List bikes that are more expensive than the 'Trek CrossRip+ - 2018' bike.

SELECT A.product_id, A.product_name, A.model_year, A.list_price, B.brand_name, C.category_name
FROM production.products AS A, production.brands AS B, production.categories AS C
WHERE A.brand_id = B.brand_id AND A.category_id = C.category_id 
AND list_price > (SELECT list_price
					FROM production.products
					WHERE product_name= 'Trek CrossRip+ - 2018')

-- with DISTINCT

SELECT DISTINCT A.product_id, A.product_name, A.model_year, A.list_price, B.brand_name, C.category_name
FROM production.products AS A, production.brands AS B, production.categories AS C
WHERE A.brand_id = B.brand_id AND A.category_id = C.category_id 
AND list_price > (SELECT list_price
					FROM production.products
					WHERE product_name= 'Trek CrossRip+ - 2018')


-- Question: List customers who orders previous dates than Arla Ellis.

-- C8366 - Harun's answer
SELECT b.first_name, b.last_name, a.order_date
FROM sales.orders a, sales.customers b
WHERE a.customer_id = b.customer_id
and a.order_date < (
					SELECT order_date
					FROM sales.orders
					WHERE customer_id = (
										SELECT customer_id
										FROM sales.customers
										WHERE first_name = 'Arla' and last_name = 'Ellis'))

-- Instructor's answer
SELECT	A.first_name, A.last_name, B.order_date
FROM	sales.customers A, sales.orders B
WHERE	B.order_date < (
						SELECT	order_date
						FROM	sales.customers A, sales.orders B
						WHERE	A.customer_id = B.customer_id
						AND		A.first_name = 'Arla' AND A.last_name = 'Ellis'
						)

-- Question: List order dates for customers residing in the Holbrook city.

SELECT ORDER_DATE
FROM sales.orders
WHERE customer_id IN (
					  SELECT customer_id
					  FROM sales.customers
					  WHERE city = 'Holbrook'
					  )

-- with NOT IN

SELECT ORDER_DATE
FROM sales.orders
WHERE customer_id NOT IN (
					  SELECT customer_id
					  FROM sales.customers
					  WHERE city = 'Holbrook'
					  )


-- Question: List products in categories other than Cruisers Bicycles, Mountain Bikes, or Road Bikes.

-- C8316 - Süleyman's answer
SELECT	A.product_name, A.list_price
FROM	production.products A, production.categories B
WHERE	A.category_id = B.category_id
AND A.product_name NOT IN (
							SELECT	category_name
							FROM	production.categories
							WHERE	category_name IN ('Cruisers Bicycles', 'Mountian Bikes', 'Road Bikes'))

-- Instructor's answer
SELECT	product_name, list_price, model_year
FROM	production.products
WHERE	category_id NOT IN (
							SELECT	category_id
							FROM	production.categories
							WHERE	category_name IN ('Cruisers Bicycles', 'Mountian Bikes', 'Road Bikes')
							)

-- What if  i want only 2016
-- C8301 -Sam's answer
select product_name
from production.products
where category_id NOT IN (
     select category_id
     from production.categories
     where category_id != 3 AND category_id != 6 AND category_id != 7)

-- Instructor's answer
SELECT	product_name, list_price, model_year
FROM	production.products
WHERE	category_id NOT IN (
							SELECT	category_id
							FROM	production.categories
							WHERE	category_name IN ('Cruisers Bicycles', 'Mountian Bikes', 'Road Bikes')
							)
AND model_year=2016


-- Question: List bikes that cost more than electric bikes.

-- we will use ALL or ANY because:
-- Subquery returned more than 1 value. This is not permitted when the subquery follows =, !=, <, <= , >, >= or when the subquery is used as an expression.
SELECT product_name, model_year, list_price
FROM production.products
WHERE list_price > ANY (
						SELECT B.list_price
						FROM production.categories AS A, production.products AS B
						WHERE A.category_id = B.category_id
						AND A.category_name = 'Electric Bikes'
						)

-------------------//////////////////////////

-----------CORRELATED SUBQUERIES--------------

-- EXIST / NOT EXIST

-- Question: Wirite a query that returns State where 'Trek Remedy 9.8 - 2617' product is not ordered
-- EXISTS or NOT EXISTS

SELECT	DISTINCT STATE
FROM	sales.customers X
WHERE	EXISTS 				(
							SELECT	1
							FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
							WHERE	A.product_id = B.product_id
							AND		B.order_id = C.order_id
							AND		C.customer_id = D.customer_id
							AND		A.product_name = 'Trek Remedy 9.8 - 2017'
							AND		X.state = D.state
							)


-- Question: List bikes that cost more than any electric bikes.

SELECT product_name, model_year, list_price
FROM production.products
WHERE list_price > ANY (
						SELECT B.list_price
						FROM production.categories AS A, production.products AS B
						WHERE A.category_id = B.category_id
						AND A.category_name = 'Electric Bikes'
						)

------------ VIEWS ---------------

-- Create a View with the order details and use it in several queries.
-- Customer name surname, order_date, product_name, model_year, quantity, list_price, final_price (discounted price)
-- You can find your view inside Bikestores > Views > dbo.SUMMARY_VIEW (dbo means default schema) not allowed temporary view with #

CREATE VIEW SUMMARY_VIEW AS
SELECT	first_name, last_name, order_date, product_name, model_year,
		quantity, list_price, final_price
FROM
		(
		SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
				C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
		FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
		WHERE	A.customer_id = B.customer_id AND
				B.order_id = C.order_id AND
				C.product_id = D.product_id
		) A
;

SELECT * 
FROM SUMMARY_VIEW


--------- CREATE TABLE ---------------
-- # is useful for temporary creating inside System Database > tempdb > Temporary Tables

SELECT	first_name, last_name, order_date, product_name, model_year,
		quantity, list_price, final_price
INTO #SUMMARY_VIEW
FROM
		(
		SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
				C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
		FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
		WHERE	A.customer_id = B.customer_id AND
				B.order_id = C.order_id AND
				C.product_id = D.product_id
		) A
;

SELECT * 
FROM SUMMARY_VIEW
