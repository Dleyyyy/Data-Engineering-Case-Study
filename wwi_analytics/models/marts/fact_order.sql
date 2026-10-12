{{ config(materialized='table') }}

WITH orders AS (
    SELECT * FROM {{ source('sales', 'orders') }}
),
order_lines AS (
    SELECT * FROM {{ source('sales', 'orderlines') }}
),
dim_date AS (
    SELECT * FROM {{ ref('dim_date') }}
),
dim_customer AS (
    SELECT * FROM {{ ref('dim_customer') }}
),
dim_employee AS (
    SELECT * FROM {{ ref('dim_employee') }}
),
dim_stock_item AS (
    SELECT * FROM {{ ref('dim_stock_item') }}
)

SELECT 
    ol.OrderLineID AS order_line_key,
    o.OrderID AS order_id,
    
    -- Surrogate Keys
    c.customer_key,
    e.employee_key AS salesperson_key,
    si.stock_item_key,
    d.date_key AS order_date_key,
    
    -- Attributes
    o.CustomerPurchaseOrderNumber AS purchase_order_number,
    ol.Description AS description,
    
    -- Measures
    ol.Quantity AS ordered_quantity,
    ol.UnitPrice AS unit_price,
    ol.TaxRate AS tax_rate,
    ol.PickedQuantity AS picked_quantity,
    
    -- Dates
    o.OrderDate AS order_date,
    o.ExpectedDeliveryDate AS expected_delivery_date,
    ol.PickingCompletedWhen AS picking_completed_date
    
FROM order_lines ol
JOIN orders o 
    ON ol.OrderID = o.OrderID
-- SCD Type 2 Join: Match the customer record active on the order date
LEFT JOIN dim_customer c 
    ON o.CustomerID = c.customer_id 
    AND o.OrderDate >= c.effective_start_date 
    AND (o.OrderDate < c.effective_end_date OR c.effective_end_date IS NULL)
LEFT JOIN dim_employee e 
    ON o.SalespersonPersonID = e.employee_key
LEFT JOIN dim_stock_item si 
    ON ol.StockItemID = si.stock_item_key
LEFT JOIN dim_date d 
    ON CAST(o.OrderDate AS DATE) = d.date