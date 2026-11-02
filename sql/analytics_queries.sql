-- Retail Data Engineering Portfolio
-- Example analytics queries for the Fabric Warehouse

-- 1. Revenue by country
SELECT
    c.country,
    SUM(f.sales_amount) AS total_revenue
FROM dbo.fact_sales AS f
JOIN dbo.dim_customer AS c
    ON f.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;


-- 2. Revenue by product
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM dbo.fact_sales AS f
JOIN dbo.dim_product AS p
    ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;


-- 3. Revenue by category
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM dbo.fact_sales AS f
JOIN dbo.dim_product AS p
    ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- 4. Revenue by month
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS total_revenue
FROM dbo.fact_sales AS f
JOIN dbo.dim_date AS d
    ON f.order_date = d.order_date
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;


-- 5. Top customers by revenue
SELECT
    c.customer_full_name,
    c.country,
    SUM(f.sales_amount) AS total_revenue
FROM dbo.fact_sales AS f
JOIN dbo.dim_customer AS c
    ON f.customer_id = c.customer_id
GROUP BY
    c.customer_full_name,
    c.country
ORDER BY total_revenue DESC;
