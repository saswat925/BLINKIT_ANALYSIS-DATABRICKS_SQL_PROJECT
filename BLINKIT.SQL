             -----BLINKIT ANALYSIS---------

use catalog saswat;
use schema pintu;
---copy of all four table--
create or replace table blinkit_customers_clean as  select * from blinkit_customers;
create or replace table blinkit_products_clean as select * from blinkit_products;
create or replace table blinkit_orders_clean as select * from blinkit_orders;
create or replace table blinkit_order_items_clean as select * from blinkit_order_items;

                 -----cleaning part -----
--1 blinkit_items_clean
---check data 
select * from blinkit_order_items_clean;
select count(*) from blinkit_order_items_clean;---5000 rows
---check null values
select count(*) from blinkit_order_items_clean where order_id is null
                                                or product_id is null
                                                or quantity is null
                                                or unit_price  is null;---no nulls

---duplicate check
SELECT 
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM blinkit_order_items_clean
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;---no duplicate 

--data type 
desc blinkit_order_items_clean;

--. Quantity Outlier
--Find unusually high quantity orders.
SELECT *
FROM blinkit_order_items_clean
WHERE quantity > (
    SELECT AVG(quantity) + 3 * STDDEV(quantity)
    FROM blinkit_order_items_clean);---no quantity outlier detect
--Unit Price Outlier
SELECT *
FROM blinkit_order_items_clean
WHERE unit_price > (
    SELECT AVG(unit_price) + 3 * STDDEV(unit_price)
    FROM blinkit_order_items_clean
);---correct

---2 blinkit_orders_clean
---check data 
select * from blinkit_orders_clean;
select count(*) from blinkit_orders_clean;---5000 rows
---check null values
select count(*) from blinkit_orders_clean where order_id is null
                                             or customer_id is null
                                             or order_date is null
                                             or promised_delivery_time is null
                                             or actual_delivery_time is null
                                             or delivery_status is null
                                             or order_total is null
                                             or payment_method is null
                                             or delivery_partner_id is null
                                             or store_id is null;---no nulls

---duplicate check
SELECT 
    order_id,
    COUNT(*) AS duplicate_count
FROM blinkit_orders_clean
GROUP BY order_id
HAVING COUNT(*) > 1;---no duplicate 

--data type 
desc blinkit_orders_clean;
--text check
select distinct delivery_status from blinkit_orders_clean;
select distinct payment_method from blinkit_orders_clean;
--Find Blank delivery_status
SELECT *
FROM blinkit_orders_clean
WHERE TRIM(delivery_status) = ''
or trim(payment_method) = ''; ---no blank
--extra spaces check
select * from blinkit_orders_clean
where trim(order_date) != order_date
    or trim(promised_delivery_time) != promised_delivery_time
    or trim(actual_delivery_time) != actual_delivery_time;---no extra spaces

--Find High Order Total Outliers
SELECT *
FROM blinkit_orders_clean
WHERE order_total > (
    SELECT AVG(order_total) + 3 * STDDEV(order_total)
    FROM blinkit_orders_clean
);
--| order_total | Insight                            |
--| ----------- | ---------------------------------- |
--| 6543.19     | Very high-value order              |
--| 6721.46     | Highest spending customer/order    |
--| 6173.45     | Bulk purchase possible             |
--| 6161.48     | Premium/high quantity basket       |
--| 6458.90     | Unusual compared to average orders |

------3 BLINKIT_CUSTOMERS_CLEAN------
--DATA CHECK
select * from blinkit_customers_clean;
select count(*) from blinkit_customers_clean;---2500 rows

--check nulls
select * from blinkit_customers_clean where customer_id is null
                                         or customer_name is null
                                         or email is null
                                         or phone is null
                                         or address is null
                                         or area is null
                                         or pincode is null
                                         or registration_date is null
                                         or customer_segment is null
                                         or total_orders is null
                                         or avg_order_value is null;---no nulls

--duplicate check
SELECT 
    customer_id,
    COUNT(*) AS duplicate_count
FROM blinkit_customers_clean
GROUP BY customer_id
HAVING COUNT(*) > 1;---no duplicate 

--data type
desc blinkit_customers_clean;

--check blank values 
SELECT *
FROM blinkit_customers_clean
WHERE TRIM(customer_name) = ''
   OR TRIM(email) = ''
   OR TRIM(phone) = ''
   OR TRIM(address) = ''
   OR TRIM(area) = '';  --- no blank values

--check phone number length
SELECT *
FROM blinkit_customers_clean
WHERE LENGTH(phone) <> 12;---+91XXXXXXXXXX

