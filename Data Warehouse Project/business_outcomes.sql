-- The business outcomes

-- Analyze how much time is spent per ride
-- Based on date and time factors such as day of week and time of day
SELECT [d].[weekday], SUM([t].[trip_duration_minutes]) as total_time_spent
FROM [dbo].[fact_trip] as t
JOIN [dbo].[dim_date] as d ON [t].[start_at_id] = [d].[date_id]
GROUP BY [d].[weekday]
ORDER BY total_time_spent DESC

-- Based on which station is the starting and / or ending station
SELECT [start_station_id], SUM([trip_duration_minutes]) as total_time_spent
FROM [dbo].[fact_trip]
GROUP BY [start_station_id]
ORDER BY total_time_spent DESC

-- ending station
SELECT [end_station_id], SUM([trip_duration_minutes]) as total_time_spent
FROM [dbo].[fact_trip]
GROUP BY [end_station_id]
ORDER BY total_time_spent DESC

-- Based on age of the rider at time of the ride
SELECT [rider_age_at_trip], SUM([trip_duration_minutes]) as total_time_spent
FROM [dbo].[fact_trip]
GROUP BY [rider_age_at_trip]
ORDER BY total_time_spent DESC
-- Based on whether the rider is a member or a casual rider
SELECT CASE 
        WHEN [r].[is_member] = 'True' THEN 'Member'
        ELSE 'Casual Rider'
    END AS rider_status,
    SUM([trip_duration_minutes]) as total_time_spent
FROM [dbo].[fact_trip] as t
JOIN [dbo].[dim_rider] as r ON [t].[rider_id] = [r].[rider_id]
GROUP BY [r].[is_member]
ORDER BY total_time_spent DESC

-- Analyze how much money is spent
-- Per month, 
SELECT [d].[month], SUM([p].[amount]) as total_amount_spent
FROM [dbo].[fact_payment] as p
JOIN [dbo].[dim_date] as d ON [p].[payment_date_id] = [d].[date_id]
GROUP BY [d].[month]
ORDER BY total_amount_spent DESC
-- quarter, 
SELECT [d].[quarter], SUM([p].[amount]) as total_amount_spent
FROM [dbo].[fact_payment] as p
JOIN [dbo].[dim_date] as d ON [p].[payment_date_id] = [d].[date_id]
GROUP BY [d].[quarter]
ORDER BY total_amount_spent DESC
-- year
SELECT [d].[year], SUM([p].[amount]) as total_amount_spent
FROM [dbo].[fact_payment] as p
JOIN [dbo].[dim_date] as d ON [p].[payment_date_id] = [d].[date_id]
GROUP BY [d].[year]
ORDER BY total_amount_spent DESC

-- Per member, based on the age of the rider at account start
SELECT DATEDIFF(YEAR, [r].[birthday], [r].[account_start_date]) AS rider_age_at_account_start, 
    SUM([p].[amount]) as total_amount_spent
FROM [dbo].[fact_payment] as p
JOIN [dbo].[dim_rider] as r ON [p].[rider_id] = [r].[rider_id]
GROUP BY DATEDIFF(YEAR, [r].[birthday], [r].[account_start_date])
ORDER BY total_amount_spent DESC

-- EXTRA CREDIT - Analyze how much money is spent per member
-- Based on how many rides the rider averages per month
SELECT [p].[rider_id], [d].[month], SUM([p].[amount]) as total_amount_spent
FROM [dbo].[fact_payment] as p
JOIN [dbo].[fact_trip] as t ON [p].[rider_id] = [t].[rider_id]
JOIN [dbo].[dim_date] as d ON [t].[start_at_id] = [d].[date_id]
GROUP BY [p].[rider_id], [d].[month]
ORDER BY [p].[rider_id]

-- Based on how many minutes the rider spends on a bike per month
SELECT [p].[rider_id], [t].[trip_duration_minutes], SUM([p].[amount]) as total_amount_spent
FROM [dbo].[fact_payment] as p
JOIN [dbo].[fact_trip] as t ON [p].[rider_id] = [t].[rider_id]
GROUP BY [p].[rider_id], [t].[trip_duration_minutes]
ORDER BY [p].[rider_id]


