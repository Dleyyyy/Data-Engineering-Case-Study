{{ config(materialized='table') }}

WITH items AS (
    SELECT * FROM {{ source('warehouse', 'stockitems') }}
),
colors AS (
    SELECT * FROM {{ source('warehouse', 'colors') }}
),
packages AS (
    SELECT * FROM {{ source('warehouse', 'packagetypes') }}
)

SELECT 
    i.StockItemID AS stock_item_key,
    i.StockItemName AS stock_item_name,
    i.Brand AS brand,
    i.Size AS size,
    c.ColorName AS color,
    up.PackageTypeName AS unit_package,
    op.PackageTypeName AS outer_package,
    i.LeadTimeDays AS lead_time_days,
    i.IsChillerStock AS is_chiller_stock,
    i.TaxRate AS tax_rate,
    i.UnitPrice AS unit_price,
    i.RecommendedRetailPrice AS recommended_retail_price,
    i.TypicalWeightPerUnit AS typical_weight_per_unit
FROM items i
LEFT JOIN colors c 
    ON i.ColorID = c.ColorID
LEFT JOIN packages up 
    ON i.UnitPackageID = up.PackageTypeID
LEFT JOIN packages op 
    ON i.OuterPackageID = op.PackageTypeID