SELECT * FROM bronze.erp_px_cat_g1v2 epcgv 

-- checking for extra spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- data standartization
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
FROM bronze.erp_px_cat_g1v2


SELECT * FROM silver.erp_px_cat_g1v2 epcgv 
