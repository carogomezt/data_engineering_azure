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

CREATE EXTERNAL TABLE dbo.staging_rider (
	[rider_id] bigint,
	[first] varchar(50),
	[last] varchar(50),
	[address] varchar(100),
	[birthday] varchar(50),
	[account_start_date] varchar(50),
	[account_end_date] varchar(50),
	[is_member] varchar(10)
	)
	WITH (
	LOCATION = 'public_rider_import.csv',
	DATA_SOURCE = [udacityproject_udacityproject_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_rider
GO