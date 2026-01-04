-- Ejemplo de int_orders_payments.sql
WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
payments AS (
    SELECT 
        order_id,
        SUM(amount) as total_paid
    FROM {{ ref('stg_payments') }}
    GROUP BY 1
)
SELECT 
    o.*,
    p.total_paid
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id