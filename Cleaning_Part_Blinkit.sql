---------All cleaning Part-------
----1 customers cleaning part
select * from customers;
select count(*) from customers;

----nulls check
SELECT
SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id,
SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS customer_name,
SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS email,
SUM(CASE WHEN phone IS NULL THEN 1 ELSE 0 END) AS phone,
SUM(CASE WHEN address IS NULL THEN 1 ELSE 0 END) AS address,
SUM(CASE WHEN area IS NULL THEN 1 ELSE 0 END) AS area,
SUM(CASE WHEN pincode IS NULL THEN 1 ELSE 0 END) AS pincode,
SUM(CASE WHEN registration_date IS NULL THEN 1 ELSE 0 END) AS registration_date,
SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END) AS customer_segment,
SUM(CASE WHEN total_orders IS NULL THEN 1 ELSE 0 END) AS total_orders,
SUM(CASE WHEN avg_order_value IS NULL THEN 1 ELSE 0 END) AS avg_order_value
FROM CUSTOMERS;---no nulls found

 --BLANK VALUES CHECK
SELECT *
FROM CUSTOMERS
WHERE LTRIM(RTRIM(customer_name))=''
OR LTRIM(RTRIM(email))=''
OR LTRIM(RTRIM(phone))=''
OR LTRIM(RTRIM(address))=''
OR LTRIM(RTRIM(area))=''
OR LTRIM(RTRIM(pincode))=''
OR LTRIM(RTRIM(registration_date))=''
OR LTRIM(RTRIM(customer_segment))=''
OR LTRIM(RTRIM(total_orders))=''
OR LTRIM(RTRIM(avg_order_value))='';---no blank spaces
--DUPLICATE CUSTOMER ID CHECK
SELECT customer_id, email, COUNT(*) AS Total_Count FROM CUSTOMERS
GROUP BY customer_id,email
HAVING COUNT(*)> 1; ---no duplicate found
--UNIQUE VALUES CHECK
SELECT DISTINCT customer_segment
FROM CUSTOMERS;---4 unique customer_segment 

SELECT DISTINCT area
FROM CUSTOMERS;---all unique areas 316
---LEADING & TRAILING SPACES CHECK
SELECT *
FROM CUSTOMERS
WHERE customer_name<>LTRIM(RTRIM(customer_name));---no leading trailing spaces

SELECT *
FROM CUSTOMERS
WHERE address<>LTRIM(RTRIM(address));---no leading trailing spaces
--Phone number length check:
SELECT *
FROM CUSTOMERS
WHERE LEN(phone) <> 13;--correct

SELECT *
FROM CUSTOMERS
WHERE phone NOT LIKE '+91%';--correct
--check phone number duplicate
SELECT
phone,
COUNT(*) AS Total_Count
FROM CUSTOMERS
GROUP BY phone
HAVING COUNT(*) >1;--no duplicate phone number
--PINCODE VALIDATION
SELECT *
FROM CUSTOMERS
WHERE LEN(pincode) <> 6;--correct

--check numeric pincode
SELECT *
FROM CUSTOMERS
WHERE TRY_CAST(pincode AS INT) IS NULL;--correct
--date validatiion
SELECT *
FROM CUSTOMERS
WHERE TRY_CONVERT(DATE,registration_date) IS NULL;
--Future dates check:
SELECT *
FROM CUSTOMERS
WHERE TRY_CONVERT(DATE,registration_date) > GETDATE();--no future date 
--Minimum aur maximum registration date:
SELECT
MIN(CAST(registration_date AS DATE)) AS Minimum_Date,
MAX(CAST(registration_date AS DATE)) AS Maximum_Date
FROM CUSTOMERS;
--Minimum_Date	Maximum_Date
--2023-03-16	2024-11-04

