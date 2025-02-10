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

CREATE EXTERNAL TABLE dbo.staging_station (
	[station_id] varchar(50),
	[name] varchar(75),
	[latitude] float,
	[longitude] float
	)
	WITH (
	LOCATION = 'public_station_import.csv',
	DATA_SOURCE = [udacityproject_udacityproject_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_station
GO