--------------
-- checking whats in the data
SELECT cst_key FROM silver.crm_cust_info


-- checking whats in the data and removing - from cid column
SELECT DISTINCT 
REPLACE(cid, '-', '')
cid, cntry FROM bronze.erp_loc_a101 

-- checking for standartization and consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101



-- cleanse and strip all common invisible charactersN      
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

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.erp_loc_a101;
    PRINT 'Dropped silver.erp_loc_a101';
END
CREATE TABLE silver.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

SELECT DISTINCT cntry FROM silver.erp_loc_a101 

SELECT * FROM silver.erp_loc_a101
