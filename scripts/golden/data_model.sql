/*
=======================
DDL Script: Create Gold View Sales
=======================
*/

-- ===================
-- Create: gold.fact_sales
-- ===================

IF OBJECT_ID('gold_fact_sales', 'V') IS NOT NULL
	DROP VIEW gold_fact_sales;
GO

-- sales view
USE DW;

SELECT 
sd.sls_ord_num,
sd.sls_prd_key,
sd.sls_cust_id,
sd.sls_order_dt,
sd.sls_ship_dt,
sd.sls_due_dt,
sd.sls_sales,
sd.sls_quantity,
sd.sls_price
FROM silver.crm_sales_details sd

--dimention of fact? - fact (transactions, events)
-- better use surrogate keys to easier connect facts with dimentions


-- joining by surrogate key and renaming
CREATE VIEW gold.fact_sales AS
SELECT 
sd.sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number 
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id 

-- quality check of gold table
SELECT * FROM gold.fact_sales

SELECT * FROM gold.dim_customers;

SELECT * FROM gold.dim_products


-- foreign key integrity
-- LEFT JOIN builds
-- NOT EXISTS checks
-- Checking is always faster than building.
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key 
WHERE p.product_key IS NULL


SELECT *
FROM gold.fact_sales f
WHERE NOT EXISTS (
    SELECT 1
    FROM gold.dim_products p
    WHERE p.product_key = f.product_key
);

SELECT *
FROM gold.fact_sales f
WHERE NOT EXISTS (
    SELECT 1
    FROM gold.dim_customers c
    WHERE c.customer_key = f.customer_key
);
