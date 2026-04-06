/*
=======================
DDL Script: Create Gold View Products
=======================
*/

-- ===================
-- Create dimention: gold.dim_products
-- ===================

IF OBJECT_ID('gold_dim_products', 'V') IS NOT NULL
	DROP VIEW gold_dim_products;
GO

USE DW;

-- joining product table (i have an error in naming columns, so  use prd_key instead of cat_id)
SELECT
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.prd_key = pc.id
WHERE prd_end_dt IS NULL 
-- by setting end date IS NULL we filter out all historical data


-- checking for duplicates
SELECT cat_id, COUNT(*) FROM (
SELECT
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.prd_key = pc.id
WHERE prd_end_dt IS NULL 
-- by setting end date IS NULL we filter out all historical data
)t GROUP BY cat_id
HAVING COUNT(*) > 1

-- group relevant info together and renaming columns
-- dimention vs fact? - dimention
-- creating dimention and view
CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.cat_id) AS product_key,
	pn.prd_id AS product_id,
	pn.cat_id AS product_number,
	pn.prd_nm AS product_name,
	pn.prd_key AS category_id, -- was mixed with prod_num earlier but fixed now
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.prd_key = pc.id
WHERE prd_end_dt IS NULL 
-- by setting end date IS NULL we filter out all historical data


SELECT * FROM gold.dim_products;