--TOTAL ORDERS VALIDATION
--Numeric values check:
SELECT *
FROM CUSTOMERS
WHERE TRY_CAST(total_orders AS INT) IS NULL;--all are numeric form
---Negative values check:
SELECT *
FROM CUSTOMERS
WHERE CAST(total_orders AS INT) <0;--no negative value 
--Minimum aur maximum values:
SELECT
MIN(CAST(total_orders AS INT)) AS Minimum_Orders,
MAX(CAST(total_orders AS INT)) AS Maximum_Orders
FROM CUSTOMERS;
--Minimum_Orders	Maximum_Orders
--   1	                20
--AVG ORDER VALUE VALIDATION
--Numeric values check:
SELECT *
FROM CUSTOMERS
WHERE TRY_CAST(avg_order_value AS DECIMAL(10,2)) IS Null;
--Negative values check:
SELECT *
FROM CUSTOMERS
WHERE try_CAST(avg_order_value AS DECIMAL(10,2)) <0;--no negative value
--Invalid email format:
SELECT *
FROM CUSTOMERS
WHERE email NOT LIKE '%@%.%';--all emails are correct format
--Duplicate emails check:
SELECT
email,
COUNT(*) AS Total_Count
FROM CUSTOMERS
GROUP BY email
HAVING COUNT(*) >1;
--email	               Total_Count
--ilad@example.net	      2
--wvora@example.org	      2
--yashoda79@example.net	  2
--ydevan@example.net	  2

---Total dullicate email ids found 4
--customer  id are unique
--duplicate belongs to different customer ids

---business rules validation
SELECT *
FROM CUSTOMERS
WHERE CAST(total_orders AS INT) <=0;--no zero negative VALUE

----create customers_clean
CREATE TABLE CUSTOMERS_CLEAN
(
    customer_id BIGINT,
    customer_name VARCHAR(200),
    email VARCHAR(200),
    phone VARCHAR(20),
    address VARCHAR(500),
    area VARCHAR(200),
    pincode VARCHAR(10),
    registration_date DATE,
    customer_segment VARCHAR(100),
    total_orders INT,
    avg_order_value DECIMAL(10,2)
);
--INSERT CLEAN DATA
INSERT INTO CUSTOMERS_CLEAN
(
    customer_id,
    customer_name,
    email,
    phone,
    address,
    area,
    pincode,
    registration_date,
    customer_segment,
    total_orders,
    avg_order_value
)

SELECT

    CAST(customer_id AS BIGINT),
    LTRIM(RTRIM(customer_name)),
    LTRIM(RTRIM(email)),
    LTRIM(RTRIM(phone)),
    LTRIM(RTRIM(address)),
    LTRIM(RTRIM(area)),
    LTRIM(RTRIM(pincode)),
    CAST(registration_date AS DATE),
    LTRIM(RTRIM(customer_segment)),
    CAST(total_orders AS INT),
    CAST(REPLACE(avg_order_value,CHAR(13),'')AS DECIMAL(10,2))-- Remove hidden Carriage Return character (CHAR(13))
                                                              -- and convert avg_order_value from VARCHAR to DECIMAL(10,2)
FROM CUSTOMERS;
--fainal validation
select count(*) from CUSTOMERS_CLEAN--2500rows

---2. orders table cleaning part

--NULL VALUES CHECK
SELECT
SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id,
SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id,
SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS order_date,
SUM(CASE WHEN promised_delivery_time IS NULL THEN 1 ELSE 0 END) AS promised_delivery_time,
SUM(CASE WHEN actual_delivery_time IS NULL THEN 1 ELSE 0 END) AS actual_delivery_time,
SUM(CASE WHEN delivery_status IS NULL THEN 1 ELSE 0 END) AS delivery_status,
SUM(CASE WHEN order_total IS NULL THEN 1 ELSE 0 END) AS order_total,
SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS payment_method,
SUM(CASE WHEN delivery_partner_id IS NULL THEN 1 ELSE 0 END) AS delivery_partner_id,
SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS store_id
FROM ORDERS;--no nullls
--BLANK VALUES CHECK
SELECT *
FROM ORDERS
WHERE LTRIM(RTRIM(order_id))=''
OR LTRIM(RTRIM(customer_id))=''
OR LTRIM(RTRIM(order_date))=''
OR LTRIM(RTRIM(promised_delivery_time))=''
OR LTRIM(RTRIM(actual_delivery_time))=''
OR LTRIM(RTRIM(delivery_status))=''
OR LTRIM(RTRIM(order_total))=''
OR LTRIM(RTRIM(payment_method))=''
OR LTRIM(RTRIM(delivery_partner_id))=''
OR LTRIM(RTRIM(store_id))='';---no blank values
--DUPLICATE ORDER_ID CHECK
SELECT
order_id,
COUNT(*) AS Total_Count
FROM ORDERS
GROUP BY order_id
HAVING COUNT(*) >1;--no duplicate
--UNIQUE VALUES CHECK
SELECT DISTINCT delivery_status
FROM ORDERS;----delivery_status
              --Significantly Delayed
              --On Time
              --Slightly Delayed
