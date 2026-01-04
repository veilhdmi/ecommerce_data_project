{{ config(materialized='table') }}

SELECT
    p.product_id,
    p.category_name,
    p.macro_category,
    p.weight_kg,
    -- Traemos las métricas de venta e ítems
    COUNT(i.order_id) AS total_orders,
    SUM(i.price) AS total_revenue,
    AVG(i.freight_cost) AS avg_shipping_cost
FROM {{ ref('dim_products') }} p
LEFT JOIN {{ ref('int_items_cleansed') }} i ON p.product_id = i.product_id
GROUP BY 1, 2, 3, 4