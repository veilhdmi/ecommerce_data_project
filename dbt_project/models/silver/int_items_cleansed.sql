{{ config(materialized='table') }}

SELECT
    order_id,
    item_number,
    product_id,
    seller_id,
    shipping_limit_at,
    price,
    freight_cost,
    -- Calculamos el costo total por item (precio + envío)
    (price + freight_cost) AS total_item_cost
FROM {{ ref('stg_items') }}