SELECT DISTINCT payment_method
FROM ORDERS;--payment_method
              --Card
              --Cash
              --UPI
              --Wallet
---LEADING & TRAILING SPACES CHECK
SELECT *
FROM ORDERS
WHERE order_id <> LTRIM(RTRIM(order_id));---all correct format

SELECT *
FROM ORDERS
WHERE payment_method <> LTRIM(RTRIM(payment_method));--all correct format
--CUSTOMER_ID VALIDATION
SELECT *
FROM ORDERS
WHERE TRY_CAST(customer_id AS BIGINT) IS NULL;--correct
-- Referential Integrity Check:
-- Verify that every customer_id in the ORDERS table
-- exists in the CUSTOMERS_CLEAN table.
SELECT *
FROM ORDERS
WHERE customer_id NOT IN
(
SELECT CAST(customer_id AS bigint)
FROM CUSTOMERS_CLEAN
);--all are correct
---- Check for invalid order dates
SELECT *
FROM ORDERS
WHERE TRY_CONVERT(DATE,order_date) IS NULL;--correct
-- Check for future order dates
SELECT *
FROM ORDERS
WHERE TRY_CONVERT(DATE,order_date) > GETDATE();--correct

-- Check minimum and maximum order dates
SELECT
MIN(CAST(order_date AS DATE)) AS Minimum_Date,
MAX(CAST(order_date AS DATE)) AS Maximum_Date
FROM ORDERS;
--Minimum_Date	Maximum_Date
--2023-03-16	2024-11-04

---- Check for invalid promised delivery times
SELECT *
FROM ORDERS
WHERE TRY_CAST(promised_delivery_time AS datetime) IS NULL;--correct datetime format
---- Check delivery time range
SELECT
MIN(CAST(promised_delivery_time AS datetime)),
MAX(CAST(promised_delivery_time AS datetime))
FROM ORDERS;--minimum 2023-03-16 08:27:44.000,,,maximum 2024-11-04 20:43:15.000
---- Check for invalid actual delivery times
SELECT *
FROM ORDERS
WHERE TRY_CAST(actual_delivery_time AS datetime) IS NULL;--correct datetime format no invalid rcord
---- Check delivery time range
SELECT
MIN(CAST(actual_delivery_time AS datetime)),
MAX(CAST(actual_delivery_time AS datetime))
FROM ORDERS;---min 2023-03-16 08:24:44.000  ,, max 2024-11-04 20:47:15.000
-- Check for invalid order total values
SELECT *
FROM ORDERS
WHERE TRY_CAST(order_total AS DECIMAL(10,2)) IS NULL;--all are correct decimal format
-- Order total cannot be negative
SELECT *
FROM ORDERS
WHERE CAST(order_total AS DECIMAL(10,2)) < 0;--no negative 
-- Check order total range
SELECT
MIN(CAST(order_total AS DECIMAL(10,2))),
MAX(CAST(order_total AS DECIMAL(10,2)))
FROM ORDERS;
--order value min 13.25
          -- max 6721.46

-- Validate delivery partner IDs
SELECT *
FROM ORDERS
WHERE TRY_CAST(delivery_partner_id AS BIGINT) IS NULL;--correct
---- Delivery partner distribution
SELECT
delivery_partner_id,
COUNT(*) AS Total_Orders
FROM ORDERS
GROUP BY delivery_partner_id
ORDER BY Total_Orders DESC;
---- Validate store IDs
SELECT *
FROM ORDERS
WHERE TRY_CAST(store_id AS BIGINT) IS NULL;--correct
-- Total orders by store
SELECT
store_id,
COUNT(*) AS Total_Orders
FROM ORDERS
GROUP BY store_id
ORDER BY Total_Orders DESC;
---- Check delayed deliveries
SELECT *
FROM ORDERS
WHERE CAST(actual_delivery_time AS datetime)
>
CAST(promised_delivery_time AS datetime);--delayed deliveries are 3098 from 5000 orders 

---- CREATE ORDERS_CLEAN TABLE

