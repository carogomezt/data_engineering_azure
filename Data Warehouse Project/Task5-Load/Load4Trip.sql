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

CREATE EXTERNAL TABLE dbo.staging_trip (
	[trip_id] varchar(50),
	[rideable_type] varchar(75),
	[start_at] varchar(100),
	[ended_at] varchar(100),
	[start_station_id] varchar(50),
	[end_station_id] varchar(50),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'public_trip_import.csv',
	DATA_SOURCE = [udacityproject_udacityproject_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_trip
GO