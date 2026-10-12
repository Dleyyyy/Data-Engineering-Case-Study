{% snapshot snp_customer %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='check',
      check_cols='all'
    )
}}

SELECT 
    c.CustomerID AS customer_id,
    c.CustomerName AS customer_name,
    cc.CustomerCategoryName AS customer_category,
    bg.BuyingGroupName AS buying_group,
    c.CreditLimit AS credit_limit,
    c.AccountOpenedDate AS account_opened_date,
    c.StandardDiscountPercentage AS standard_discount_pct,
    c.PaymentDays AS payment_days,
    city.CityName AS delivery_city,
    state.StateProvinceName AS delivery_state,
    state.SalesTerritory AS sales_territory
FROM {{ source('sales', 'customers') }} c
LEFT JOIN {{ source('sales', 'customercategories') }} cc 
    ON c.CustomerCategoryID = cc.CustomerCategoryID
LEFT JOIN {{ source('sales', 'buyinggroups') }} bg 
    ON c.BuyingGroupID = bg.BuyingGroupID
LEFT JOIN {{ source('application', 'cities') }} city 
    ON c.DeliveryCityID = city.CityID
LEFT JOIN {{ source('application', 'stateprovinces') }} state 
    ON city.StateProvinceID = state.StateProvinceID

{% endsnapshot %}