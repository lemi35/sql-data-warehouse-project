CREATE PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME;
    DECLARE @cnt INT;

    SET @batch_start = GETDATE();  -- batch start time

    BEGIN TRY
        PRINT '===========================';
        PRINT 'Loading Bronze Layer';
        PRINT '===========================';

        PRINT '---------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------';

        -- CRM Cust Info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into Table: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM '/data/datasets/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();
        SELECT @cnt = COUNT(*) FROM bronze.crm_cust_info;
        PRINT 'crm_cust_info: ' + CAST(@cnt AS VARCHAR(10)) + ' rows loaded';
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> ------------------------';

        -- CRM Prd Info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into Table: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM '/data/datasets/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();
        SELECT @cnt = COUNT(*) FROM bronze.crm_prd_info;
        PRINT 'crm_prd_info: ' + CAST(@cnt AS VARCHAR(10)) + ' rows loaded';
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> ------------------------';

        -- Repeat similar for crm_sales_details, erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2
        -- Example for crm_sales_details
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into Table: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM '/data/datasets/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();
        SELECT @cnt = COUNT(*) FROM bronze.crm_sales_details;
        PRINT 'crm_sales_details: ' + CAST(@cnt AS VARCHAR(10)) + ' rows loaded';
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> ------------------------';

        -- ERP Tables (erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2) 
        -- follow same pattern: set @start_time, BULK INSERT, set @end_time, count rows, print

        -- BATCH END
        SET @batch_end = GETDATE();
        PRINT '===========================';
        PRINT 'Total Bronze Load Duration: ' + CAST(DATEDIFF(second, @batch_start, @batch_end) AS NVARCHAR(10)) + ' seconds';
        PRINT '===========================';
    END TRY
    BEGIN CATCH
        PRINT '===============================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT '===============================';
    END CATCH
END;
