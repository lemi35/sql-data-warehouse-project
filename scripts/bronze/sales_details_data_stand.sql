-- SALES DETAILS TABLE
-- checking for extra spaces
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)


-- “Give me all sales records where the product key does NOT exist in the silver product table.”
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE UPPER(LTRIM(RTRIM(sls_prd_key))) NOT IN (
    SELECT UPPER(LTRIM(RTRIM(prd_key))) FROM silver.crm_prd_info
)

SELECT *
FROM bronze.crm_sales_details s
WHERE NOT EXISTS (
    SELECT 1
    FROM silver.crm_prd_info p
    WHERE UPPER(LTRIM(RTRIM(p.prd_key))) = UPPER(LTRIM(RTRIM(s.sls_prd_key)))
);

SELECT DISTINCT sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

-- check if prd_key
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

-- check of cust_id
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_cust_id  NOT IN (SELECT cst_id FROM silver.crm_cust_info)

-- transform INTEGER date into a DATE date
INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
CASE WHEN sls_sales IS NULL
OR sls_sales <= 0
OR sls_sales != ABS(sls_price) * sls_quantity 
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales /NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details


-- checking order date data quality
SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) !=8 OR sls_order_dt > 20500101


SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > 20500101

-- its good to check if order date is not later than shipping or due date

-- business rule: sales = quantity * price
-- with negative, zeros, nulls not allowed

SELECT DISTINCT 
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL
OR sls_sales <= 0
OR sls_sales != ABS(sls_price) * sls_quantity 
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales, 
CASE WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales /NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales  IS NULL  
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_sales <= 0 
OR sls_quantity <= 0 
OR sls_price <= 0 
ORDER BY sls_sales, sls_quantity, sls_price

-- if negative, nulls etc are found, its good to talk to experts in the sphere


-- check health of silver sales TABLE 
SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
OR sls_order_dt > sls_due_dt

-- quality check after cleaning
SELECT DISTINCT 
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price


SELECT * FROM silver.crm_sales_details