--check pincode length  --pincode column data type bigint aur fix in numeric values
SELECT *
FROM blinkit_customers_clean
WHERE LENGTH(pincode) != 6;--223 rows are fake pincode
  --fix this pincode
UPDATE blinkit_customers_clean
SET pincode = '000000'
WHERE LENGTH(CAST(pincode AS STRING)) <> 6;
--check pin column
select * from blinkit_customers_clean where pincode = '000000';
--Email column check
select count(distinct email) from blinkit_customers_clean;---2496 unique email
------
SELECT email,
       COUNT(*) AS duplicate_count
FROM blinkit_customers_clean
GROUP BY email
HAVING COUNT(*) > 1;  --duplicate emails are
                    --email	duplicate_count
--ilad@example.net	2
--wvora@example.org	2
--ydevan@example.net	2
--yashoda79@example.net	2

--remove duplicate emails
CREATE OR REPLACE TABLE blinkit_customers_clean AS

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY email
               ORDER BY registration_date
           ) AS rn
    FROM blinkit_customers_clean
)
WHERE rn = 1;
---check email column
select count(email) from blinkit_customers_clean;--unique emails 2496

--check negative values 
SELECT *
FROM blinkit_customers_clean
WHERE total_orders < 0
   OR avg_order_value < 0;-- no negative
-- CHECK FUTURE REGISTRATION DATE
SELECT *
FROM blinkit_customers_clean
WHERE registration_date > current_date();

