{{ config(materialized='table') }}

WITH people AS (
    SELECT * FROM {{ source('application', 'people') }}
)

SELECT 
    PersonID AS employee_key,
    FullName AS full_name,
    PreferredName AS preferred_name,
    IsEmployee AS is_employee,
    IsSalesPerson AS is_salesperson
FROM people
WHERE IsEmployee = TRUE