CREATE TABLE ORDERS_CLEAN
(
    order_id BIGINT,
    customer_id BIGINT,
    order_date DATE,
    promised_delivery_time DATETIME,
    actual_delivery_time DATETIME,
    delivery_status VARCHAR(100),
    order_total DECIMAL(10,2),
    payment_method VARCHAR(50),
    delivery_partner_id BIGINT,
    store_id BIGINT
);
GO
--insert data
INSERT INTO ORDERS_CLEAN
(
    order_id,
    customer_id,
    order_date,
    promised_delivery_time,
    actual_delivery_time,
    delivery_status,
    order_total,
    payment_method,
    delivery_partner_id,
    store_id
)

SELECT

    CAST(order_id AS BIGINT),
    CAST(customer_id AS BIGINT),
    CAST(order_date AS DATE),
    CAST(promised_delivery_time AS DATETIME),
    CAST(actual_delivery_time AS DATETIME),
    LTRIM(RTRIM(delivery_status)),
    CAST(order_total AS DECIMAL(10,2)),
    LTRIM(RTRIM(payment_method)),
    CAST(delivery_partner_id AS BIGINT),
    CAST(store_id AS BIGINT)

FROM ORDERS;
GO
--final validation orders clean
select count(*) from ORDERS_CLEAN;--5000 rows
--business validation --Actual delivery time should not be before order date
SELECT *
FROM ORDERS_CLEAN
WHERE actual_delivery_time < order_date;

---3 order_items cleaning part
--Null Values Check
SELECT
SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id,
SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id,
SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity,
SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS unit_price
FROM ORDER_ITEMS;--no nulls value
--Blank Values Check
SELECT *
FROM ORDER_ITEMS
WHERE LTRIM(RTRIM(order_id))=''
OR LTRIM(RTRIM(product_id))=''
OR LTRIM(RTRIM(quantity))=''
OR LTRIM(RTRIM(unit_price))='';--no blank value find
--Duplicate Records Check
SELECT
order_id,
product_id,
COUNT(*) AS Total_Count
FROM ORDER_ITEMS
GROUP BY order_id,product_id
HAVING COUNT(*)>1;--no duplicate 
---Leading & Trailing Spaces Check
SELECT *
FROM ORDER_ITEMS
WHERE order_id<>LTRIM(RTRIM(order_id));--corect

SELECT *
FROM ORDER_ITEMS
WHERE product_id<>LTRIM(RTRIM(product_id));--are correct
--Order ID Validation
SELECT *
FROM ORDER_ITEMS
WHERE TRY_CAST(order_id AS BIGINT) IS NULL;--correct format
--Referential Integrity Check
--order id validation
SELECT *
FROM ORDER_ITEMS
WHERE order_id NOT IN
(
SELECT CAST(order_id AS BIGINT)
FROM ORDERS_CLEAN
);--all are correct
--Product ID Validation
SELECT *
FROM ORDER_ITEMS
WHERE TRY_CAST(product_id AS BIGINT) IS NULL;--correct format as bigint

--Quantity Validation
-- Numeric Values
SELECT *
FROM ORDER_ITEMS
WHERE TRY_CAST(quantity AS INT) IS NULL;--all are numeric

-- Negative Values
SELECT *
FROM ORDER_ITEMS
WHERE CAST(quantity AS INT) < 0;--no negative

-- Quantity cannot be zero
SELECT *
FROM ORDER_ITEMS
WHERE CAST(quantity AS INT) <=0;--no zero
-- Minimum & Maximum Quantity
SELECT
MIN(CAST(quantity AS INT)) AS Minimum_Quantity,
MAX(CAST(quantity AS INT)) AS Maximum_Quantity
FROM ORDER_ITEMS;--Minimum_Quantity	     Maximum_Quantity
                       --  1	               3

--Unit Price Validation
-- Numeric Values
SELECT *
FROM ORDER_ITEMS
WHERE TRY_CAST(unit_price AS DECIMAL(10,2)) IS NULL;--all numeric
-- Negative Values
SELECT *
FROM ORDER_ITEMS
WHERE CAST(unit_price AS DECIMAL(10,2)) <0;--no neagative 
-- Minimum & Maximum Values
SELECT
MIN(CAST(unit_price AS DECIMAL(10,2))) AS Minimum_Price,
MAX(CAST(unit_price AS DECIMAL(10,2))) AS Maximum_Price
FROM ORDER_ITEMS;--Minimum_Price	Maximum_Price
                    --   12.32	       995.98


