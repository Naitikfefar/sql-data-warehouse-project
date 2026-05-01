/*
=============================================================
Load Bronze Layer (Stored Procedure)
=============================================================
Script Purpose:
    This stored procedure loads data into bronze layer tables
    from CRM and ERP source CSV files using BULK INSERT.

    The procedure truncates existing data before loading fresh
    records, tracks execution time, and logs errors if loading fails.

WARNING:
    Running this procedure will delete existing data from all
    bronze tables before reloading source files.
*/

CREATE OR ALTER PROCEDURE bronze.bronze_load AS
BEGIN
	-- Track total procedure execution time
	DECLARE @start_total_time DATETIME, @end_total_time DATETIME;
	SET @start_total_time = GETDATE();

	BEGIN TRY
		-- Track execution time for each table load
		DECLARE @start_time DATETIME, @end_time DATETIME;

		PRINT '==============================================================================';
		PRINT ' Load Bronze Layer';
		PRINT '==============================================================================';

		-- Load CRM source tables
		PRINT '------------------------------------------------------------------------------';
		PRINT 'Load CRM Table';
		PRINT '------------------------------------------------------------------------------';

		SET @start_time = GETDATE();

		PRINT '>> Truncating Table : bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Table : bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\prepration\sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,             -- Skip header row
			FIELDTERMINATOR = ',',    -- CSV delimiter
			TABLOCK                   -- Optimize bulk load performance
		);

		SET @end_time = GETDATE();
		PRINT 'Load Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------';

		SET @start_time = GETDATE();

		--SELECT COUNT(*) FROM bronze.crm_cust_info;

		PRINT '>> Truncating Table : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Table : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\prepration\sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Load Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------';

		--SELECT * FROM bronze.crm_prd_info;

		SET @start_time = GETDATE();

		PRINT '>> Truncating Table : bronze.crm_sales_detail';
		TRUNCATE TABLE bronze.crm_sales_detail;

		PRINT '>> Inserting Table : bronze.crm_sales_detail';
		BULK INSERT bronze.crm_sales_detail
		FROM 'C:\prepration\sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Load Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------';

		--SELECT * FROM bronze.crm_sales_detail;

		SET @start_time = GETDATE();

		-- Load ERP source tables
		PRINT '------------------------------------------------------------------------------';
		PRINT 'Load ERP Table';
		PRINT '------------------------------------------------------------------------------';

		PRINT '>> Truncating Table : bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Table : bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\prepration\sql\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Load Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------';

		--SELECT count(*) FROM bronze.erp_cust_az12;

		SET @start_time = GETDATE();

		PRINT '>> Truncating Table : bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Table : bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\prepration\sql\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Load Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------';

		--SELECT * FROM bronze.erp_loc_a101;

		SET @start_time = GETDATE();

		PRINT '>> Truncating Table : bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Table : bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\prepration\sql\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Load Time : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------';

		--SELECT * FROM bronze.erp_px_cat_g1v2;

	END TRY

	BEGIN CATCH
		-- Log loading errors
		PRINT '=================================================';
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message : ' + ERROR_MESSAGE();
		PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=================================================';
	END CATCH

	-- Print total execution time
	SET @end_total_time = GETDATE();

	PRINT '=================================================';
	PRINT ' BRONZE LAYER LOAD COMPLETE';
	PRINT 'Total Bronze Layer Load Time : ' + CAST(DATEDIFF(second, @start_total_time, @end_total_time) AS NVARCHAR) + ' seconds';
	PRINT '=================================================';

END;
