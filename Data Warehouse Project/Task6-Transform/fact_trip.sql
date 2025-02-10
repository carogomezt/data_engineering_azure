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

IF OBJECT_ID('dbo.fact_trip') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[fact_trip];
END

CREATE EXTERNAL TABLE dbo.fact_trip
WITH (
    LOCATION     = 'fact_trip',
    DATA_SOURCE = [udacityproject_udacityproject_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT REPLACE([t].[trip_id], '"', '') as trip_id, 
    REPLACE(
        REPLACE(
            REPLACE(LEFT([t].[start_at], 19), '-', ''), ' ', ''), ':', ''
    ) AS start_at_id, 
    REPLACE(
        REPLACE(
            REPLACE(LEFT([t].[ended_at], 19), '-', ''), ' ', ''), ':', ''
    ) AS ended_at_id, 
    REPLACE([t].[start_station_id], '"', '') as start_station_id, 
    REPLACE([t].[end_station_id], '"', '') as end_station_id, 
    [t].[rider_id], 
    DATEDIFF(MINUTE, [t].[start_at], [t].[ended_at]) AS trip_duration_minutes, 
    DATEDIFF(YEAR, [r].[birthday], [t].[start_at]) AS rider_age_at_trip
FROM [dbo].[staging_trip] as t
LEFT JOIN [dbo].[dim_rider] as r ON [t].[rider_id] = [r].[rider_id]
;
GO

SELECT TOP 100 * FROM dbo.fact_trip
GO