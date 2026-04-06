USE DW;


IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_cust_info;
    PRINT 'Dropped bronze.crm_cust_info';
END
CREATE  TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);


IF OBJECT_ID('bronze.crm_prd_inf', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_prd_inf;
    PRINT 'Dropped bronze.crm_prd_inf';
END
CREATE  TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
)



IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_sales_details;
    PRINT 'Dropped bronze.crm_sales_details';
END
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt NVARCHAR(50),
	sls_ship_dt NVARCHAR(50),
	sls_due_dt NVARCHAR(50),
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
)

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_cust_az12;
    PRINT 'Dropped bronze.erp_cust_az12';
END
CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50),
)


IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_loc_a101;
    PRINT 'Dropped bronze.erp_loc_a101';
END
CREATE TABLE bronze.erp_loc_a101 (
	cid INT,
	cntry NVARCHAR(50),
)



IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_px_cat_g1v2;
    PRINT 'Dropped bronze.erp_px_cat_g1v2';
END
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);
