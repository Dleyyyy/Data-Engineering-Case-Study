### 1. What are total sales, quantity sold, and profit by month and fiscal year?

**Query:**
SELECT 
    d.fiscal_year,
    d.calendar_month,
    SUM(f.extended_amount_excluding_tax) AS total_sales,
    SUM(f.invoiced_quantity) AS total_quantity_sold,
    SUM(f.profit) AS total_profit
FROM analytics.fact_sale f
JOIN analytics.dim_date d ON f.invoice_date_key = d.date_key
GROUP BY d.fiscal_year, d.calendar_month
ORDER BY d.fiscal_year, d.calendar_month;

**Result (Top 5 Rows):**
| fiscal_year | calendar_month | total_sales | total_quantity_sold | total_profit |
| :--- | :--- | :--- | :--- | :--- |
| 2013 | 1 | 3770410.8500000015 | 193271 | 1890687.7999999993 |
| 2013 | 2 | 2776786.2000000025 | 142120 | 1383023.299999999 |
| 2013 | 3 | 3870505.299999999 | 207486 | 1933679.050000001 |
| 2013 | 4 | 4059606.85 | 212995 | 2011957.1999999986 |
| 2013 | 5 | 4417965.55 | 230725 | 2231604.4500000007 |

---

### 2. Which products and product categories generate the highest sales and profit?

**Query:**
SELECT 
    s.stock_item_name,
    s.brand,
    s.color,
    SUM(f.extended_amount_excluding_tax) AS total_sales,
    SUM(f.profit) AS total_profit
FROM analytics.fact_sale f
JOIN analytics.dim_stock_item s ON f.stock_item_key = s.stock_item_key
GROUP BY s.stock_item_name, s.brand, s.color
ORDER BY total_sales DESC
LIMIT 10;

**Result (Top 5 Rows):**
| stock_item_name | total_sales | total_profit |
| :--- | :--- | :--- |
| Air cushion machine (Blue) | 11107251.0 | 4439391.0 |
| 32 mm Anti static bubble wrap (Blue) 50m | 6384000.0 | 3526400.0 |
| 10 mm Anti static bubble wrap (Blue) 50m | 6329070.0 | 3452220.0 |
| 20 mm Double sided bubble wrap 50m | 6214320.0 | 5293680.0 |
| 32 mm Double sided bubble wrap 50m | 6190240.0 | 2929310.0 |

---

### 3. Which customers and customer categories contribute the most revenue?

**Query:**
SELECT 
    c.customer_name,
    c.customer_category,
    SUM(f.extended_amount_excluding_tax) AS total_revenue
FROM analytics.fact_sale f
JOIN analytics.dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_name, c.customer_category
ORDER BY total_revenue DESC
LIMIT 10;

**Result (Top 5 Rows):**
| customer_name | customer_category | total_revenue |
| :--- | :--- | :--- |
| Tailspin Toys (Inguadona, MN) | Novelty Shop | 381585.35 |
| Tailspin Toys (Minidoka, ID) | Novelty Shop | 371822.30000000005 |
| Mauno Laurila | Novelty Shop | 369058.3 |
| Wingtip Toys (Sarversville, PA) | Novelty Shop | 365427.0 |
| Nasrin Omidzadeh | Supermarket | 361939.74999999994 |

---

### 4. How do sales and profit vary by city, state or province, and sales territory?

**Query:**
SELECT 
    c.sales_territory,
    c.delivery_state,
    c.delivery_city,
    SUM(f.extended_amount_excluding_tax) AS total_sales,
    SUM(f.profit) AS total_profit
FROM analytics.fact_sale f
JOIN analytics.dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.sales_territory, c.delivery_state, c.delivery_city
ORDER BY total_sales DESC;

**Result (Top 5 Rows):**
| sales_territory | delivery_state | delivery_city | total_sales | total_profit |
| :--- | :--- | :--- | :--- | :--- |
| Rocky Mountain | Wyoming | Sinclair | 564498.6999999998 | 288943.3999999999 |
| Great Lakes | Illinois | Teutopolis | 556173.1499999999 | 268520.64999999985 |
| Great Lakes | Ohio | East Fultonham | 546914.2500000001 | 280544.8 |
| Far West | Alaska | Akhiok | 542733.1999999998 | 259554.3 |
| Southeast | South Carolina | Cherry Grove Beach | 526621.15 | 257902.74999999994 |

---

### 5. Which employees or salespeople manage the highest-value orders and sales?

**Query:**
SELECT 
    e.full_name,
    SUM(f.extended_amount_excluding_tax) AS total_sales_managed,
    COUNT(DISTINCT f.invoice_id) AS total_invoices_managed
FROM analytics.fact_sale f
JOIN analytics.dim_employee e ON f.salesperson_key = e.employee_key
GROUP BY e.full_name
ORDER BY total_sales_managed DESC;

