--01_RAW_LAYER.sql

--====================================================
-- STEP-1 : CREATE DATABASE
--====================================================

CREATE DATABASE BLINKIT_DB;
GO

USE BLINKIT_DB;
GO


--====================================================
-- STEP-2 : CREATE RAW TABLES
--====================================================


---------------CUSTOMERS------------------


CREATE TABLE BLINKIT_CUSTOMERS
(

customer_id VARCHAR(100),
customer_name VARCHAR(200),
email VARCHAR(200),
phone VARCHAR(100),
address VARCHAR(500),
area VARCHAR(200),
pincode VARCHAR(50),
registration_date VARCHAR(100),
customer_segment VARCHAR(100),
total_orders VARCHAR(100),
avg_order_value VARCHAR(100)

);



---------------ORDERS------------------


CREATE TABLE BLINKIT_ORDERS
(

order_id VARCHAR(100),
customer_id VARCHAR(100),
order_date VARCHAR(100),
promised_delivery_time VARCHAR(100),
actual_delivery_time VARCHAR(100),
delivery_status VARCHAR(100),
order_total VARCHAR(100),
payment_method VARCHAR(100),
delivery_partner_id VARCHAR(100),
store_id VARCHAR(100)

);



---------------ORDER ITEMS------------------


CREATE TABLE BLINKIT_ORDER_ITEMS
(

order_id VARCHAR(100),
product_id VARCHAR(100),
quantity VARCHAR(100),
unit_price VARCHAR(100)

);



---------------PRODUCTS------------------


CREATE TABLE BLINKIT_PRODUCTS
(

product_id VARCHAR(100),
product_name VARCHAR(300),
category VARCHAR(200),
brand VARCHAR(200),
price VARCHAR(100),
mrp VARCHAR(100),
margin_percentage VARCHAR(100),
shelf_life_days VARCHAR(100),
min_stock_level VARCHAR(100),
max_stock_level VARCHAR(100)

);


--====================================================
-- BULK INSERT
--====================================================

BULK INSERT BLINKIT_CUSTOMERS
FROM 'C:\Users\SASWAT\OneDrive\Desktop\Blinkit Analysis\blinkit_customers.csv'
with
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);


BULK INSERT BLINKIT_ORDERS
FROM 'C:\Users\SASWAT\OneDrive\Desktop\Blinkit Analysis\blinkit_orders.csv'
WITH
(
FIRSTROW=2,
FIELDTERMINATOR=',',
ROWTERMINATOR='\n',
TABLOCK
);



BULK INSERT BLINKIT_ORDER_ITEMS
FROM 'C:\Users\SASWAT\OneDrive\Desktop\Blinkit Analysis\blinkit_order_items.csv'
WITH
(
FIRSTROW=2,
FIELDTERMINATOR=',',
ROWTERMINATOR='\n',
TABLOCK
);



BULK INSERT BLINKIT_PRODUCTS
FROM 'C:\Users\SASWAT\OneDrive\Desktop\Blinkit Analysis\blinkit_products.csv'
WITH
(
FORMAT='CSV',
FIRSTROW=2,
FIELDQUOTE='"',
FIELDTERMINATOR=',',
ROWTERMINATOR='0x0A',
TABLOCK

);


---VERIFY DATA
SELECT COUNT(*)
FROM BLINKIT_CUSTOMERS;--2500 rows


SELECT COUNT(*)
FROM BLINKIT_ORDERS;---5000 rows


SELECT COUNT(*)
FROM BLINKIT_ORDER_ITEMS;--5000rows


SELECT COUNT(*)
FROM BLINKIT_PRODUCTS;--268 rows


--====================================================
-- TOP RECORDS
--====================================================


SELECT TOP 10 *
FROM BLINKIT_CUSTOMERS;


SELECT TOP 10 *
FROM BLINKIT_ORDERS;


SELECT TOP 10 *
FROM BLINKIT_ORDER_ITEMS;


SELECT TOP 10 *
FROM BLINKIT_PRODUCTS;