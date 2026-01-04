{{ config(materialized='table') }}

WITH orders AS (
    -- Importante: usamos el nombre exacto de tu archivo en Silver
    SELECT * FROM {{ ref('int_orders_cleansed') }}
),
payments AS (
    SELECT 
        order_id, 
        -- En int_payments_cleansed definimos 'amount AS total_paid'
        SUM(total_paid) AS total_order_value 
    FROM {{ ref('int_payments_cleansed') }}
    GROUP BY 1
)

SELECT
    o.order_id,
    o.customer_id,
    o.purchase_at,
    -- CORRECCIÓN: En int_orders_cleansed la columna se llama 'status'
    o.status AS order_status, 
    p.total_order_value,
    o.delivery_time_days
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id