**Result (Top 5 Rows):**
| full_name | total_sales_managed | total_invoices_managed |
| :--- | :--- | :--- |
| Archer Lamble | 17944098.450000025 | 7184 |
| Kayla Woodcock | 17566878.400000013 | 7160 |
| Hudson Onslow | 17315102.700000044 | 6988 |
| Taj Shand | 17294616.500000007 | 7074 |
| Sophia Hinton | 17280089.449999962 | 7073 |

---

### 6. What proportion of ordered quantities is later invoiced?

**Query:**
WITH total_ordered AS (
    SELECT SUM(ordered_quantity) AS ordered FROM analytics.fact_order
),
total_invoiced AS (
    SELECT SUM(invoiced_quantity) AS invoiced FROM analytics.fact_sale
)
SELECT 
    o.ordered AS total_items_ordered,
    i.invoiced AS total_items_invoiced,
    ROUND((i.invoiced::numeric / o.ordered::numeric) * 100, 2) AS invoiced_percentage
FROM total_ordered o CROSS JOIN total_invoiced i;

**Result:**
| total_items_ordered | total_items_invoiced | invoiced_percentage |
| :--- | :--- | :--- |
| 9310904 | 8950628 | 96.13 |

---

### 7. How long does it take, on average, for an order to be invoiced?

**Query:**
SELECT 
    ROUND(AVG(days_from_order_to_invoice), 2) AS avg_days_to_invoice
FROM analytics.fact_sale
WHERE days_from_order_to_invoice IS NOT NULL;

**Result:**
| avg_days_to_invoice |
| :--- |
| 1.33 |

---

### 8. Which orders contain backordered items, and what is their business impact?

**Query:**
SELECT 
    o.purchase_order_number,
    o.description,
    o.ordered_quantity,
    o.picked_quantity,
    (o.ordered_quantity - o.picked_quantity) AS backordered_amount,
    (o.ordered_quantity - o.picked_quantity) * o.unit_price AS potential_delayed_revenue
FROM analytics.fact_order o
WHERE o.ordered_quantity > o.picked_quantity
ORDER BY potential_delayed_revenue DESC
LIMIT 10;

**Result (Top 5 Rows):**
| purchase_order_number | description | ordered_quantity | picked_quantity | backordered_amount | potential_delayed_revenue |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 14036 | Tape dispenser (Red) | 100 | 0 | 100 | 3200.0 |
| 16180 | Tape dispenser (Red) | 100 | 0 | 100 | 3200.0 |
| 13544 | Tape dispenser (Red) | 100 | 0 | 100 | 3200.0 |
| 17549 | Tape dispenser (Red) | 100 | 0 | 100 | 3200.0 |
| 10395 | Tape dispenser (Red) | 100 | 0 | 100 | 3200.0 |

---

### 9. How have tracked customer or product attributes changed over time?

**Query:**
SELECT 
    customer_id,
    customer_name,
    customer_category,
    effective_start_date,
    effective_end_date,
    is_current
FROM analytics.dim_customer
WHERE customer_id IN (
    SELECT customer_id 
    FROM analytics.dim_customer 
    GROUP BY customer_id 
    HAVING COUNT(*) > 1
)
ORDER BY customer_id, effective_start_date;

**Result:**
| customer_id | customer_name | customer_category | effective_start_date | effective_end_date | is_current |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Tailspin Toys (Head Office) | Novelty Shop | 1900-01-01 00:00:00.000 | 2026-10-08 04:28:23.382 | false |
| 1 | Tailspin Toys (Head Office) | Supermarket | 2026-10-08 04:28:23.382 | [NULL] | true |

---

### 10. What were the correct historical dimension attributes associated with transactions before and after an SCD change?

**Query:**
SELECT 
    f.invoice_date,
    f.extended_amount_excluding_tax,
    c.customer_name,
    c.customer_category AS category_at_time_of_sale,
    c.is_current
FROM analytics.fact_sale f
JOIN analytics.dim_customer c ON f.customer_key = c.customer_key
WHERE c.customer_id IN (
    SELECT customer_id 
    FROM analytics.dim_customer 
    GROUP BY customer_id 
    HAVING COUNT(*) > 1
)
ORDER BY f.invoice_date;

**Result (Top 5 Rows):**
| invoice_date | extended_amount_excluding_tax | customer_name | category_at_time_of_sale | is_current |
| :--- | :--- | :--- | :--- | :--- |
| 2013-03-04 00:00:00.000 | 480.0 | Tailspin Toys (Head Office) | Novelty Shop | false |
| 2013-03-04 00:00:00.000 | 210.0 | Tailspin Toys (Head Office) | Novelty Shop | false |
| 2013-03-12 00:00:00.000 | 216.0 | Tailspin Toys (Head Office) | Novelty Shop | false |
| 2013-03-12 00:00:00.000 | 750.0 | Tailspin Toys (Head Office) | Novelty Shop | false |
| 2013-03-12 00:00:00.000 | 2100.0 | Tailspin Toys (Head Office) | Novelty Shop | false |