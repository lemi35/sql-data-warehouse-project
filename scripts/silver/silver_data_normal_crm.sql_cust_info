-- filter out customer record per cst_id and remove invalid records
-- rename gender, marital status (data normalization, standart-n)
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
               ORDER BY cst_create_date DESC
           ) AS flag_last
    FROM bronze.crm_cust_info
) t
WHERE flag_last = 1 AND cst_id IS NOT NULL;



-- requesting all values where COUNT is higher than 1
SELECT
cst_id,
COUNT(*) 
FROM silver.crm_cust_info 
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- check for unwanted spaces
-- expected: no result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- check for unwanted spaces
-- expected: no result
SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT * FROM silver.crm_cust_info 
