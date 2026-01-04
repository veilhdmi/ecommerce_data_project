SELECT
    order_id,
    order_item_id as item_number,
    product_id,
    seller_id,
    CAST(shipping_limit_date AS TIMESTAMP) as shipping_limit_at,
    price,
    freight_value as freight_cost
FROM {{ source('olist_raw', 'raw_items') }}