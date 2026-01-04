{{ config(materialized='table') }}

SELECT
    c.iso_state, 
    c.state,
    c.macro_region,
    p.category_name,
    p.macro_category,
    COUNT(i.product_id) AS total_items_sold,
    SUM(i.price) AS total_revenue
FROM {{ ref('int_items_cleansed') }} i
JOIN {{ ref('dim_products') }} p ON i.product_id = p.product_id
JOIN {{ ref('int_orders_cleansed') }} o ON i.order_id = o.order_id
JOIN {{ ref('dim_customers_enriched') }} c ON o.customer_id = c.customer_id
GROUP BY 1, 2, 3, 4, 5