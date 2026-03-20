
-- check for nulls or dubp in primary KEY 
-- expect no RESULT 
SELECT 
prd_id,
COUNT (*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- cleansing to match prod key and joining on sls by prd key
SELECT
prd_id,
prd_key,
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
prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, lEN(prd_key)) NOT IN (
SELECT sls_prd_key FROM bronze.crm_sales_details)


SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2

SELECT sls_prd_key FROM bronze.crm_sales_details


-- check for unwantedd results
-- expect: no res
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- check for NULLs or negative numbers
-- expect: no results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- data standartization and consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- sorting and subtracting overlaping day from end date