---check ouliers
SELECT *
FROM blinkit_customers_clean
WHERE avg_order_value >
(
    SELECT AVG(avg_order_value) + 3 * STDDEV(avg_order_value)
    FROM blinkit_customers_clean
);--correct
--find special charector
SELECT *
FROM blinkit_customers_clean
WHERE customer_name RLIKE '[^a-zA-Z ]';--customer_name
--Vedika D’Alia
--Radha D’Alia
--Hemani D’Alia     --D’Alia → D'Alia
--Megha D’Alia
--Chandani D’Alia
UPDATE blinkit_customers_clean
SET customer_name = REPLACE(customer_name, '’', '''');

select customer_name from blinkit_customers_clean
where customer_name like '%D''Alia%';--correct

---4 blinkit_products_clean------
--check data 
select * from blinkit_products_clean;
select count(*) from blinkit_products_clean;--268 rows

--Check Null Values
SELECT *
FROM blinkit_products_clean
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL
   OR brand IS NULL
   OR price IS NULL
   OR mrp IS NULL;--no nulls

--duplicate
SELECT product_id, COUNT(*) AS cnt
FROM blinkit_products_clean
GROUP BY product_id
HAVING COUNT(*) > 1;--no duplicate
--FIND BLANK VALUES
SELECT *
FROM blinkit_products_clean
WHERE TRIM(product_name) = ''
   OR TRIM(category) = ''
   OR TRIM(brand) = '';--no blank 
--FIND EXTRA SPACES
SELECT *
FROM blinkit_products_clean
WHERE product_name != TRIM(product_name)
   OR category != TRIM(category)
   OR brand != TRIM(brand);---no extra spaces
--find negative and zero price
SELECT *
FROM blinkit_products_clean
WHERE price <= 0
   OR mrp <= 0;
--find price greater than mrp
SELECT *
FROM blinkit_products_clean
WHERE price > mrp;
--FIND WRONG MARGIN %
SELECT *,
       ROUND(((mrp-price)/mrp)*100,2) AS calculated_margin
FROM blinkit_products_clean
WHERE ROUND(margin_percentage,2) <>
      ROUND(((mrp-price)/mrp)*100,2);---4 rows find wrong
--FIX WRONG MARGIN %
UPDATE blinkit_products_clean
SET margin_percentage =
ROUND(((mrp-price)/mrp)*100,2);

--find invalid shelf life
SELECT *
FROM blinkit_products_clean
WHERE shelf_life_days <= 0;
--FIND INVALID STOCK LEVELS
SELECT *
FROM blinkit_products_clean
WHERE min_stock_level <= 0
   OR max_stock_level <= 0
   OR min_stock_level > max_stock_level; 
---price outliers
SELECT *
FROM blinkit_products_clean
WHERE price > (
    SELECT AVG(price) + 3 * STDDEV(price)
    FROM blinkit_products_clean);


    ----ANALYSIS PART---

    
---STAR SCHEMA ARCHITECTURE--

                    -- dim_customers
                     --      |
                     --      |
--dim_products ---- fact_order_items ---- dim_orders

--1 CUSTOMER DIMENSION
CREATE OR REPLACE TABLE dim_customers AS

SELECT
    customer_id,
    customer_name,
    email,
    area,
    pincode,
    customer_segment,
    registration_date
FROM blinkit_customers_clean;

select * from dim_customers;

--2 PROUDUCT DIMENSION
CREATE OR REPLACE TABLE dim_products AS

SELECT
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
FROM blinkit_products_clean;

select * from dim_products;


---3 ORDER DIMENSION
CREATE OR REPLACE TABLE dim_orders AS

SELECT
    order_id,
    order_date,
    promised_delivery_time,
    actual_delivery_time,
    delivery_status,
    payment_method,
    store_id,
    delivery_partner_id
FROM blinkit_orders_clean;

select * from dim_orders;

--4 FAACT TABLE
CREATE OR REPLACE TABLE fact_order_items AS

SELECT
    oi.order_id,
    oi.product_id,
    o.customer_id,
    o.order_date,
    o.delivery_status,
    o.payment_method,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS sales_amount

FROM blinkit_order_items_clean oi

JOIN blinkit_orders_clean o
ON oi.order_id = o.order_id;


select * from fact_order_items;


          ----------ANALYSIS PART--------

---total orders
select count(distinct order_id) as total_orders from fact_order_items;
--total orders 5000

--total revenue
select round(sum(sales_amount),2) as total_revenue from fact_order_items;
--4972415.43

--Average Order Value
select round(sum(sales_amount)/count(distinct order_id),2) as avg_order_value from fact_order_items;
--994.48
---Top Products sold
select p.product_name, sum(f.quantity) as total_quantity_sold from fact_order_items f
join dim_products p
on f.product_id = p.product_id
group by p.product_name
order by total_quantity_sold desc
limit 10 ;
--insights
--product_name	total_quantity_sold
--Pet Treats	    473
--Toilet Cleaner    430
--Dish Soap	        397
--Vitamins	       380
--Cough Syrup	   373
--Lotion	       350
--Baby Wipes	   328
--Cat Food	       307 
--Pulses	       273
--Bread	           270

--top 10 product revenue
select p.product_name, round(sum(f.sales_amount),2) as total_revenue from fact_order_items f
join dim_products p
on f.product_id = p.product_id
group by p.product_name
order by total_revenue desc
limit 10 ;
--insights
--product_name	   total_revenue
--Vitamins	       260822.01
--Pet Treats	    252007.37
--Cough Syrup	    203569.98
--Toilet Cleaner	199837.48
--Bread	            184851.1
--Dish Soap	        184441.21
--Cat Food	        166596.39
--Baby Wipes	    158768.41
--Onions	        138858.42
--Baby Food	        137442.79

--category performance
select p.category, round(sum(f.sales_amount),2) as total_revenue from fact_order_items f
join dim_products p
on f.product_id = p.product_id
group by p.category
order by total_revenue desc;
--insights
--category	           total_revenue
--Dairy & Breakfast	    639222.19
--Pharmacy	            592368.57
--Fruits & Vegetables	559053.08
--Pet Care	            539888.75
--Household Care	    444244.25
--Personal Care	        394894.61
--Snacks & Munchies	    394648.71
--Cold Drinks & Juices	392717.62
--Grocery & Staples	    359937.82
--Baby Care	            348227.18
--Instant & Frozen Food 307212.65


---brand performance  top 5
select p.brand, round(sum(f.sales_amount),2) as total_revenue from fact_order_items f
join dim_products p
on f.product_id = p.product_id
group by p.brand
order by total_revenue desc
limit 5;
--insights
--brand	            total_revenue
--Karnik PLC	      65212.7
--Mandal-Kar	      56464.65
--Roy-Char	          55182.94
--Sundaram Inc	      51830.35
--Gole-Doshi	      51790.96

--Customer Lifetime Value  top 5 customers
select c.customer_name, round(sum(f.sales_amount),2) as total_spent from fact_order_items f
join dim_customers c
on f.customer_id = c.customer_id
group by c.customer_name
order by total_spent desc
limit 5;
--insights
--customer_name	   total_spent
--Odika Kannan	   10533.39
--Nidhi Sha	       10115.75
--Dev Bal	       9924.84
--Anmol Koshy	   9698.73
--Lipika Kumer	   9553.69


--Customer Segmentation
select c.customer_segment, round(sum(f.sales_amount),2) as total_spent from fact_order_items f
join dim_customers c
on f.customer_id = c.customer_id
group by c.customer_segment
order by total_spent desc

--area wise unit sold top 5 area wise unit sold
select c.area, sum(f.quantity) as total_units from fact_order_items f
join dim_customers c
on f.customer_id = c.customer_id
group by c.area
order by total_units desc
limit 5;
--insights
--area	   total_units
--Orai	          93
--Deoghar	      79
--Nandyal	      73
--Bathinda	      73
--Gandhinagar	  71

--Delivery Status
SELECT delivery_status,
COUNT(DISTINCT order_id) AS orders
FROM dim_orders
GROUP BY delivery_status;
--insights
--delivery_status	     orders
--On Time	             3470
--Slightly Delayed	     1037
--Significantly Delayed	  493

--Delivery Delay serivice quality avg delay min = 4.443
SELECT
AVG(unix_timestamp(actual_delivery_time) - unix_timestamp(promised_delivery_time))/60 AS avg_delay_minutes
FROM dim_orders;

--payment methods
select payment_method, count(distinct order_id) as total_orders from dim_orders
group by payment_method;
--payment_method	total_orders
--Cash	            1257
--UPI	            1214
--Card	            1285
--Wallet	        1244

--Low Stock Risk Products
select product_name from dim_products
where min_stock_level > 10
group by product_name;

--High Margin Products
SELECT DISTINCT product_name, margin_percentage FROM dim_products
ORDER BY margin_percentage DESC
limit 10;
--product_name	    margin_percentage
--Instant Noodles	   40
--Frozen Pizza	       40
--Frozen Vegetables	   40
--Ice Cream	           40
--Frozen Biryani	   40
--Frozen Biryani	   39.99
--Cookies	           35
--Popcorn	           35
--Chocolates	       35
--Biscuits	           35


------TIME-BASED ANALYSIS (END TO END)--

---daily sales trnd
SELECT
   day(o.order_date),
    round(SUM(f.sales_amount),2) AS revenue
FROM fact_order_items f
JOIN dim_orders o
ON f.order_id = o.order_id
GROUP BY day(o.order_date)
ORDER BY Day(o.order_date);
--Revenue shows strong volatility, with peak performance on Day 10 (₹217,020.86) and consistently high spikes around Days 9, 21, 23, and 27 indicating possible weekly demand surges or promotion effects.
--A sharp drop on Day 31 (₹95,424.73) and lower mid-month values suggest uneven customer demand or operational factors impacting order volume and basket size.

--monthly sales trend
SELECT
    MONTH(o.order_date) AS month,
    round(SUM(f.sales_amount),2) AS revenue
FROM fact_order_items f
JOIN dim_orders o
ON f.order_id = o.order_id
GROUP BY MONTH(o.order_date)
ORDER BY  month;
--Revenue shows a strong upward trend from month 1 to month 10, peaking around months 5–10 (highest in month 8), indicating strong mid-year business performance.
--A sharp drop in months 11–12 suggests seasonality or year-end slowdown that needs investigation (demand drop, budget exhaustion, or supply issues).


---yearly sales trend
SELECT
    year(o.order_date) AS year,
    round(SUM(f.sales_amount),2) AS revenue
FROM fact_order_items f
JOIN dim_orders o
ON f.order_id = o.order_id
GROUP BY year(o.order_date)
ORDER BY  year;
--year	revenue
--2023	2460611.72
--2024	2511803.71

--weekday vs weekend dales
SELECT
    CASE
        WHEN DAYOFWEEK(o.order_date) BETWEEN 1 AND 5 THEN 'Weekday'
        ELSE 'Weekend'
    END AS day_type,
    round(SUM(f.sales_amount),2) AS revenue
FROM fact_order_items f
JOIN dim_orders o
ON f.order_id = o.order_id
GROUP BY day_type
ORDER BY revenue DESC;
--day_type	revenue
--Weekday	3593749.36
--Weekend	1378666.07

--Hourly sales trend if timestamp available 
SELECT
    HOUR(o.order_date) AS hour,
    round(SUM(f.sales_amount),2) AS revenue
FROM fact_order_items f
JOIN dim_orders o
ON f.order_id = o.order_id
GROUP BY HOUR(o.order_date)
ORDER BY hour;
--Revenue is relatively stable across hours, but peaks around hour 8–1 and again at hour 23, indicating strong morning activity and late-night demand.
--Lowest revenue appears in early afternoon to evening dip (hours 11–16), suggesting a mid-day slowdown or reduced customer activity during that period.


--peak ordering time
SELECT
    HOUR(o.order_date) AS hour,
    COUNT(DISTINCT f.order_id) AS orders
FROM fact_order_items f
JOIN dim_orders o
ON f.order_id = o.order_id
GROUP BY HOUR(o.order_date)
ORDER BY orders desc;
--Peak ordering time is clearly 8 AM (240 orders), making it the strongest demand hour of the day.
--Secondary peaks are visible around 1 PM (239 orders) and evening hours 6–8 PM (226–228 orders), indicating strong lunch and dinner-time ordering behavior.

                



























