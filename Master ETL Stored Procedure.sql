--1. Master ETL Stored Procedure
CREATE OR ALTER PROCEDURE usp_Run_Blinkit_ETL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Customers
        TRUNCATE TABLE CUSTOMERS_CLEAN;

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
            CAST(REPLACE(avg_order_value, CHAR(13), '') AS DECIMAL(10,2))
        FROM CUSTOMERS;

        -- Orders
        TRUNCATE TABLE ORDERS_CLEAN;

        INSERT INTO ORDERS_CLEAN
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

        -- Order Items
        TRUNCATE TABLE ORDER_ITEMS_CLEAN;

        INSERT INTO ORDER_ITEMS_CLEAN
        SELECT
            CAST(order_id AS BIGINT),
            CAST(product_id AS BIGINT),
            CAST(quantity AS INT),
            CAST(unit_price AS DECIMAL(10,2))
        FROM ORDER_ITEMS;

        -- Products
        TRUNCATE TABLE PRODUCTS_CLEAN;

        INSERT INTO PRODUCTS_CLEAN
        SELECT
            CAST(product_id AS BIGINT),
            LTRIM(RTRIM(product_name)),
            LTRIM(RTRIM(category)),
            LTRIM(RTRIM(brand)),
            CAST(price AS DECIMAL(10,2)),
            CAST(mrp AS DECIMAL(10,2)),
            CAST(margin_percentage AS DECIMAL(10,2)),
            CAST(shelf_life_days AS INT),
            TRY_CAST(REPLACE(REPLACE(min_stock_level, CHAR(13), ''), CHAR(10), '') AS INT),
            TRY_CAST(REPLACE(REPLACE(max_stock_level, CHAR(13), ''), CHAR(10), '') AS INT)
        FROM PRODUCTS;

        COMMIT TRANSACTION;

        PRINT 'Blinkit ETL completed successfully.';
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO


----For run

EXEC usp_Run_Blinkit_ETL;


2. Dashboard Reporting Stored Procedure
CREATE OR ALTER PROCEDURE usp_Sales_Summary
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(DISTINCT O.order_id) AS Total_Orders,
        COUNT(DISTINCT O.customer_id) AS Total_Customers,
        SUM(O.order_total) AS Revenue,
        AVG(O.order_total) AS Avg_Order_Value,
        SUM(OI.quantity) AS Total_Items_Sold
    FROM ORDERS_CLEAN O
    INNER JOIN ORDER_ITEMS_CLEAN OI
        ON O.order_id = OI.order_id;
END;
GO

Run:
EXEC usp_Sales_Summary;

3. Monthly Sales Report Procedure
CREATE OR ALTER PROCEDURE usp_Monthly_Sales_Report
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        YEAR(order_date) AS Sales_Year,
        MONTH(order_date) AS Sales_Month,
        COUNT(order_id) AS Total_Orders,
        SUM(order_total) AS Revenue
    FROM ORDERS_CLEAN
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
    ORDER BY
        Sales_Year,
        Sales_Month;
END;
GO

Run:

EXEC usp_Monthly_Sales_Report;