CREATE PROCEDURE silver.load_silver AS
BEGIN
PRINT '>> Inserting Data Into: silver.crm_cust_info';


TRUNCATE TABLE silver.crm_cust_info;
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



PRINT '>> Inserting Data Into: silver.crm_sales_details';

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
FROM bronze.crm_sales_details;





PRINT '>> Inserting Data Into: silver.erp_cust_az12';

TRUNCATE TABLE silver.erp_cust_az12;
INSERT INTO silver.erp_cust_az12(
cid,
bdate,
gen
)
SELECT 
    CASE 
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid,
    CASE 
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,
    CASE 
        WHEN cleaned_gen IN ('F', 'FEMALE') THEN 'Female'
        WHEN cleaned_gen IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM (
    SELECT 
        cid,
        bdate,
        UPPER(
            TRIM(
                REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), '')
            )
        ) AS cleaned_gen
    FROM bronze.erp_cust_az12
) t;





PRINT '>> Inserting Data Into: silver.erp_loc_a101';

TRUNCATE TABLE silver.erp_loc_a101;

INSERT INTO silver.erp_loc_a101 
(cid, cntry)                                               
SELECT DISTINCT 
REPLACE(cid, '-', '') cid,
    CASE 
        WHEN cntry IS NULL THEN 'unknown'
        WHEN LTRIM(RTRIM(
            REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(160), ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
        )) = '' THEN 'unknown'
        WHEN LTRIM(RTRIM(
            REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(160), ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
        )) LIKE 'DE%' THEN 'Germany'
        WHEN LTRIM(RTRIM(
            REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(160), ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
        )) LIKE 'US%' THEN 'United States'
        ELSE LTRIM(RTRIM(
            REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(160), ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
        ))
    END AS cntry
FROM bronze.erp_loc_a101;




PRINT '>> Inserting Data Into: erp_px_cat_g1v2';

TRUNCATE TABLE silver.erp_px_cat_g1v2;
INSERT INTO silver.erp_px_cat_g1v2
(id, cat, subcat, maintenance)
SELECT 
id,
cat,
subcat,
CASE
     WHEN LTRIM(RTRIM(
            REPLACE(REPLACE(REPLACE(REPLACE(maintenance, CHAR(160), ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
        )) LIKE 'Yes%' THEN 'Yes'
        WHEN LTRIM(RTRIM(
            REPLACE(REPLACE(REPLACE(REPLACE(maintenance, CHAR(160), ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
        )) LIKE 'No%' THEN 'No'
    ELSE maintenance
END AS maintenance
FROM bronze.erp_px_cat_g1v2;
END
