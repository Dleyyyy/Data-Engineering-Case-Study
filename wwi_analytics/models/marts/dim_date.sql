{{ config(materialized='table') }}

WITH date_spine AS (
    SELECT 
        CAST(d AS DATE) AS date_day
    FROM GENERATE_SERIES(
        '2013-01-01'::DATE, 
        '2026-12-31'::DATE, 
        '1 day'::INTERVAL
    ) d
)

SELECT 
    TO_CHAR(date_day, 'YYYYMMDD')::INT AS date_key,
    date_day AS date,
    EXTRACT(DAY FROM date_day)::INT AS day_of_month,
    TO_CHAR(date_day, 'Day') AS weekday_name,
    EXTRACT(MONTH FROM date_day)::INT AS calendar_month,
    EXTRACT(QUARTER FROM date_day)::INT AS calendar_quarter,
    EXTRACT(YEAR FROM date_day)::INT AS calendar_year,
    
    -- Fiscal Year logic: WWI financial year begins November 1
    CASE 
        WHEN EXTRACT(MONTH FROM date_day) >= 11 THEN EXTRACT(YEAR FROM date_day)::INT + 1
        ELSE EXTRACT(YEAR FROM date_day)::INT
    END AS fiscal_year,
    
    -- Fiscal Month logic: Nov = 1, Dec = 2, Jan = 3, etc.
    CASE 
        WHEN EXTRACT(MONTH FROM date_day) >= 11 THEN EXTRACT(MONTH FROM date_day)::INT - 10
        ELSE EXTRACT(MONTH FROM date_day)::INT + 2
    END AS fiscal_month,
    
    -- Fiscal Quarter logic
    CASE 
        WHEN EXTRACT(MONTH FROM date_day) IN (11, 12, 1) THEN 1
        WHEN EXTRACT(MONTH FROM date_day) IN (2, 3, 4) THEN 2
        WHEN EXTRACT(MONTH FROM date_day) IN (5, 6, 7) THEN 3
        ELSE 4
    END AS fiscal_quarter
    
FROM date_spine