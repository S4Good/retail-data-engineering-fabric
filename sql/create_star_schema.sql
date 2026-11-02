-- Retail Data Engineering Portfolio
-- Create dimensional model in Microsoft Fabric Warehouse

DROP TABLE IF EXISTS dbo.fact_sales;
DROP TABLE IF EXISTS dbo.dim_date;
DROP TABLE IF EXISTS dbo.dim_product;
DROP TABLE IF EXISTS dbo.dim_customer;

-- Customer dimension
SELECT DISTINCT
    customer_id,
    customer_full_name,
    country
INTO dbo.dim_customer
FROM retail_lakehouse.dbo.silver_customers;

-- Product dimension
SELECT DISTINCT
    product_id,
    product_name,
    category,
    unit_price
INTO dbo.dim_product
FROM retail_lakehouse.dbo.silver_products;

-- Date dimension
SELECT DISTINCT
    order_date,
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    DAY(order_date) AS day,
    CAST(DATENAME(MONTH, order_date) AS VARCHAR(20)) AS month_name
INTO dbo.dim_date
FROM retail_lakehouse.dbo.gold_sales;

-- Sales fact table
SELECT
    order_id,
    order_date,
    customer_id,
    product_id,
    quantity,
    unit_price,
    sales_amount
INTO dbo.fact_sales
FROM retail_lakehouse.dbo.gold_sales;
