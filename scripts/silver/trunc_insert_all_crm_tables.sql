-- we need to truncate table and load again all data to make sure there are no duplicates

PRINT '>> Inserting Data Into: silver.crm_cust_info';


-- filter out customer record per cst_id and remove invalid records
-- rename gender, marital status (data normalization, standart-n)


TRUNCATE TABLE silver.crm_cust_info
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_gndr,
	cst_marital_status,
	cst_create_date
)
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
    	ELSE 'Unknown' 
    END cst_gndr,
    CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    	ELSE 'Unknown' 
    END cst_marital_status,
    cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY cst_id 
               ORDER BY cst_create_date
           ) AS flag_last
    FROM bronze.crm_cust_info
) t
WHERE flag_last = 1 AND cst_id IS NOT NULL;







PRINT '>> Inserting Data Into: silver.crm_prd_info';

TRUNCATE TABLE silver.crm_prd_info;
INSERT INTO silver.crm_prd_info (
	prd_id,
    prd_key,
    cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')  AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost, 0) AS prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
ELSE 'Unknown'
END AS prd_line,
prd_start_dt,
DATEADD(
        DAY,
        -1,
        LEAD(prd_start_dt) OVER (
            PARTITION BY prd_key 
            ORDER BY prd_start_dt
        )
    ) AS prd_end_date
FROM bronze.crm_prd_info






PRINT '>> Inserting Data Into: silver.crm_sales_info';

TRUNCATE TABLE silver.crm_sales_details;
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
