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

IF OBJECT_ID('dbo.dim_date') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_date];
END

CREATE EXTERNAL TABLE dbo.dim_date
WITH (
    LOCATION     = 'dim_date',
    DATA_SOURCE = [udacityproject_udacityproject_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT TRY_CAST(CONVERT(VARCHAR(8), CAST([date] AS DATE), 112) AS BIGINT) AS date_id,
    TRY_CONVERT(DATE, LEFT([date], 10)) as date,
    DATEPART ( YEAR , [date] ) as year,
    DATEPART ( QUARTER , [date] ) as quarter,
    DATEPART ( MONTH , [date] ) as month,
    DATEPART ( DAY , [date] ) as day,
    DATEPART ( WEEK , [date] ) as week,
    DATEPART ( WEEKDAY , [date] ) as weekday,
    TRY_CAST([date] AS TIME) AS time
FROM [dbo].[staging_payment]
WHERE date IS NOT NULL

UNION
SELECT REPLACE(
        REPLACE(
            REPLACE(LEFT([start_at], 19), '-', ''), ' ', ''), ':', ''
    ) AS date_id,
    TRY_CONVERT(DATE, LEFT([start_at], 10)) as date,
    DATEPART ( YEAR , [start_at] ) as year,
    DATEPART ( QUARTER , [start_at] ) as quarter,
    DATEPART ( MONTH , [start_at] ) as month,
    DATEPART ( DAY , [start_at] ) as day,
    DATEPART ( WEEK , [start_at] ) as week,
    DATEPART ( WEEKDAY , [start_at] ) as weekday,
    TRY_CAST([start_at] AS TIME) AS time
FROM [dbo].[staging_trip]
WHERE start_at IS NOT NULL

UNION

SELECT REPLACE(
        REPLACE(
            REPLACE(LEFT([ended_at], 19), '-', ''), ' ', ''), ':', ''
    ) AS date_id,
    TRY_CONVERT(DATE, LEFT([ended_at], 10)) as date,
    DATEPART ( YEAR , [ended_at] ) as year,
    DATEPART ( QUARTER , [ended_at] ) as quarter,
    DATEPART ( MONTH , [ended_at] ) as month,
    DATEPART ( DAY , [ended_at] ) as day,
    DATEPART ( WEEK , [ended_at] ) as week,
    DATEPART ( WEEKDAY , [ended_at] ) as weekday,
    TRY_CAST([ended_at] AS TIME) AS time
FROM [dbo].[staging_trip]
WHERE ended_at IS NOT NULL
;
GO

SELECT TOP 100 * FROM dbo.dim_date
GO