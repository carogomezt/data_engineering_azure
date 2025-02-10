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

IF OBJECT_ID('dbo.dim_rider') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_rider];
END

CREATE EXTERNAL TABLE dbo.dim_rider
WITH (
    LOCATION     = 'dim_rider',
    DATA_SOURCE = [udacityproject_udacityproject_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT [rider_id], REPLACE([first], '"', '') as first, REPLACE([last], '"', '') as last, REPLACE([address], '"', '') as address, TRY_CONVERT(DATE, LEFT(birthday, 10)) as birthday, TRY_CONVERT(DATE, LEFT(account_start_date, 10)) as account_start_date, TRY_CONVERT(DATE, LEFT(account_end_date, 10)) as account_end_date, [is_member]
FROM [dbo].[staging_rider]
;
GO

SELECT TOP 100 * FROM dbo.dim_rider
GO