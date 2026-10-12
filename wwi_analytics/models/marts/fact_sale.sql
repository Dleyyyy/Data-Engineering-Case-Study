{{ config(materialized='table') }}

WITH invoices AS (
    SELECT * FROM {{ source('sales', 'invoices') }}
),
invoice_lines AS (
    SELECT * FROM {{ source('sales', 'invoicelines') }}
),
orders AS (
    SELECT * FROM {{ source('sales', 'orders') }}
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
    il.InvoiceLineID AS invoice_line_key,
    i.InvoiceID AS invoice_id,
    
    -- Surrogate Keys
    c.customer_key,
    e.employee_key AS salesperson_key,
    si.stock_item_key,
    d.date_key AS invoice_date_key,
    
    -- Attributes
    il.Description AS description,
    
    -- Measures
    il.Quantity AS invoiced_quantity,
    il.UnitPrice AS unit_price,
    il.TaxRate AS tax_rate,
    il.TaxAmount AS tax_amount,
    (il.Quantity * il.UnitPrice) AS extended_amount_excluding_tax,
    il.ExtendedPrice AS extended_amount_including_tax,
    il.LineProfit AS profit,
    
    -- Calculated Metrics
    CAST(i.InvoiceDate AS DATE) - CAST(o.OrderDate AS DATE) AS days_from_order_to_invoice,
    CAST(i.ConfirmedDeliveryTime AS DATE) - CAST(i.InvoiceDate AS DATE) AS days_from_invoice_to_delivery,
    
    -- Dates
    i.InvoiceDate AS invoice_date,
    i.ConfirmedDeliveryTime AS confirmed_delivery_date
    
FROM invoice_lines il
JOIN invoices i 
    ON il.InvoiceID = i.InvoiceID
LEFT JOIN orders o 
    ON i.OrderID = o.OrderID
-- SCD Type 2 Join: Match the customer record active on the invoice date
LEFT JOIN dim_customer c 
    ON i.CustomerID = c.customer_id 
    AND i.InvoiceDate >= c.effective_start_date 
    AND (i.InvoiceDate < c.effective_end_date OR c.effective_end_date IS NULL)
LEFT JOIN dim_employee e 
    ON i.SalespersonPersonID = e.employee_key
LEFT JOIN dim_stock_item si 
    ON il.StockItemID = si.stock_item_key
LEFT JOIN dim_date d 
    ON CAST(i.InvoiceDate AS DATE) = d.date