---Create ORDER_ITEMS_CLEAN
CREATE TABLE ORDER_ITEMS_CLEAN
(

order_id BIGINT,
product_id BIGINT,
quantity INT,
unit_price DECIMAL(10,2)

);
--Insert Clean Data
INSERT INTO ORDER_ITEMS_CLEAN
(

order_id,
product_id,
quantity,
unit_price

)

SELECT

CAST(order_id AS BIGINT),
CAST(product_id AS BIGINT),
CAST(quantity AS INT),
CAST(unit_price AS DECIMAL(10,2))

FROM ORDER_ITEMS;

---final validation
-- Total Rows
SELECT COUNT(*)
FROM ORDER_ITEMS_CLEAN;--5000


---4 products cleaning part

--Null Values Check
SELECT
SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id,
SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS product_name,
SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category,
SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) AS brand,
SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price,
SUM(CASE WHEN mrp IS NULL THEN 1 ELSE 0 END) AS mrp,
SUM(CASE WHEN margin_percentage IS NULL THEN 1 ELSE 0 END) AS margin_percentage,
SUM(CASE WHEN shelf_life_days IS NULL THEN 1 ELSE 0 END) AS shelf_life_days,
SUM(CASE WHEN min_stock_level IS NULL THEN 1 ELSE 0 END) AS min_stock_level,
SUM(CASE WHEN max_stock_level IS NULL THEN 1 ELSE 0 END) AS max_stock_level
FROM PRODUCTS;--no nulls found
--Blank Values Check
SELECT *
FROM PRODUCTS
WHERE LTRIM(RTRIM(product_name))=''
OR LTRIM(RTRIM(category))=''
OR LTRIM(RTRIM(brand))=''
OR LTRIM(RTRIM(price))=''
OR LTRIM(RTRIM(mrp))=''
OR LTRIM(RTRIM(margin_percentage))=''
OR LTRIM(RTRIM(shelf_life_days))=''
OR LTRIM(RTRIM(min_stock_level))=''
OR LTRIM(RTRIM(max_stock_level))='';-- no blank values found
--Duplicate Product ID Check
SELECT
product_id,
COUNT(*) AS Total_Count
FROM PRODUCTS
GROUP BY product_id
HAVING COUNT(*)>1;-- no  duplicate found
--Unique Values Check
SELECT DISTINCT category
FROM PRODUCTS;--all are correct format category

SELECT DISTINCT brand
FROM PRODUCTS;---- found unwanted double quotes and extra spaces.
--Datatype Validation
SELECT *
FROM PRODUCTS
WHERE TRY_CAST(price AS DECIMAL(10,2)) IS NULL;--all correct
SELECT *
FROM PRODUCTS
WHERE TRY_CAST(mrp AS DECIMAL(10,2)) IS NULL;--all correct

SELECT *
FROM PRODUCTS
WHERE TRY_CAST(margin_percentage AS DECIMAL(10,2)) IS NULL;--all correct

SELECT *
FROM PRODUCTS
WHERE TRY_CAST(shelf_life_days AS INT) IS NULL;--all correct
---refernital integrity prouduct id not order items
SELECT *
FROM ORDER_ITEMS
WHERE product_id NOT IN
(
SELECT product_id
FROM PRODUCTS
);--correct
---Minimum Stock
SELECT *
FROM PRODUCTS
WHERE TRY_CAST(min_stock_level AS INT) IS NULL;--all correct
--Maximum Stock
SELECT *
FROM PRODUCTS
WHERE TRY_CAST(max_stock_level AS INT) IS NULL;--all correct
--shelf life days
SELECT *
FROM PRODUCTS
WHERE TRY_CAST(shelf_life_days AS INT) IS NULL

SELECT
MIN(CAST(shelf_life_days AS INT)),
MAX(CAST(shelf_life_days AS INT))
FROM PRODUCTS;
--min 3    ,,,, max 365

--Business Rule Validation

--Price should never be greater than MRP
SELECT *
FROM PRODUCTS
WHERE
CAST(price AS DECIMAL(10,2)) > CAST(mrp AS DECIMAL(10,2));--correct

--Minimum Stock should never exceed Maximum Stock
SELECT *
FROM PRODUCTS
WHERE
try_CAST(min_stock_level AS INT)
>
try_CAST(max_stock_level AS INT);--correct

--PRODUCTS_CLEAN Table

