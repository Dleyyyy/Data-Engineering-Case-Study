{{ config(materialized='view') }}

SELECT 
    dbt_scd_id AS customer_key,
    customer_id,
    customer_name,
    customer_category,
    buying_group,
    credit_limit,
    account_opened_date,
    standard_discount_pct,
    payment_days,
    delivery_city,
    delivery_state,
    sales_territory,
    
    CASE 
        WHEN ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY dbt_valid_from) = 1 THEN '1900-01-01'::TIMESTAMP 
        ELSE dbt_valid_from 
    END AS effective_start_date,
    
    dbt_valid_to AS effective_end_date,
    CASE WHEN dbt_valid_to IS NULL THEN TRUE ELSE FALSE END AS is_current
FROM {{ ref('snp_customer') }}