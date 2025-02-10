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

IF OBJECT_ID('dbo.dim_station') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_station];
END

CREATE EXTERNAL TABLE dbo.dim_station
WITH (
    LOCATION     = 'dim_station',
    DATA_SOURCE = [udacityproject_udacityproject_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT REPLACE([station_id], '"', '') as station_id, REPLACE([name], '"', '') as name, [latitude], [longitude]
FROM [dbo].[staging_station]
;
GO

SELECT TOP 100 * FROM dbo.dim_station
GO