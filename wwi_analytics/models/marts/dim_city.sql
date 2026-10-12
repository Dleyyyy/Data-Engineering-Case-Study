{{ config(materialized='table') }}

WITH cities AS (
    SELECT * FROM {{ source('application', 'cities') }}
),
states AS (
    SELECT * FROM {{ source('application', 'stateprovinces') }}
),
countries AS (
    SELECT * FROM {{ source('application', 'countries') }}
)

SELECT 
    c.CityID AS city_key,
    c.CityName AS city_name,
    s.StateProvinceName AS state_province_name,
    co.CountryName AS country_name,
    co.Continent AS continent,
    co.Region AS region,
    co.Subregion AS subregion,
    s.SalesTerritory AS sales_territory,
    c.Latitude AS latitude,
    c.Longitude AS longitude,
    c.LatestRecordedPopulation AS city_population
FROM cities c
LEFT JOIN states s 
    ON c.StateProvinceID = s.StateProvinceID
LEFT JOIN countries co 
    ON s.CountryID = co.CountryID