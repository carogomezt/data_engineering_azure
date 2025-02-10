IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
    CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
    WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
           FORMAT_OPTIONS (
             FIELD_TERMINATOR = ',',
             USE_TYPE_DEFAULT = FALSE
            ))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacityproject_udacityproject_dfs_core_windows_net') 
    CREATE EXTERNAL DATA SOURCE [udacityproject_udacityproject_dfs_core_windows_net] 
    WITH (
        LOCATION = 'abfss://udacityproject@udacityproject.dfs.core.windows.net' 
    )
GO

IF OBJECT_ID('dbo.fact_payment') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[fact_payment];
END

CREATE EXTERNAL TABLE dbo.fact_payment
WITH (
    LOCATION     = 'fact_payment',
    DATA_SOURCE = [udacityproject_udacityproject_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT [payment_id], [rider_id], TRY_CAST(CONVERT(VARCHAR(8), CAST([date] AS DATE), 112) AS BIGINT) AS payment_date_id, [amount]FROM [dbo].[staging_payment];
GO

SELECT TOP 100 * FROM dbo.fact_payment
GO