CREATE TABLE PRODUCTS_CLEAN
(

product_id BIGINT,
product_name VARCHAR(300),
category VARCHAR(200),
brand VARCHAR(200),
price DECIMAL(10,2),
mrp DECIMAL(10,2),
margin_percentage DECIMAL(10,2),
shelf_life_days INT,
min_stock_level INT,
max_stock_level INT

);
--INSERT CLEAN DATA
INSERT INTO PRODUCTS_CLEAN
(
product_id,
product_name,
category,
brand,
price,
mrp,
margin_percentage,
shelf_life_days,
min_stock_level,
max_stock_level
)
SELECT
CAST(product_id AS BIGINT),
LTRIM(RTRIM(product_name)),
LTRIM(RTRIM(category)),
LTRIM(RTRIM(brand)),
CAST(price AS DECIMAL(10,2)),
CAST(mrp AS DECIMAL(10,2)),
CAST(margin_percentage AS DECIMAL(10,2)),
CAST(shelf_life_days AS INT),
try_CAST(min_stock_level AS INT),
try_CAST(max_stock_level AS INT)
FROM PRODUCTS;
--Final Validation
SELECT COUNT(*)
FROM PRODUCTS_CLEAN;

-------------PK FK CONSTRAINTS ADD-----
---PRIMARY KEYS

----CUSTOMERS_CLEAN
ALTER TABLE CUSTOMERS_CLEAN
ALTER COLUMN customer_id BIGINT NOT NULL;

ALTER TABLE CUSTOMERS_CLEAN
ADD CONSTRAINT PK_CUSTOMERS
PRIMARY KEY(customer_id);
----ORDERS_CLEAN
ALTER TABLE ORDERS_CLEAN
ALTER COLUMN order_id BIGINT NOT NULL;

ALTER TABLE ORDERS_CLEAN
ADD CONSTRAINT PK_ORDERS
PRIMARY KEY(order_id);
----PRODUCTS_CLEAN
ALTER TABLE PRODUCTS_CLEAN
ALTER COLUMN product_id BIGINT NOT NULL;

ALTER TABLE PRODUCTS_CLEAN
ADD CONSTRAINT PK_PRODUCTS
PRIMARY KEY(product_id);

----FOREIGN KEYS
--Orders clean
ALTER TABLE ORDERS_CLEAN
ADD CONSTRAINT FK_CUSTOMER_ORDERS
FOREIGN KEY(customer_id)
REFERENCES CUSTOMERS_CLEAN(customer_id);
--Order Items clean  ---> Orders clean
ALTER TABLE ORDER_ITEMS_CLEAN
ADD CONSTRAINT FK_ORDER_ITEMS
FOREIGN KEY(order_id)
REFERENCES ORDERS_CLEAN(order_id);
--Order Items clean---> Products clean
ALTER TABLE ORDER_ITEMS_CLEAN
ADD CONSTRAINT FK_PRODUCTS_ITEMS
FOREIGN KEY(product_id)
REFERENCES PRODUCTS_CLEAN(product_id);

--Final Schema
               --CUSTOMERS_CLEAN
                      --|
                  --customer_id
                      --|
                      --V
                 --ORDERS_CLEAN
                      --|
                   --order_id
                      --|
                      --V
               --ORDER_ITEMS_CLEAN
                 -- /          \
                -- /            \
         -- order_id          product_id
             -- |                  |
              --V                  V
       -- ORDERS_CLEAN        PRODUCTS_CLEAN

      -- Step 1: Check the total rows and count missing (NULL) values in max_stock_level before updating
SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN max_stock_level IS NULL THEN 1 ELSE 0 END) AS Null_Max_Stock
FROM PRODUCTS_CLEAN;

-- Step 2: Update NULL stock level values in PRODUCTS_CLEAN using data from raw PRODUCTS table
UPDATE PC
SET 
    -- Remove hidden carriage return (CHAR 13) & line feed (CHAR 10) characters, then convert to INT
    PC.min_stock_level = TRY_CAST(REPLACE(REPLACE(P.min_stock_level, CHAR(13), ''), CHAR(10), '') AS INT),
    PC.max_stock_level = TRY_CAST(REPLACE(REPLACE(P.max_stock_level, CHAR(13), ''), CHAR(10), '') AS INT)
FROM PRODUCTS_CLEAN PC
-- Match rows between target table (PRODUCTS_CLEAN) and source table (PRODUCTS) on product_id
JOIN PRODUCTS P 
    ON PC.product_id = CAST(P.product_id AS BIGINT);

  



  
