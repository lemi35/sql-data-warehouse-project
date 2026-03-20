

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


-- QUALITY CHECKS FOR SILVER PRD_CUST_INFO TABLE
-- check for nulls or dubp in primary KEY 
-- expect no RESULT 
SELECT 
prd_id,
COUNT (*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


-- check for unwantedd results
-- expect: no res
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- check for NULLs or negative numbers
-- expect: no results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL



-- data standartization and consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

SELECT * FROM silver.crm_prd_info

