{{ config(materialized='table') }}

WITH orders AS (
    SELECT * FROM {{ ref('int_orders_cleansed') }}
),
payments AS (
    SELECT 
        order_id, 
        SUM(total_paid) AS total_order_value 
    FROM {{ ref('int_payments_cleansed') }}
    GROUP BY 1
),
-- Agregamos información del producto y cliente por cada orden
order_items_enriched AS (
    SELECT 
        i.order_id,
        -- Usamos MAX para evitar duplicar filas si una orden tiene varios productos de la misma macro_categoría
        -- O simplemente tomamos la macro_categoría predominante
        ANY_VALUE(p.macro_category) AS macro_category 
    FROM {{ ref('int_items_cleansed') }} i
    JOIN {{ ref('dim_products') }} p ON i.product_id = p.product_id
    GROUP BY 1
)

SELECT
    o.order_id,
    o.customer_id,
    o.purchase_at,
    o.status AS order_status, 
    p.total_order_value,
    o.delivery_time_days,
    -- NUEVAS COLUMNAS PARA FILTRADO CRUZADO
    c.macro_region,
    ie.macro_category
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
LEFT JOIN {{ ref('dim_customers_enriched') }} c ON o.customer_id = c.customer_id
LEFT JOIN order_items_enriched ie ON o.order_id = ie.order_id