{{ config(materialized='table') }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
)

SELECT
    order_id,
    customer_id,
    status,           -- Cambio aquí
    purchase_at,      -- Cambio aquí
    delivered_at,     -- Cambio aquí
    DATEDIFF('day', purchase_at, delivered_at) AS delivery_time_days -- Snowflake usa DATEDIFF
FROM orders
WHERE order_id IS NOT NULL